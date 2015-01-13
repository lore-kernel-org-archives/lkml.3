Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbbAMN5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:57:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbAMN5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:57:12 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-84-54b52436d6b0
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH] tools: ffs-aio-example: use endpoint addresses from descriptors
Date: Tue, 13 Jan 2015 14:56:28 +0100
Message-id: <1421157388-18683-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsVy+t9jAV0zla0hBp8f8FgcvF9vcXnXHDaL
	RctamS3WHrnLbrHgeAurxYPDO9kd2DzW/XnF5NG3ZRWjx/Eb25k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mpo+T+LraBbomJp00HmBsbZIl2MnBwSAiYSm96dZoKwxSQu3FvP1sXIxSEksIhRYtGP
	96wQTjuTxMQ7L1lBqtgEdCS2fJ/ACGKLCAhIrH9xiR2kiFlgEqPEtfYDzCAJYYEAiXszjrOA
	2CwCqhIrv3WDxXkFXCV+f/sPtU5O4uSxyawTGLkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAgOiWfSOxhXNVgcYhTgYFTi4RXI2xIixJpYVlyZe4hRgoNZSYT3v8DWECHelMTKqtSi
	/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQZG5bXpivlVD5cxn1sXX8Qy
	d88s909BJyxFlv/2uuFkFaVbveFGXPAa3197V50t2fmaUeGryIeOGVM+CQTbOebnNn0WimB2
	+TEpsO+/1Sfx0AnWezdObOxce/70GnnjtifVk412x0go/hDl2D57hry0yjVX82mbNoQZSXnc
	0pq+hc8lK1Kd+2yIEktxRqKhFnNRcSIAZmsohQUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes examples more platform independent and more compatible with
USB standard, as endpoint addresses in given interface may differ
between hardware platforms or even between configurations in single
USB device.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 tools/usb/ffs-aio-example/multibuff/host_app/test.c | 14 ++++++++------
 tools/usb/ffs-aio-example/simple/host_app/test.c    | 17 ++++++++++-------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/usb/ffs-aio-example/multibuff/host_app/test.c b/tools/usb/ffs-aio-example/multibuff/host_app/test.c
index daa3abe..2cbcce6 100644
--- a/tools/usb/ffs-aio-example/multibuff/host_app/test.c
+++ b/tools/usb/ffs-aio-example/multibuff/host_app/test.c
@@ -33,11 +33,6 @@
 #define VENDOR	0x1d6b
 #define PRODUCT	0x0105
 
-/* endpoints indexes */
-
-#define EP_BULK_IN	(1 | LIBUSB_ENDPOINT_IN)
-#define EP_BULK_OUT	(2 | LIBUSB_ENDPOINT_OUT)
-
 #define BUF_LEN		8192
 
 /*
@@ -159,14 +154,21 @@ void test_exit(struct test_state *state)
 int main(void)
 {
 	struct test_state state;
+	struct libusb_config_descriptor *conf;
+	struct libusb_interface_descriptor const *iface;
+	unsigned char addr;
 
 	if (test_init(&state))
 		return 1;
 
+	libusb_get_config_descriptor(state.found, 0, &conf);
+	iface = &conf->interface[0].altsetting[0];
+	addr = iface->endpoint[0].bEndpointAddress;
+
 	while (1) {
 		static unsigned char buffer[BUF_LEN];
 		int bytes;
-		libusb_bulk_transfer(state.handle, EP_BULK_IN, buffer, BUF_LEN,
+		libusb_bulk_transfer(state.handle, addr, buffer, BUF_LEN,
 				     &bytes, 500);
 	}
 	test_exit(&state);
diff --git a/tools/usb/ffs-aio-example/simple/host_app/test.c b/tools/usb/ffs-aio-example/simple/host_app/test.c
index acd6332..aed86ff 100644
--- a/tools/usb/ffs-aio-example/simple/host_app/test.c
+++ b/tools/usb/ffs-aio-example/simple/host_app/test.c
@@ -33,11 +33,6 @@
 #define VENDOR	0x1d6b
 #define PRODUCT	0x0105
 
-/* endpoints indexes */
-
-#define EP_BULK_IN	(1 | LIBUSB_ENDPOINT_IN)
-#define EP_BULK_OUT	(2 | LIBUSB_ENDPOINT_OUT)
-
 #define BUF_LEN		8192
 
 /*
@@ -159,16 +154,24 @@ void test_exit(struct test_state *state)
 int main(void)
 {
 	struct test_state state;
+	struct libusb_config_descriptor *conf;
+	struct libusb_interface_descriptor const *iface;
+	unsigned char in_addr, out_addr;
 
 	if (test_init(&state))
 		return 1;
 
+	libusb_get_config_descriptor(state.found, 0, &conf);
+	iface = &conf->interface[0].altsetting[0];
+	in_addr = iface->endpoint[0].bEndpointAddress;
+	out_addr = iface->endpoint[1].bEndpointAddress;
+
 	while (1) {
 		static unsigned char buffer[BUF_LEN];
 		int bytes;
-		libusb_bulk_transfer(state.handle, EP_BULK_IN, buffer, BUF_LEN,
+		libusb_bulk_transfer(state.handle, in_addr, buffer, BUF_LEN,
 				     &bytes, 500);
-		libusb_bulk_transfer(state.handle, EP_BULK_OUT, buffer, BUF_LEN,
+		libusb_bulk_transfer(state.handle, out_addr, buffer, BUF_LEN,
 				     &bytes, 500);
 	}
 	test_exit(&state);
-- 
1.9.1

