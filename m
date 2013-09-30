Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3I3SN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:13:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52237 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3I3SN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:13:27 -0400
Message-ID: <5249BF43.705@google.com>
Date: Mon, 30 Sep 2013 11:13:23 -0700
From: Aditya Kali <adityakali@google.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatol Pomazau <anatol@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        tj@kernel.org, axboe@kernel.dk
Subject: Re: [RFC] vfs: avoid sb->s_umount lock while changing bind-mount
 flags
References: <1379353350-11320-1-git-send-email-adityakali@google.com>	<20130917024040.GH13318@ZenIV.linux.org.uk>	<523B5AEA.1070808@google.com> <CAGr1F2E1Xo7Y_xb-UXt6WCyhi0Hq+ygovuAp8pAHkwTkKOV-FA@mail.gmail.com>
In-Reply-To: <CAGr1F2E1Xo7Y_xb-UXt6WCyhi0Hq+ygovuAp8pAHkwTkKOV-FA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Ted Ts'o, Tejun Heo, Jens Axboe


On 09/30/2013 10:54 AM, Aditya Kali wrote:
> Hi Al and other fs-developers,
>
> Please let me know what you think about this patch.
>
> Thanks,
>
 > On Thu, Sep 19, 2013 at 1:13 PM, Aditya Kali <adityakali@google.com> 
wrote:
 >>
 >>
 >> On 09/16/2013 07:40 PM, Al Viro wrote:
 >>>
 >>> On Mon, Sep 16, 2013 at 10:42:30AM -0700, Aditya Kali wrote:
 >>>>
 >>>> During remount of a bind mount (mount -o remount,bind,ro,... 
/mnt/mntpt),
 >>>> we currently take down_write(&sb->s_umount). This causes the remount
 >>>> operation to get blocked behind writes occuring on device (possibly
 >>>> mounted somewhere else). We have observed that simply trying to change
 >>>> the bind-mount from read-write to read-only can take several seconds
 >>>> becuase writeback is in progress. Looking at the code it seems to 
me that
 >>>> we need s_umount lock only around the do_remount_sb() call.
 >>>> vfsmount_lock seems enough to protect the flag change on the mount.
 >>>> So this patch fixes the locking so that changing of flags can happen
 >>>> outside the down_write(&sb->s_umount).
 >>>
 >>>
 >>> What's to prevent mount -o remount,ro /mnt and mount -o 
remount,rw,nodev
 >>> /mnt
 >>> racing and ending up with that sucker rw and without nodev?
 >>
 >>
 >> Thanks for the reply! I see the problem in my patch. Please find the 
second
 >> attempt at this patch below. I have tried to keep the non-MS_BIND 
remount
 >> semantics same while moving the MS_BIND remount code outside of s_umount
 >> lock. Is it OK to not synchronize the non-MS_BIND do_remount_sb() 
call with
 >> change of mnt_flags in MS_BIND case?
 >>


---
  fs/namespace.c | 37 +++++++++++++++++++++++--------------
  1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index da5c494..25c4faf 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -454,11 +454,13 @@ void mnt_drop_write_file(struct file *file)
  }
  EXPORT_SYMBOL(mnt_drop_write_file);

+/*
+ * Must be called under br_write_lock(&vfsmount_lock);
+ */
  static int mnt_make_readonly(struct mount *mnt)
  {
  	int ret = 0;

-	br_write_lock(&vfsmount_lock);
  	mnt->mnt.mnt_flags |= MNT_WRITE_HOLD;
  	/*
  	 * After storing MNT_WRITE_HOLD, we'll read the counters. This store
@@ -492,15 +494,15 @@ static int mnt_make_readonly(struct mount *mnt)
  	 */
  	smp_wmb();
  	mnt->mnt.mnt_flags &= ~MNT_WRITE_HOLD;
-	br_write_unlock(&vfsmount_lock);
  	return ret;
  }

+/*
+ * Must be called under br_write_lock(&vfsmount_lock);
+ */
  static void __mnt_unmake_readonly(struct mount *mnt)
  {
-	br_write_lock(&vfsmount_lock);
  	mnt->mnt.mnt_flags &= ~MNT_READONLY;
-	br_write_unlock(&vfsmount_lock);
  }

  int sb_prepare_remount_readonly(struct super_block *sb)
@@ -1838,20 +1840,27 @@ static int do_remount(struct path *path, int 
flags, int mnt_flags,
  	if (err)
  		return err;

-	down_write(&sb->s_umount);
-	if (flags & MS_BIND)
+	if (flags & MS_BIND) {
+		br_write_lock(&vfsmount_lock);
  		err = change_mount_flags(path->mnt, flags);
-	else if (!capable(CAP_SYS_ADMIN))
+		if (!err) {
+			mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+			mnt->mnt.mnt_flags = mnt_flags;
+		}
+		br_write_unlock(&vfsmount_lock);
+	} else if (!capable(CAP_SYS_ADMIN))
  		err = -EPERM;
-	else
+	else {
+		down_write(&sb->s_umount);
  		err = do_remount_sb(sb, flags, data, 0);
-	if (!err) {
-		br_write_lock(&vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
-		mnt->mnt.mnt_flags = mnt_flags;
-		br_write_unlock(&vfsmount_lock);
+		if (!err) {
+			br_write_lock(&vfsmount_lock);
+			mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+			mnt->mnt.mnt_flags = mnt_flags;
+			br_write_unlock(&vfsmount_lock);
+		}
+		up_write(&sb->s_umount);
  	}
-	up_write(&sb->s_umount);
  	if (!err) {
  		br_write_lock(&vfsmount_lock);
  		touch_mnt_namespace(mnt->mnt_ns);
-- 
1.8.4

