Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935893AbaH0VEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:04:39 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:36052 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965300AbaH0VEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:30 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Wei <Wei.Yang@windriver.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 5/5] USB:gadget: Fix a warning while loading g_mass_storage
Date: Wed, 27 Aug 2014 22:58:49 +0200
Message-Id: <1409173129-19603-6-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409173129-19603-1-git-send-email-mina86@mina86.com>
References: <1409173129-19603-1-git-send-email-mina86@mina86.com>
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
do_set_interface() is running, so the value of common->new_fsg
that gets tested after do_set_interface returns needs to be
the same as the value used by do_set_interface.

Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/function/f_mass_storage.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 811929c..cf4b202 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2342,6 +2342,7 @@ static void handle_exception(struct fsg_common *common)
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
+	struct fsg_dev		*new_fsg;
 	unsigned int		exception_req_tag;
 
 	/*
@@ -2460,8 +2461,9 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		new_fsg = common->new_fsg;
+		do_set_interface(common, new_fsg);
+		if (new_fsg)
 			usb_composite_setup_continue(common->cdev);
 		break;
 
-- 
2.1.0.rc2.206.gedb03e5

