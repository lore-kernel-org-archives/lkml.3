Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3FRLoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab3FRLoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 12/93] USB: visor: fix initialisation of Treo/Kyocera devices
Date: Tue, 18 Jun 2013 12:42:20 +0100
Message-Id: <1371555821-12820-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 420021a395ce38b7ab2cceb52dee4038be7d8fa3 upstream.

Fix regression introduced by commit 214916f2e ("USB: visor: reimplement
using generic framework") which broke initialisation of Treo/Kyocera
devices that re-mapped bulk-in endpoints.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/visor.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index 90cc160..4b53336 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -570,9 +570,17 @@ static int treo_attach(struct usb_serial *serial)
 	*/
 #define COPY_PORT(dest, src)						\
 	do { \
+		int i;							\
+									\
+		for (i = 0; i < ARRAY_SIZE(src->read_urbs); ++i) {	\
+			dest->read_urbs[i] = src->read_urbs[i];		\
+			dest->read_urbs[i]->context = dest;		\
+			dest->bulk_in_buffers[i] = src->bulk_in_buffers[i]; \
+		}							\
 		dest->read_urb = src->read_urb;				\
 		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
+		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
 		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
-- 
1.8.1.2

