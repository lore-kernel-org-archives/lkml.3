Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab3FSMTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:19:16 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38215 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSMTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:19:15 -0400
From: Emil Goode <emilgoode@gmail.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] xhci: Add missing unlocks on error paths
Date: Wed, 19 Jun 2013 14:19:01 +0200
Message-Id: <1371644341-11834-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing unlocks on error paths in the
xhci_free_streams and xhci_configure_endpoint functions.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/usb/host/xhci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6779c92..2c49f00 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2603,6 +2603,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 		in_ctx = virt_dev->in_ctx;
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, in_ctx);
 	if (!ctrl_ctx) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
 				__func__);
 		return -ENOMEM;
@@ -3298,6 +3299,7 @@ int xhci_free_streams(struct usb_hcd *hcd, struct usb_device *udev,
 	command = vdev->eps[ep_index].stream_info->free_streams_command;
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, command->in_ctx);
 	if (!ctrl_ctx) {
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
 				__func__);
 		return -EINVAL;
-- 
1.7.10.4

