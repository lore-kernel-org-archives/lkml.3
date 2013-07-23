Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3GWKFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:05:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab3GWKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:05:20 -0400
Message-ID: <1374573914.30532.68.camel@marge.simpson.net>
Subject: ptrace(PTRACE_ATTACH)  [no intervering wait] ptrace(PTRACE_DETACH)
 may leave tracee stuck
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Date: Tue, 23 Jul 2013 12:05:14 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:xFFuf5VYso3KJenf3lcmJni9Cs9P2H4lZX81utOgdgr
 m+3l6mMQEy3VFVob7SUHJpfB3xc/xXFLB34C57RkYJ/RhnTKuj
 eSdhLvu0EErrTnK5q78/zrx96HPSFSQYi24fpkHOPyEroVunzM
 zB1I2a+W3Smbi1z1InWOaNg9+3ONyY1AzZ+0s/WJis8Vv0Yh68
 GwQEkIuSTaPN3akxNF5Gh3JzdS+bUtJkPfkIZ5oPJFsVrCe/ym
 EXWOp7SiBnxs9tlDWN51bv9W5ULPYJW9u6MnnRO9YC4Ip8bYZ+
 Uc2oz3+U0YvDY5Y5YMDNb7X+rHJ+2a5bKshtUa4b3zPIDdkVmj
 T2hgpHXtWSoYoYq5mJGtQ+WjCzwljFKxmTTLI8zmO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I received a report that glibc:elf/pldd hangs occasionally, and indeed..

  for i in `seq 1 1000`; do taskset -c 3 pldd $$ > /dev/null 2>&1; done

..will do so.  Rummage.....

ptrace(PTRACE_DETACH) returns -ESRCH when the trap hasn't happened yet,
which happens because pldd doesn't wait() before ptrace(PTRACE_DETACH).

pldd source:

      if (ptrace (PTRACE_ATTACH, tid, NULL, NULL) != 0)
        {
          /* There might be a race between reading the directory and
             threads terminating.  Ignore errors attaching to unknown
             threads unless this is the main thread.  */
          if (errno == ESRCH && tid != pid)
            continue;

          error (EXIT_FAILURE, errno, gettext ("cannot attach to process %lu"),
                 tid);
        } 

      struct thread_list *newp = alloca (sizeof (*newp));
      newp->tid = tid;
      newp->next = thread_list;
      thread_list = newp;
    }

  closedir (dir);

  int status = get_process_info (dfd, pid);

  assert (thread_list != NULL);
  do
    {
      ptrace (PTRACE_DETACH, thread_list->tid, NULL, NULL);
      thread_list = thread_list->next;
    }
  while (thread_list != NULL);

Seems this usually works only because cycles expended between attach and
detach is usually enough to let trap happen so tracee can set its state
to TASK_TRACED as PTRACE_DETACH expects it to be.

Is this expected behavior?  It looks a bit like "Doctor Doctor..".

-Mike

