Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3CLLYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:24:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:8241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab3CLLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,830,1355126400"; 
   d="diff'?scan'208";a="277242275"
Message-ID: <1363087506.3348.62.camel@sauron.fi.intel.com>
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Mark Jackson <mpfj-list@mimc.co.uk>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Date: Tue, 12 Mar 2013 13:25:06 +0200
In-Reply-To: <5134CEF9.5070502@mimc.co.uk>
References: <5134CEF9.5070502@mimc.co.uk>
Content-Type: multipart/mixed; boundary="=-6pErCgAiPlgD9GVVtnXj"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6pErCgAiPlgD9GVVtnXj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2013-03-04 at 16:42 +0000, Mark Jackson wrote:
> I'm encountering an oops when remounting my ubifs volume as read/write.
> 
> # mount -o remount,rw /
> [   89.434974] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
> [   89.442122] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
> [   89.451896] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b3878>] (ubifs_write_master+0x9c/0x134)
> [   89.462018] [<c01b3878>] (ubifs_write_master+0x9c/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
> [   89.472133] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
> [   89.481790] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
> [   89.490708] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
> [   89.499178] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
> [   89.510997] UBIFS assert failed in ubifs_write_node at 869 (pid 628)
> [   89.517884] [<c001b124>] (unwind_backtrace+0x0/0xf0) from [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4)
> [   89.527641] [<c01ad7d4>] (ubifs_write_node+0x180/0x1c4) from [<c01b38b4>] (ubifs_write_master+0xd8/0x134)
> [   89.537760] [<c01b38b4>] (ubifs_write_master+0xd8/0x134) from [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8)
> [   89.547869] [<c01a79a4>] (ubifs_remount_fs+0x5d4/0x7f8) from [<c010dbf4>] (do_remount_sb+0x98/0x16c)
> [   89.557526] [<c010dbf4>] (do_remount_sb+0x98/0x16c) from [<c0128268>] (do_mount+0x830/0x888)
> [   89.566435] [<c0128268>] (do_mount+0x830/0x888) from [<c0128344>] (sys_mount+0x84/0xb8)
> [   89.574905] [<c0128344>] (sys_mount+0x84/0xb8) from [<c0013800>] (ret_fast_syscall+0x0/0x3c)
> [   89.585939] UBIFS: start fixing up free space
> [   89.592237] UBIFS: background thread "ubifs_bgt0_0" started, PID 629
> [   91.419951] UBIFS: free space fixup complete
> #
> 
> If it's any help, if the remount is put into my inittab, I don't get any oops.

Would you please try this patch (also attached):

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ac838b8..9791b3c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1568,6 +1568,12 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			goto out;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
@@ -1684,12 +1690,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
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
Best Regards,
Artem Bityutskiy

--=-6pErCgAiPlgD9GVVtnXj
Content-Disposition: attachment; filename="ubifs-patch-for-mark.diff"
Content-Type: text/x-patch; name="ubifs-patch-for-mark.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index ac838b8..9791b3c 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1568,6 +1568,12 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	c->remounting_rw = 1;
 	c->ro_mount = 0;
 
+	if (c->space_fixup) {
+		err = ubifs_fixup_free_space(c);
+		if (err)
+			goto out;
+	}
+
 	err = check_free_space(c);
 	if (err)
 		goto out;
@@ -1684,12 +1690,6 @@ static int ubifs_remount_rw(struct ubifs_info *c)
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
 

--=-6pErCgAiPlgD9GVVtnXj--

