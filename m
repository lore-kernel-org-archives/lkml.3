Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3KNQg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:36:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab3KNQgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:36:45 -0500
Message-ID: <1384447002.3813.6.camel@localhost>
Subject: [GIT PULL] Audit tree for 3.13
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: rgb@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 14 Nov 2013 11:36:42 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull audit changes for 3.13.  

git://git.infradead.org/users/eparis/audit.git master

Nothing amazing.  Formatting, small bug fixes, couple of fixes where we
didn't get records due to some old VFS changes, and a change to how we
collect execve info...

There is a merge conflict which sfr has been carrying in linux-next in
fs/exec.c due to some changes in the bprm handling.  It is easy for you
to solve.  My instructions to sfr on solving the conflict was:

1) Take everything of Linus's
2) delete the 4 line audit_bprm() block of code
3) call audit_bprm() inside exec_binprm() just before
trace_sched_process_exec().   Note: audit_bprm() now returns void.

My merge diff was:

diff --cc fs/exec.c
index 8875dd1,c5c24f2..47d7edb
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -1385,71 -1383,72 +1385,68 @@@ int search_binary_handler(struct linux_
        if (retval)
                return retval;
  
-       retval = audit_bprm(bprm);
-       if (retval)
-               return retval;
- 
 +      retval = -ENOENT;
 + retry:
 +      read_lock(&binfmt_lock);
 +      list_for_each_entry(fmt, &formats, lh) {
 +              if (!try_module_get(fmt->module))
 +                      continue;
 +              read_unlock(&binfmt_lock);
 +              bprm->recursion_depth++;
 +              retval = fmt->load_binary(bprm);
 +              bprm->recursion_depth--;
 +              if (retval >= 0 || retval != -ENOEXEC ||
 +                  bprm->mm == NULL || bprm->file == NULL) {
 +                      put_binfmt(fmt);
 +                      return retval;
 +              }
 +              read_lock(&binfmt_lock);
 +              put_binfmt(fmt);
 +      }
 +      read_unlock(&binfmt_lock);
 +
 +      if (need_retry && retval == -ENOEXEC) {
 +              if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
 +                  printable(bprm->buf[2]) && printable(bprm->buf[3]))
 +                      return retval;
 +              if (request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2)) < 0)
 +                      return retval;
 +              need_retry = false;
 +              goto retry;
 +      }
 +
 +      return retval;
 +}
 +EXPORT_SYMBOL(search_binary_handler);
 +
 +static int exec_binprm(struct linux_binprm *bprm)
 +{
 +      pid_t old_pid, old_vpid;
 +      int ret;
 +
        /* Need to fetch pid before load_binary changes it */
        old_pid = current->pid;
        rcu_read_lock();
        old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
        rcu_read_unlock();
  
 -      retval = -ENOENT;
 -      for (try=0; try<2; try++) {
 -              read_lock(&binfmt_lock);
 -              list_for_each_entry(fmt, &formats, lh) {
 -                      int (*fn)(struct linux_binprm *) = fmt->load_binary;
 -                      if (!fn)
 -                              continue;
 -                      if (!try_module_get(fmt->module))
 -                              continue;
 -                      read_unlock(&binfmt_lock);
 -                      bprm->recursion_depth = depth + 1;
 -                      retval = fn(bprm);
 -                      bprm->recursion_depth = depth;
 -                      if (retval >= 0) {
 -                              if (depth == 0) {
 -                                      audit_bprm(bprm);
 -                                      trace_sched_process_exec(current, old_pid, bprm);
 -                                      ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 -                              }
 -                              put_binfmt(fmt);
 -                              allow_write_access(bprm->file);
 -                              if (bprm->file)
 -                                      fput(bprm->file);
 -                              bprm->file = NULL;
 -                              current->did_exec = 1;
 -                              proc_exec_connector(current);
 -                              return retval;
 -                      }
 -                      read_lock(&binfmt_lock);
 -                      put_binfmt(fmt);
 -                      if (retval != -ENOEXEC || bprm->mm == NULL)
 -                              break;
 -                      if (!bprm->file) {
 -                              read_unlock(&binfmt_lock);
 -                              return retval;
 -                      }
 +      ret = search_binary_handler(bprm);
 +      if (ret >= 0) {
++              audit_bprm(bprm);
 +              trace_sched_process_exec(current, old_pid, bprm);
 +              ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 +              current->did_exec = 1;
 +              proc_exec_connector(current);
 +
 +              if (bprm->file) {
 +                      allow_write_access(bprm->file);
 +                      fput(bprm->file);
 +                      bprm->file = NULL; /* to catch use-after-free */
                }
 -              read_unlock(&binfmt_lock);
 -#ifdef CONFIG_MODULES
 -              if (retval != -ENOEXEC || bprm->mm == NULL) {
 -                      break;
 -              } else {
 -#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 -                      if (printable(bprm->buf[0]) &&
 -                          printable(bprm->buf[1]) &&
 -                          printable(bprm->buf[2]) &&
 -                          printable(bprm->buf[3]))
 -                              break; /* -ENOEXEC */
 -                      if (try)
 -                              break; /* -ENOEXEC */
 -                      request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 -              }
 -#else
 -              break;
 -#endif
        }
 -      return retval;
 -}
  
 -EXPORT_SYMBOL(search_binary_handler);
 +      return ret;
 +}
  
  /*
   * sys_execve() executes a new program.


The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:

  Linux 3.11 (2013-09-02 13:46:10 -0700)

are available in the git repository at:

  git://git.infradead.org/users/eparis/audit.git master

for you to fetch changes up to 9175c9d2aed528800175ef81c90569d00d23f9be:

  audit: fix type of sessionid in audit_set_loginuid() (2013-11-06 11:47:24 -0500)

----------------------------------------------------------------
Eric Paris (10):
      audit: implement generic feature setting and retrieving
      selinux: apply selinux checks on new audit message types
      audit: loginuid functions coding style
      audit: remove CONFIG_AUDIT_LOGINUID_IMMUTABLE
      audit: allow unsetting the loginuid (with priv)
      audit: audit feature to only allow unsetting the loginuid
      audit: audit feature to set loginuid immutable
      audit: use memset instead of trying to initialize field by field
      audit: do not reject all AUDIT_INODE filter types
      audit: fix type of sessionid in audit_set_loginuid()

Eric W. Biederman (1):
      audit: Kill the unused struct audit_aux_data_capset

Gao feng (1):
      Audit: remove duplicate comments

Ilya V. Matveychikov (1):
      audit: remove duplicate inclusion of the netlink header

Jeff Layton (2):
      audit: add child record before the create to handle case where create fails
      audit: log the audit_names record type

Mathias Krause (2):
      audit: fix info leak in AUDIT_GET requests
      audit: use nlmsg_len() to get message payload length

Oleg Nesterov (1):
      audit_alloc: clear TIF_SYSCALL_AUDIT if !audit_context

Richard Guy Briggs (9):
      audit: format user messages to size of MAX_AUDIT_MESSAGE_LENGTH
      audit: remove newline accidentally added during session id helper refactor
      audit: change decimal constant to macro for invalid uid
      audit: update AUDIT_INODE filter rule to comparator function
      audit: use given values in tty_audit enable api
      audit: suppress stock memalloc failure warnings since already managed
      audit: remove unused envc member of audit_aux_data_execve
      audit: move audit_aux_data_execve contents into audit_context union
      audit: call audit_bprm() only once to add AUDIT_EXECVE information

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

 fs/exec.c                   |   5 +----
 fs/namei.c                  |   1 +
 fs/proc/base.c              |  14 ++++++++++----
 include/linux/audit.h       |  15 +++++++--------
 include/uapi/linux/audit.h  |  26 ++++++++++++++++++++++++++
 init/Kconfig                |  14 --------------
 kernel/audit.c              | 153 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------
 kernel/audit.h              |   3 +++
 kernel/auditfilter.c        |   3 ++-
 kernel/auditsc.c            | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------------------------
 security/lsm_audit.c        |   3 ++-
 security/selinux/nlmsgtab.c |   2 ++
 12 files changed, 259 insertions(+), 113 deletions(-)


