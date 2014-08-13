Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaHMK3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:29:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36882 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaHMK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:29:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kenton Varda <kenton@sandstorm.io>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<53EAD180.4010906@amacapital.net>
	<87sil1nhut.fsf@x220.int.ebiederm.org>
	<CAOP=4widH1rMZ1O=hzAT+M_8exdzRPA8pJ+wH29AQ9L0ogu9nw@mail.gmail.com>
Date: Wed, 13 Aug 2014 03:24:54 -0700
In-Reply-To: <CAOP=4widH1rMZ1O=hzAT+M_8exdzRPA8pJ+wH29AQ9L0ogu9nw@mail.gmail.com>
	(Kenton Varda's message of "Tue, 12 Aug 2014 21:45:06 -0700")
Message-ID: <87tx5ghekp.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18yRuVIFvO31ZAdNCL41UMV2jJJ68NB6Z4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Kenton Varda <kenton@sandstorm.io>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenton Varda <kenton@sandstorm.io> writes:

> On Tue, Aug 12, 2014 at 9:17 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>
>     If you can find a userspace application that matters I might care
>     
>     that a security fix breaks it.
>
> FWIW, it broke Sandstorm.io, but we already pushed a fix, and I'm not
> sure if you'd say that we "matter".

I should meant to have said:  "If you can find a userspace application
that breaks I might care that a security fix breaks it"

Hearing this actually break something changes this from a theoretical
discussion to something real.

I have a proposed fix as the end of this email.  Could you please
test it?

If I can get a Tested-by and possibly a Reviewed-by responses I would
appreciate it.

> The problem is that users like us had no idea that nodev was being
> silently added in the first place, and thus didn't know that we needed
> to specify it in remounts. 

Agreed.  And frankly that is extremely reasonable and it would in fact
break anything doing a traditional tracking of mounts with /etc/mtab.
So it is a pretty siginificant discontinuity.

I am not prepared to remove the the implicit adding of nodev from the
implementation as that would just break your code and probably others
code in a different way.

What we can do and that will work cleanly long term is make remount
match mount and implicitly add nodev.

> We create the tmpfs, put some things in it,
> and then want to remount it read-only for the sandbox. It seems
> reasonable to expect that a newly-created tmpfs would have exactly the
> flags I gave it when I created it, not silently get an additional flag
> that I then need to pass on remount.

A reasonable expectation yes.  At the same time it is also a very
reasonable security requirement to not allow devices on filesystems
that the global root does not control.

It is also reasonable that code that does not care should not have
to worry about this issue and work the same as the global root or
as a container root.  Which I think is the reasoning that I went
with when adding the implicit nodev.

> Note further that it may be very hard for normal developers to figure
> out why their remount is failing in this case. Andy only discovered
> the silent nodev by reading the kernel code.

Agreed.

So the simple solution I see with minimal danger and minimal security
risk is to remove the inconsitency between mount and remount and add
implicitly add MNT_NODEV during remount as well.

That removes the minor regression and keeps the code in the paranoid
state where device nodes are not honored and not allowed on filesystems
mounted by ordinary users.

Compared to Andy's suggestion of relaxing the nodev restriction this
will also work for filesystems like fuse and nfs when we allow begin to
allow unprivileged mounts of those filesystems, and it allows to sleep
better knowing the code is extremely paranoid.

This reminds me that the dust is settling and the man pages need to be
updated for all of these small tweaks to the API that have happened, so
there is a good source of documentation for how all of this actually
works and why.

I am going to be travelling pretty much the rest of the week, so won't
be particularly responsive.  But if you can get this tested I think
this counts as a minor regression fix that solves this issue.

Eric

From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Aug 2014 01:33:38 -0700
Subject: [PATCH] mnt: Implicitly add MNT_NODEV on remount as we do on mount

Now that remount is properly enforcing the rule that you can't
remove nodev at least sandstorm.io is breaking when performing
a remount.

It turns out that there is an easy intuitive solution implicitly
add nodev on remount under the same conditions that we do on mount.

Update the regression test for remounts to verify that this new
addition does not regress either.

Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c                                     |  9 ++++
 .../selftests/mount/unprivileged-remount-test.c    | 51 ++++++++++++----------
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7886176232c1..0f158300c866 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1934,6 +1934,15 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Only in special cases allow devices from mounts created
+	 * outside the initial user namespace.
+	 */
+	if ((mnt->mnt_ns->user_ns != &init_user_ns) &&
+	    !(sb->s_type->fs_flags & FS_USERNS_DEV_MOUNT)) {
+		flags |= MS_NODEV;
+		mnt_flags |= MNT_NODEV;
+	}
+
 	/* Don't allow changing of locked mnt flags.
 	 *
 	 * No locks need to be held here while testing the various
diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 1b3ff2fda4d0..6d408c155e0f 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -118,7 +118,8 @@ static void create_and_enter_userns(void)
 }
 
 static
-bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
+bool test_unpriv_remount(const char *fstype, const char *mount_options,
+			 int mount_flags, int remount_flags, int invalid_flags)
 {
 	pid_t child;
 
@@ -151,9 +152,11 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 			strerror(errno));
 	}
 
-	if (mount("testing", "/tmp", "ramfs", mount_flags, NULL) != 0) {
-		die("mount of /tmp failed: %s\n",
-			strerror(errno));
+	if (mount("testing", "/tmp", fstype, mount_flags, mount_options) != 0) {
+		die("mount of %s with options '%s' on /tmp failed: %s\n",
+		    fstype,
+		    mount_options? mount_options : "",
+		    strerror(errno));
 	}
 
 	create_and_enter_userns();
@@ -181,60 +184,60 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 
 static bool test_unpriv_remount_simple(int mount_flags)
 {
-	return test_unpriv_remount(mount_flags, mount_flags, 0);
+	return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags, 0);
 }
 
 static bool test_unpriv_remount_atime(int mount_flags, int invalid_flags)
 {
-	return test_unpriv_remount(mount_flags, mount_flags, invalid_flags);
+	return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags,
+				   invalid_flags);
 }
 
 int main(int argc, char **argv)
 {
-	if (!test_unpriv_remount_simple(MS_RDONLY|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_RDONLY)) {
 		die("MS_RDONLY malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NODEV)) {
+	if (!test_unpriv_remount("devpts", "newinstance", MS_NODEV, MS_NODEV, 0)) {
 		die("MS_NODEV malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NOSUID|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_NOSUID)) {
 		die("MS_NOSUID malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NOEXEC|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_NOEXEC)) {
 		die("MS_NOEXEC malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_RELATIME,
+				       MS_NOATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_STRICTATIME,
+				       MS_NOATIME))
 	{
 		die("MS_STRICTATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODEV,
-				       MS_STRICTATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_NOATIME,
+				       MS_STRICTATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME,
+				       MS_NOATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME,
+				       MS_NOATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_STRICTATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME,
+				       MS_STRICTATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount(MS_STRICTATIME|MS_NODEV, MS_NODEV,
-				 MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount("ramfs", NULL, MS_STRICTATIME, 0, MS_NOATIME))
 	{
 		die("Default atime malfunctions\n");
 	}
-- 
1.9.1

