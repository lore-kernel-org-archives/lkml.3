Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3FQR7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:59:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50411 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 17/84] USB: visor: fix initialisation of Treo/Kyocera devices
Date: Mon, 17 Jun 2013 10:30:21 -0700
Message-Id: <1371490288-23167-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 420021a395ce38b7ab2cceb52dee4038be7d8fa3 upstream.

Fix regression introduced by commit 214916f2e ("USB: visor: reimplement
using generic framework") which broke initialisation of Treo/Kyocera
devices that re-mapped bulk-in endpoints.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/visor.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
index b56bd7b..c24ee17 100644
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -566,9 +566,17 @@ static int treo_attach(struct usb_serial *serial)
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

