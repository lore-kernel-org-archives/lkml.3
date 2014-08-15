Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaHOSlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:41:46 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:45789 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaHOSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <87tx5ghekp.fsf@x220.int.ebiederm.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org> <53EAD180.4010906@amacapital.net>
 <87sil1nhut.fsf@x220.int.ebiederm.org> <CAOP=4widH1rMZ1O=hzAT+M_8exdzRPA8pJ+wH29AQ9L0ogu9nw@mail.gmail.com>
 <87tx5ghekp.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 11:41:21 -0700
Message-ID: <CALCETrXh4JLWDUmqC6knh6g0fyEMGQtajoaHzZdMaqsniiEc5Q@mail.gmail.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kenton Varda <kenton@sandstorm.io>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 3:24 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kenton Varda <kenton@sandstorm.io> writes:
>
>> On Tue, Aug 12, 2014 at 9:17 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 13 Aug 2014 01:33:38 -0700
> Subject: [PATCH] mnt: Implicitly add MNT_NODEV on remount as we do on mount
>
> Now that remount is properly enforcing the rule that you can't
> remove nodev at least sandstorm.io is breaking when performing
> a remount.
>
> It turns out that there is an easy intuitive solution implicitly
> add nodev on remount under the same conditions that we do on mount.
>
> Update the regression test for remounts to verify that this new
> addition does not regress either.

Tested-but-disliked-by: Andy Lutomirski <luto@amacapital.net>

Quoting Alan Cox [1]:

Lying to apps generally ends up like children lying to parents - the
lie gets more complicated to keep up each case you find until it
breaks.

The kernel was unnecessarily fudging mount flags, and it broke,
because the fudge didn't go far enough.  This extends the fudge.
Let's just delete it instead.

--Andy

[1] https://lwn.net/Articles/608435/

>
> Cc: stable@vger.kernel.org
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/namespace.c                                     |  9 ++++
>  .../selftests/mount/unprivileged-remount-test.c    | 51 ++++++++++++----------
>  2 files changed, 36 insertions(+), 24 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 7886176232c1..0f158300c866 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1934,6 +1934,15 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
>         if (path->dentry != path->mnt->mnt_root)
>                 return -EINVAL;
>
> +       /* Only in special cases allow devices from mounts created
> +        * outside the initial user namespace.
> +        */
> +       if ((mnt->mnt_ns->user_ns != &init_user_ns) &&
> +           !(sb->s_type->fs_flags & FS_USERNS_DEV_MOUNT)) {
> +               flags |= MS_NODEV;
> +               mnt_flags |= MNT_NODEV;
> +       }
> +
>         /* Don't allow changing of locked mnt flags.
>          *
>          * No locks need to be held here while testing the various
> diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
> index 1b3ff2fda4d0..6d408c155e0f 100644
> --- a/tools/testing/selftests/mount/unprivileged-remount-test.c
> +++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
> @@ -118,7 +118,8 @@ static void create_and_enter_userns(void)
>  }
>
>  static
> -bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
> +bool test_unpriv_remount(const char *fstype, const char *mount_options,
> +                        int mount_flags, int remount_flags, int invalid_flags)
>  {
>         pid_t child;
>
> @@ -151,9 +152,11 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
>                         strerror(errno));
>         }
>
> -       if (mount("testing", "/tmp", "ramfs", mount_flags, NULL) != 0) {
> -               die("mount of /tmp failed: %s\n",
> -                       strerror(errno));
> +       if (mount("testing", "/tmp", fstype, mount_flags, mount_options) != 0) {
> +               die("mount of %s with options '%s' on /tmp failed: %s\n",
> +                   fstype,
> +                   mount_options? mount_options : "",
> +                   strerror(errno));
>         }
>
>         create_and_enter_userns();
> @@ -181,60 +184,60 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
>
>  static bool test_unpriv_remount_simple(int mount_flags)
>  {
> -       return test_unpriv_remount(mount_flags, mount_flags, 0);
> +       return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags, 0);
>  }
>
>  static bool test_unpriv_remount_atime(int mount_flags, int invalid_flags)
>  {
> -       return test_unpriv_remount(mount_flags, mount_flags, invalid_flags);
> +       return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags,
> +                                  invalid_flags);
>  }
>
>  int main(int argc, char **argv)
>  {
> -       if (!test_unpriv_remount_simple(MS_RDONLY|MS_NODEV)) {
> +       if (!test_unpriv_remount_simple(MS_RDONLY)) {
>                 die("MS_RDONLY malfunctions\n");
>         }
> -       if (!test_unpriv_remount_simple(MS_NODEV)) {
> +       if (!test_unpriv_remount("devpts", "newinstance", MS_NODEV, MS_NODEV, 0)) {
>                 die("MS_NODEV malfunctions\n");
>         }
> -       if (!test_unpriv_remount_simple(MS_NOSUID|MS_NODEV)) {
> +       if (!test_unpriv_remount_simple(MS_NOSUID)) {
>                 die("MS_NOSUID malfunctions\n");
>         }
> -       if (!test_unpriv_remount_simple(MS_NOEXEC|MS_NODEV)) {
> +       if (!test_unpriv_remount_simple(MS_NOEXEC)) {
>                 die("MS_NOEXEC malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODEV,
> -                                      MS_NOATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_RELATIME,
> +                                      MS_NOATIME))
>         {
>                 die("MS_RELATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODEV,
> -                                      MS_NOATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_STRICTATIME,
> +                                      MS_NOATIME))
>         {
>                 die("MS_STRICTATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODEV,
> -                                      MS_STRICTATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_NOATIME,
> +                                      MS_STRICTATIME))
>         {
>                 die("MS_RELATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME|MS_NODEV,
> -                                      MS_NOATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME,
> +                                      MS_NOATIME))
>         {
>                 die("MS_RELATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME|MS_NODEV,
> -                                      MS_NOATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME,
> +                                      MS_NOATIME))
>         {
>                 die("MS_RELATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME|MS_NODEV,
> -                                      MS_STRICTATIME|MS_NODEV))
> +       if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME,
> +                                      MS_STRICTATIME))
>         {
>                 die("MS_RELATIME malfunctions\n");
>         }
> -       if (!test_unpriv_remount(MS_STRICTATIME|MS_NODEV, MS_NODEV,
> -                                MS_NOATIME|MS_NODEV))
> +       if (!test_unpriv_remount("ramfs", NULL, MS_STRICTATIME, 0, MS_NOATIME))
>         {
>                 die("Default atime malfunctions\n");
>         }
> --
> 1.9.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
