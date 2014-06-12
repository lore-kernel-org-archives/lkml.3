Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaFLLjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:39:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:43732 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbaFLLjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:39:32 -0400
X-Nat-Received: from [202.181.97.72]:28163 [ident-empty]
	by ksav105.sakura.ne.jp with TPROXY id 1402573165.31707
To: viro@ZenIV.linux.org.uk
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pre 3.16-rc1] Oops at spin_trylock(&inode->i_lock)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201406102104.FAG04640.MVJFSQOHtOFOFL@I-love.SAKURA.ne.jp>
	<20140610143425.GL4581@linux.vnet.ibm.com>
	<201406112035.ADB51545.QFVMLJOtFOHSOF@I-love.SAKURA.ne.jp>
	<20140611160133.GX18016@ZenIV.linux.org.uk>
In-Reply-To: <20140611160133.GX18016@ZenIV.linux.org.uk>
Message-Id: <201406122039.DIG40672.tSHOQFOVMFFLOJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 12 Jun 2014 20:39:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.705 status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Try to check if this helps:

Yes, that helps. Thank you.

I used below version and the oops no longer occur.

---------- patch start ----------
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -532,10 +532,15 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
+	if (WARN_ON_ONCE((int)dentry->d_lockref.count < 0)) {
+		pr_warn("dentry->d_lockref.count=%d dentry->d_sb->s_magic=%lx\n",
+			dentry->d_lockref.count, dentry->d_sb->s_magic);
+		return NULL;
+	}
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
-	spin_unlock(&dentry->d_lock);
 	rcu_read_lock();
+	spin_unlock(&dentry->d_lock);
 again:
 	parent = ACCESS_ONCE(dentry->d_parent);
 	spin_lock(&parent->d_lock);
---------- patch end ----------

ef53 is ext4, 9fa0 is proc, 62656572 is sysfs.
I don't know why only sysfs triggered the oops.

---------- console log on boot ----------
[    6.987663] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    7.071152] dracut: Mounted root filesystem /dev/sda1
[    7.275840] random: nonblocking pool is initialized
[    7.414446] load_policy (374) used greatest stack depth: 10832 bytes left
[    7.417446] dracut: /sbin/load_policy: Can't load policy: No such device
[    7.630160] dracut: Switching root
[    8.333437] ------------[ cut here ]------------
[    8.333737] WARNING: CPU: 1 PID: 394 at fs/dcache.c:535 shrink_dentry_list+0x388/0x400()
[    8.334546] Modules linked in: ext4(E) jbd2(E) mbcache(E) crc16(E) sd_mod(E) crc_t10dif(E) sr_mod(E) cdrom(E) mptspi(E) mptscsih(E) mptbase(E) scsi_transport_spi(E) pata_acpi(E) ata_generic(E) ata_piix(E)
[    8.336012] CPU: 1 PID: 394 Comm: mount Tainted: G            E 3.15.0-08974-g3c81bdd-dirty #390
[    8.337616] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[    8.339667]  0000000000000217 ffff88004b20bd18 ffffffff8163844d ffffffff81a23cef
[    8.340469]  0000000000000000 ffff88004b20bd58 ffffffff81054d9c ffff880048ca6fb0
[    8.340908]  ffff880078c06eb0 ffff880048ca6eb0 ffff880048ca6fb0 ffff88004b20bdd8
[    8.341841] Call Trace:
[    8.342440]  [<ffffffff8163844d>] dump_stack+0x51/0x6c
[    8.343495]  [<ffffffff81054d9c>] warn_slowpath_common+0x8c/0xc0
[    8.344556]  [<ffffffff81054dea>] warn_slowpath_null+0x1a/0x20
[    8.344764]  [<ffffffff811e71b8>] shrink_dentry_list+0x388/0x400
[    8.345536]  [<ffffffff811e7369>] shrink_dcache_sb+0xd9/0x120
[    8.346501]  [<ffffffff811f14fd>] ? do_remount+0x9d/0x130
[    8.347564]  [<ffffffff811cf6e2>] do_remount_sb+0x52/0x1a0
[    8.348506]  [<ffffffff811f14fd>] ? do_remount+0x9d/0x130
[    8.349520]  [<ffffffff811f1585>] do_remount+0x125/0x130
[    8.350552]  [<ffffffff811f4962>] do_mount+0x1b2/0x210
[    8.351496]  [<ffffffff811810fb>] ? strndup_user+0x5b/0x80
[    8.352501]  [<ffffffff811f4a50>] SyS_mount+0x90/0xe0
[    8.353500]  [<ffffffff816483a2>] system_call_fastpath+0x16/0x1b
[    8.354533] ---[ end trace eddfc2138fdcf65f ]---
[    8.355486] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=9fa0
(...snipped...)
[    8.431502] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=9fa0
		Welcome to CentOS 
---------- console log on boot ----------

---------- console log on shutdown ----------
init: Re-executing /sbin/init

[   76.646596] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=ef53
(...snipped...)
[   76.701837] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=ef53
[   76.718264] EXT4-fs (sda1): re-mounted. Opts: (null)
[   76.962112] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=9fa0
(...snipped...)
[   77.100116] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=9fa0
[   77.110684] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=62656572
(...snipped...)
[   77.424319] dentry->d_lockref.count=-128 dentry->d_sb->s_magic=62656572
Please stand by while rebooting the system...
[   77.556052] reboot: Restarting system
[   77.556942] reboot: machine restart
---------- console log on shutdown ----------
