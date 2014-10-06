Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaJFTT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:19:57 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:61643 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaJFTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:19:55 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4/4] ipmi: Clear drvdata when interface is removed
Date: Mon,  6 Oct 2014 14:17:53 -0500
Message-Id: <1412623073-6166-5-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1412623073-6166-1-git-send-email-minyard@acm.org>
References: <1412623073-6166-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takao Indoh <indou.takao@jp.fujitsu.com>

This patch fixes a bug on hotmod removing.

After ipmi interface is removed using hotmod, kernel panic occurs when
rmmod impi_si. For example, try this:

 # echo "remove,"`cat /proc/ipmi/0/params` > \
 /sys/module/ipmi_si/parameters/hotmod
 # rmmod ipmi_si

Then, rmmod fails with the following messages.

------------[ cut here ]------------
WARNING: CPU: 12 PID: 10819 at /mnt/repos/linux/lib/list_debug.c:53
__list_del_entry+0x63/0xd0()
(snip)
CPU: 12 PID: 10819 Comm: rmmod Not tainted 3.17.0-rc1 #19
Hardware name: FUJITSU-SV PRIMERGY BX920 S2/D3030, BIOS 080015
Rev.3D81.3030 02/10/2012
 0000000000000009 ffff88022d547d40 ffffffff81575778 ffff88022d547d88
 ffff88022d547d78 ffffffff8104ec5d ffff88023908cdb0 ffffffffa06fa4e0
 ffff8800bac20860 0000000000000000 0000000002046090 ffff88022d547dd8
Call Trace:
 [<ffffffff81575778>] dump_stack+0x45/0x56
 [<ffffffff8104ec5d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8104eccc>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff811f60bf>] ? __kernfs_remove+0xdf/0x220
 [<ffffffff81291213>] __list_del_entry+0x63/0xd0
 [<ffffffff8129128d>] list_del+0xd/0x30
 [<ffffffffa06f285a>] cleanup_one_si+0x2a/0x230 [ipmi_si]
 [<ffffffffa06f2f05>] ipmi_pnp_remove+0x15/0x20 [ipmi_si]
 [<ffffffff8131c7d4>] pnp_device_remove+0x24/0x40
 [<ffffffff8137175f>] __device_release_driver+0x7f/0xf0
 [<ffffffff81372100>] driver_detach+0xb0/0xc0
 [<ffffffff81371415>] bus_remove_driver+0x55/0xd0
 [<ffffffff8137283c>] driver_unregister+0x2c/0x50
 [<ffffffff8131ca02>] pnp_unregister_driver+0x12/0x20
 [<ffffffffa06f347c>] cleanup_ipmi_si+0xbc/0xf0 [ipmi_si]
 [<ffffffff810c33f2>] SyS_delete_module+0x132/0x1c0
 [<ffffffff81002ab9>] ? do_notify_resume+0x59/0x80
 [<ffffffff8157c45a>] ? int_signal+0x12/0x17
 [<ffffffff8157c1d2>] system_call_fastpath+0x16/0x1b
---[ end trace 70b4377268f85c23 ]---

list_del in cleanup_one_si() fails because the smi_info is already
removed when hotmod removing.

When ipmi interface is removed by hotmod, smi_info is removed by
cleanup_one_si(), but is is still set in drvdata. Therefore when rmmod
ipmi_si, ipmi_pnp_remove tries to remove it again and fails.

By this patch, a pointer to smi_info in drvdata is cleared when hotmod
removing so that it will be not accessed when rmmod.

changelog:
v2:
- Clear drvdata in cleanup_one_si
- Change subject

v1:
https://lkml.org/lkml/2014/9/8/741

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 1c43f9a..5c4e1f6 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -3658,6 +3658,9 @@ static void cleanup_one_si(struct smi_info *to_clean)
 	if (!to_clean)
 		return;
 
+	if (to_clean->dev)
+		dev_set_drvdata(to_clean->dev, NULL);
+
 	list_del(&to_clean->link);
 
 	/* Tell the driver that we are shutting down. */
-- 
1.8.3.1

