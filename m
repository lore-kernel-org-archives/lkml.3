Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3CNJNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:13:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:1740 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3CNJNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:13:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,843,1355126400"; 
   d="cfg'?sh'?scan'208,223";a="270604223"
Message-ID: <1363252425.11441.94.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Thu, 14 Mar 2013 11:13:45 +0200
In-Reply-To: <51405F3A.3090901@mimc.co.uk>
References: <5134CEF9.5070502@mimc.co.uk>
	 <1363087506.3348.62.camel@sauron.fi.intel.com>
	 <51405F3A.3090901@mimc.co.uk>
Content-Type: multipart/mixed; boundary="=-YlVgXk/tIznaGNfH/Lkm"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YlVgXk/tIznaGNfH/Lkm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-03-13 at 11:12 +0000, Mark Jackson wrote:
> Sorry ... this just locks up the unit.

OK, I've reproduced the issue with 3.9-rc2 in nandsim, see the details
below. The patch I proposed did not get the error path correctly, but it
does fix the issue.

I think what you treat as "lockup" is the fixup process. UBIFS basically
reads the entire UBI volume and writes it back. And it uses the atomic
change UBI service, which means it also calculates CRC of everything it
writes. And this all just takes a lot of time. This has to be done only
once on the first mount.

I've attached the following:

1. The patch which fixes the issue when I use nandsim. It is also
   inlined in the end. Please, give it a try and be more patient -
   wait longer. Please, do report your results back.
2. 'reproduce.sh' - a quick and dirty shell script which reproduces the
    problem
3. ubinize.cfg - is needed for 'reproduce.sh'.


Thanks!

>From a173f8e9296562e5ece3dd2936d799001897d6c6 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 14 Mar 2013 10:49:23 +0200
Subject: [PATCH] UBIFS: make space fixup work in the remount case

The UBIFS space fixup is a useful feature which allows to fixup the "broken"
flash space at the time of the first mount. The "broken" space is usually the
result of using a "dumb" industrial flasher which is not able to skip empty
NAND pages and just writes all 0xFFs to the empty space, which has grave
side-effects for UBIFS when UBIFS trise to write useful data to those empty
pages.

The fix-up feature works roughly like this:
1. mkfs.ubifs sets the fixup flag in UBIFS superblock when creating the image
   (see -F option)
2. when the file-system is mounted for the first time, UBIFS notices the fixup
   flag and re-writes the entire media atomically, which may take really a lot
   of time.
3. UBIFS clears the fixup flag in the superblock.

This works fine when the file system is mounted R/W for the very first time.
But it did not really work in the case when we first mount the file-system R/O,
and then re-mount R/W. The reason was that we started the fixup procedure too
late, which we cannot really do because we have to fixup the space before it
starts being used.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reported-by: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: stable@vger.kernel.org # 3.0+
---
 fs/ubifs/super.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ac838b8..fa4aec6 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1568,10 +1568,17 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			return err;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
 
+
 	if (c->old_leb_cnt != c->leb_cnt) {
 		struct ubifs_sb_node *sup;
 
@@ -1684,12 +1691,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		err = dbg_check_space_info(c);
 	}
 
-	if (c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out;
-	}
-
 	mutex_unlock(&c->umount_mutex);
 	return err;
 
-- 
1.7.7.6

-- 
Best Regards,
Artem Bityutskiy

--=-YlVgXk/tIznaGNfH/Lkm
Content-Disposition: attachment;
	filename="0001-UBIFS-make-space-fixup-work-in-the-remount-case.patch"
Content-Type: text/x-patch;
	name="0001-UBIFS-make-space-fixup-work-in-the-remount-case.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From a173f8e9296562e5ece3dd2936d799001897d6c6 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 14 Mar 2013 10:49:23 +0200
Subject: [PATCH] UBIFS: make space fixup work in the remount case

The UBIFS space fixup is a useful feature which allows to fixup the "broken"
flash space at the time of the first mount. The "broken" space is usually the
result of using a "dumb" industrial flasher which is not able to skip empty
NAND pages and just writes all 0xFFs to the empty space, which has grave
side-effects for UBIFS when UBIFS trise to write useful data to those empty
pages.

The fix-up feature works roughly like this:
1. mkfs.ubifs sets the fixup flag in UBIFS superblock when creating the image
   (see -F option)
2. when the file-system is mounted for the first time, UBIFS notices the fixup
   flag and re-writes the entire media atomically, which may take really a lot
   of time.
3. UBIFS clears the fixup flag in the superblock.

This works fine when the file system is mounted R/W for the very first time.
But it did not really work in the case when we first mount the file-system R/O,
and then re-mount R/W. The reason was that we started the fixup procedure too
late, which we cannot really do because we have to fixup the space before it
starts being used.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: stable@vger.kernel.org # 3.0+
---
 fs/ubifs/super.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ac838b8..fa4aec6 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1568,10 +1568,17 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			return err;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
 
+
 	if (c->old_leb_cnt != c->leb_cnt) {
 		struct ubifs_sb_node *sup;
 
@@ -1684,12 +1691,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		err = dbg_check_space_info(c);
 	}
 
-	if (c->space_fixup) {
-		err = ubifs_fixup_free_space(c);
-		if (err)
-			goto out;
-	}
-
 	mutex_unlock(&c->umount_mutex);
 	return err;
 
-- 
1.7.7.6


--=-YlVgXk/tIznaGNfH/Lkm
Content-Type: application/x-shellscript; name="reproduce.sh"
Content-Disposition: attachment; filename="reproduce.sh"
Content-Transfer-Encoding: 7bit

#!/bin/sh -euf

umount /mnt/ubifs ||:
rmmod ubifs ||:
rmmod ubi ||:
rmmod nandsim ||:

modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa third_id_byte=0x00 fourth_id_byte=0x15
modprobe ubi
modprobe ubifs

mkfs.ubifs -F -r /home/dedekind/bin -m 2048 -e 129024 -c 2047 -o ubifs.img
ubinize -o ubi.img -m 2048 -p 128KiB -s 512 ubinize.cfg

dd if=ubi.img of=/dev/mtd0
sync
ubiattach -p /dev/mtd0
mount -t ubifs -o ro ubi0_0 /mnt/ubifs
mount -o remount ubi0_0 /mnt/ubifs

--=-YlVgXk/tIznaGNfH/Lkm
Content-Disposition: attachment; filename="ubinize.cfg"
Content-Type: text/plain; name="ubinize.cfg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[ubifs]
mode=ubi
image=ubifs.img
vol_id=0
vol_size=200MiB
vol_type=dynamic
vol_name=rootfs
vol_flags=autoresize

--=-YlVgXk/tIznaGNfH/Lkm--

