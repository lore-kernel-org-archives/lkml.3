Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaEKPyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 11:54:09 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:41722 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713AbaEKPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 11:54:07 -0400
X-Nat-Received: from [202.181.97.72]:12253 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399823631.4607
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com
Cc: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH (for 3.15) 0/5] Fix cross rename race window for LSM.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
In-Reply-To: <201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
Message-Id: <201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 00:53:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11052014 #7888959, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos, I have a question regarding renameat2(RENAME_EXCHANGE).
renameat2(RENAME_EXCHANGE) allows exchanging a directory and a non-directory,
doesn't it? If yes, TOMOYO and AppArmor got a regression bug described below.

TOMOYO and AppArmor handle pathnames of a directory and a non-directory
differently. It is considered as a directory's pathname if the pathname ends
with / , and it is considered as a non-directory's pathname if the pathname
does not end with / .

Until renameat2(RENAME_EXCHANGE) was introduced, if the old_dentry refers a
directory, it is guaranteed that the new_dentry will refer a directory upon
successful rename() operation. Therefore, TOMOYO and AppArmor automatically
appended / to the pathname calculated from new_dentry based on
S_ISDIR(old_dentry->d_inode->i_mode).

  int tomoyo_path2_perm(const u8 operation, struct path *path1,
                        struct path *path2)
  {
  (...snipped...)
          if (!tomoyo_get_realpath(&buf1, path1) ||
              !tomoyo_get_realpath(&buf2, path2))
                  goto out;
          switch (operation) {
                  struct dentry *dentry;
          case TOMOYO_TYPE_RENAME:
          case TOMOYO_TYPE_LINK:
                  dentry = path1->dentry;
                  if (!dentry->d_inode || !S_ISDIR(dentry->d_inode->i_mode))
                          break;
                  /* fall through */
          case TOMOYO_TYPE_PIVOT_ROOT:
                  tomoyo_add_slash(&buf1);
                  tomoyo_add_slash(&buf2);
                  break;
          }
  (...snipped...)
  }

  static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
                                  struct path *new_dir, struct dentry *new_dentry)
  {
  (...snipped...)
                  struct path_cond cond = { old_dentry->d_inode->i_uid,
                                            old_dentry->d_inode->i_mode
                  };
  
                  error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
                                       MAY_READ | AA_MAY_META_READ | MAY_WRITE |
                                       AA_MAY_META_WRITE | AA_MAY_DELETE,
                                       &cond);
                  if (!error)
                          error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
                                               0, MAY_WRITE | AA_MAY_META_WRITE |
                                               AA_MAY_CREATE, &cond);
  (...snipped...)
  }

Now, as renameat2(RENAME_EXCHANGE) is introduced, it is no longer guaranteed
that the new_dentry will refer a directory upon successful
renameat2(RENAME_EXCHANGE) because renameat2(RENAME_EXCHANGE) allows exchanging
a directory's pathname and a non-directory's pathname. TOMOYO and AppArmor can
no longer automatically append / to the pathname calculated from new_dentry
based on S_ISDIR(old_dentry->d_inode->i_mode).

To fix this problem, TOMOYO and AppArmor need to receive the flags argument and
use S_ISDIR(new_dentry->d_inode->i_mode) if renameat2(RENAME_EXCHANGE) and use
S_ISDIR(old_dentry->d_inode->i_mode) if renameat2(!RENAME_EXCHANGE).

Regarding TOMOYO, "[PATCH (for 3.15) 4/5] TOMOYO: Handle the rename flags." can
fix this problem. Regarding AppArmor, we need to update
"[PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.".

Anyway, James, can we merge
"[PATCH (for 3.15) 1/5] LSM: Pass the rename flags to each LSM module." now?

Tetsuo Handa wrote:
> Hello SELinux people, may I have your response?
> 
> Miklos Szeredi posted v3 of cross rename patchset at
> http://marc.info/?l=linux-fsdevel&m=138921924707564&w=4 . In that thread,
> I questioned him whether he already explained this proposal to LSM people.
> He answered no and explained me what renameat2() does. I asked him to get
> confirmation from LSM people before he merges this change to linux-next.git
> tree, and he answered that patch 07/11 already does what LSM people need. But
> I commented that TOMOYO wants to avoid re-calculation of pathnames and posted
> a patch at http://marc.info/?l=linux-security-module&m=138970469226106&w=4 and
> John Johansen commented that the changes in AppArmor directory looks OK and
> John would re-factor AppArmor to avoid re-calculation in the future. Therefore,
> I posted a patch for SELinux/SMACK/Capability at
> http://marc.info/?l=linux-fsdevel&m=138973289404450&w=4 but Miklos responded
> that he doesn't want to include my patch which temporarily breaks TOMOYO and
> AppArmor. Instead, he asked me to post a complete patch right after his cross
> rename patchset goes in. Thus, I was waiting for his cross rename patchset to
> arrive at linux-next.git tree.
> 
> By the day Linux 3.14 was released, Miklos's cross rename patchset did not
> arrive at linux-next.git tree. Therefore, I assumed that the cross rename
> patchset will not go to Linux 3.15-rc1. However, the patchset committed after
> Linux 3.14 release (commit da1ce067 "vfs: add cross-rename") directly went to
> linux.git tree without letting it known to LSM people and the merge window for
> Linux 3.15 was closed. Then, I noticed that renameat2() will be in 3.15 at
> http://marc.info/?l=linux-fsdevel&m=139789855823422&w=2 .
> 
> At first, I assumed that renameat2() is not callable as of 3.15 because I
> couldn't find "#define __NR_renameat2" line. But Miklos told me that
> renameat2() will be callable as of 3.15 because x86 automatically generates
> __NR_renameat2 entries. I realized that TOMOYO and AppArmor now have a race
> window (a kind of regression) introduced by the cross rename functionality, and
> I re-posted my patch as a patchset in this thread. I can approve the changes in
> TOMOYO directory and John Johansen already gave me a sort of Reviewed-by:
> response to the changes in AppArmor directory in January's thread. In this
> thread, Casey Schaufler gave me an Acked-by: response to the changes in SMACK
> directory, but so far I have gotten no response from SELinux people.
> 
> Would somebody in SELinux community please respond to the changes in SELinux
> directory so that we can merge this race window fix patchset before 3.15-final?
> 
> Regards.
> 
> Tetsuo Handa wrote:
> > James, would you send this patchset to Linus?
> > This patchset is expected to go to 3.15 because this is a kind of regression fix.
> > 
> > Tetsuo Handa wrote:
> > > Miklos Szeredi wrote:
> > > > On Sat, Apr 19, 2014 at 2:08 PM, Tetsuo Handa
> > > > <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > > > > Michael Kerrisk (man-pages) wrote:
> > > > >> Now that renameat2() is in 3.15, I've taken these changes.
> > > > >
> > > > > What!? I didn't know renameat2() goes to 3.15.
> > > > >
> > > > > But I assume that renameat2() is not accessible in 3.15, for I can see
> > > > > "asmlinkage long sys_renameat2(" but don't see "#define __NR_renameat2".
> > > > 
> > > > x86 automatically generates __NR_foo entries and syscall tables from
> > > > arch/x86/syscalls/syscall_*.tbl, which is why you don't find an
> > > > explicit definition in the git tree.
> > > > 
> > > > Thanks,
> > > > Miklos
> > > > 
> > > 
> > > Oh, I see. Then, I must submit patches for fixing a race window
> > > caused by commit da1ce067 "vfs: add cross-rename".
> > > 
> > > Regards.
> > > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
