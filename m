Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab3DXLQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:16:41 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:47579 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab3DXLQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:16:39 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] usb: gadget: multi: Mark {cdc,rndis}_config_register() __init
Date: Wed, 24 Apr 2013 13:16:35 +0200
Message-Id: <1366802195-15479-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gcc (e.g. 4.1.2) decides not to inline cdc_config_register() and
rndis_config_register(), this will cause section mismatch warnings:

WARNING: drivers/usb/gadget/g_multi.o(.text+0x32f6): Section mismatch in reference from the function cdc_config_register() to the function .init.text:cdc_do_config()
The function cdc_config_register() references
the function __init cdc_do_config().
This is often because cdc_config_register lacks a __init
annotation or the annotation of cdc_do_config is wrong.

WARNING: drivers/usb/gadget/g_multi.o(.text+0x3326): Section mismatch in reference from the function rndis_config_register() to the function .init.text:rndis_do_config()
The function rndis_config_register() references
the function __init rndis_do_config().
This is often because rndis_config_register lacks a __init
annotation or the annotation of rndis_do_config is wrong.

Fortunately they're harmless, as {cdc,rndis}_config_register() are only
called from multi_bind(), which is annotated with __ref.

Mark {cdc,rndis}_config_register() with the __init annotation to kill the
warning.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Note: I did not verify that multi_bind() is rightfully marked __ref.

 drivers/usb/gadget/multi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 20bbbf9..db63d9e 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -177,7 +177,7 @@ err_func_acm:
 	return ret;
 }
 
-static int rndis_config_register(struct usb_composite_dev *cdev)
+static __init int rndis_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
 		.bConfigurationValue	= MULTI_RNDIS_CONFIG_NUM,
@@ -192,7 +192,7 @@ static int rndis_config_register(struct usb_composite_dev *cdev)
 
 #else
 
-static int rndis_config_register(struct usb_composite_dev *cdev)
+static __init int rndis_config_register(struct usb_composite_dev *cdev)
 {
 	return 0;
 }
@@ -240,7 +240,7 @@ err_func_acm:
 	return ret;
 }
 
-static int cdc_config_register(struct usb_composite_dev *cdev)
+static __init int cdc_config_register(struct usb_composite_dev *cdev)
 {
 	static struct usb_configuration config = {
 		.bConfigurationValue	= MULTI_CDC_CONFIG_NUM,
@@ -255,7 +255,7 @@ static int cdc_config_register(struct usb_composite_dev *cdev)
 
 #else
 
-static int cdc_config_register(struct usb_composite_dev *cdev)
+static __init int cdc_config_register(struct usb_composite_dev *cdev)
 {
 	return 0;
 }
-- 
1.7.0.4

