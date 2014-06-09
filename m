Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaFIGUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:20:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:35362 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaFIGUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:20:13 -0400
From: <Wei.Yang@windriver.com>
To: <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <mina86@mina86.com>, <andrzej.p@samsung.com>,
        <wei.yang@windriver.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] USB:gadget: Fix a warning while loading g_mass_storage
Date: Mon, 9 Jun 2014 14:19:58 +0800
Message-ID: <1402294798-27401-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401856367-12553-1-git-send-email-Wei.Yang@windriver.com>
References: <1401856367-12553-1-git-send-email-Wei.Yang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

While loading g_mass_storage module, the following warning
is triggered.

WARNING: at drivers/usb/gadget/composite.c:
usb_composite_setup_continue: Unexpected call
Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
[<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
[<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
[<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
[<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
[<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
[<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
[<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
[<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)

The root cause is that the existing code fails to take into
account the possibility that common->new_fsg can change while
do_set_interface() is running, because the spinlock isn't held
at this point.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/f_mass_storage.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Hi Alan,

Thanks for your review, there are a few changes in v3:

1) Fix a coding style issue.
2) Refine the commit log

Regards
Wei

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b963939..0cd8f21 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2342,6 +2342,7 @@ static void handle_exception(struct fsg_common *common)
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
+	struct fsg_dev		*new_fsg;
 	unsigned int		exception_req_tag;
 
 	/*
@@ -2421,6 +2422,7 @@ static void handle_exception(struct fsg_common *common)
 		}
 		common->state = FSG_STATE_IDLE;
 	}
+	new_fsg = common->new_fsg;
 	spin_unlock_irq(&common->lock);
 
 	/* Carry out any extra actions required for the exception */
@@ -2460,8 +2462,8 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		do_set_interface(common, new_fsg);
+		if (new_fsg)
 			usb_composite_setup_continue(common->cdev);
 		break;
 
-- 
1.7.9.5

