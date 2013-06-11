Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3FKUDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab3FKUDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 11/32] USB: visor: fix initialisation of Treo/Kyocera devices
Date: Tue, 11 Jun 2013 13:03:10 -0700
Message-Id: <20130611200127.466615613@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 420021a395ce38b7ab2cceb52dee4038be7d8fa3 upstream.

Fix regression introduced by commit 214916f2e ("USB: visor: reimplement
using generic framework") which broke initialisation of Treo/Kyocera
devices that re-mapped bulk-in endpoints.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/visor.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -596,9 +596,17 @@ static int treo_attach(struct usb_serial
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
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\


