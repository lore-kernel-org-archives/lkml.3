Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaIPVqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:46:53 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60167 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbaIPVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:46:51 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:51 +0000
Message-Id: <1410910735-27929-15-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 14/18] usbip: Wrap kernel_sendmsg()/recvmsg()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

This adds two simple wrappers around kernel_sendmsg() and
kernel_recvmsg() that can be extended to perform additional
cryptographic operations on the data before sending it.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/usb/usbip/stub_rx.c      |  2 +-
 drivers/usb/usbip/stub_tx.c      |  6 ++--
 drivers/usb/usbip/usbip_common.c | 64 +++++++++++++++++++++-------------------
 drivers/usb/usbip/usbip_common.h |  7 ++++-
 drivers/usb/usbip/vhci_rx.c      |  2 +-
 drivers/usb/usbip/vhci_tx.c      |  4 +--
 6 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 00e475c..64b61bf5 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -544,7 +544,7 @@ static void stub_rx_pdu(struct usbip_device *ud)
 	memset(&pdu, 0, sizeof(pdu));
 
 	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	ret = usbip_recv(ud, &pdu, sizeof(pdu));
 	if (ret != sizeof(pdu)) {
 		dev_err(dev, "recv a header, %d\n", ret);
 		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
diff --git a/drivers/usb/usbip/stub_tx.c b/drivers/usb/usbip/stub_tx.c
index dbcabc9..06ccbcb 100644
--- a/drivers/usb/usbip/stub_tx.c
+++ b/drivers/usb/usbip/stub_tx.c
@@ -258,8 +258,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 			iovnum++;
 		}
 
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
-						iov,  iovnum, txsize);
+		ret = usbip_sendmsg(&sdev->ud, &msg, iov, iovnum, txsize);
 		if (ret != txsize) {
 			dev_err(&sdev->interface->dev,
 				"sendmsg failed!, retval %d for %zd\n",
@@ -333,8 +332,7 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
 		iov[0].iov_len  = sizeof(pdu_header);
 		txsize += sizeof(pdu_header);
 
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
-				     1, txsize);
+		ret = usbip_sendmsg(&sdev->ud, &msg, iov, 1, txsize);
 		if (ret != txsize) {
 			dev_err(&sdev->interface->dev,
 				"sendmsg failed!, retval %d for %zd\n",
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index facaaf0..559fe53 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -322,7 +322,7 @@ void usbip_dump_header(struct usbip_header *pdu)
 EXPORT_SYMBOL_GPL(usbip_dump_header);
 
 /* Receive data over TCP/IP. */
-int usbip_recv(struct socket *sock, void *buf, int size)
+int usbip_recv(struct usbip_device *ud, void *buf, int size)
 {
 	int result;
 	struct msghdr msg;
@@ -335,33 +335,26 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 
 	usbip_dbg_xmit("enter\n");
 
-	if (!sock || !buf || !size) {
-		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
-		       size);
+	if (!ud || !buf || !size) {
+		pr_err("invalid arg, ud %p buff %p size %d\n", ud, buf, size);
 		return -EINVAL;
 	}
 
-	do {
-		sock->sk->sk_allocation = GFP_NOIO;
-		iov.iov_base    = buf;
-		iov.iov_len     = size;
-		msg.msg_name    = NULL;
-		msg.msg_namelen = 0;
-		msg.msg_control = NULL;
-		msg.msg_controllen = 0;
-		msg.msg_flags      = MSG_NOSIGNAL;
-
-		result = kernel_recvmsg(sock, &msg, &iov, 1, size, MSG_WAITALL);
-		if (result <= 0) {
-			pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
-				 sock, buf, size, result, total);
-			goto err;
-		}
-
-		size -= result;
-		buf += result;
-		total += result;
-	} while (size > 0);
+	ud->tcp_socket->sk->sk_allocation = GFP_NOIO;
+	iov.iov_base    = buf;
+	iov.iov_len     = size;
+	msg.msg_name    = NULL;
+	msg.msg_namelen = 0;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_flags      = MSG_NOSIGNAL;
+
+	result = usbip_recvmsg(ud, &msg, &iov, 1, size, MSG_WAITALL);
+	if (result < 0) {
+		pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
+			 ud->tcp_socket, buf, size, result, total);
+		return result;
+	}
 
 	if (usbip_dbg_flag_xmit) {
 		if (!in_interrupt())
@@ -375,9 +368,6 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 			 osize, result, size, total);
 	}
 
-	return total;
-
-err:
 	return result;
 }
 EXPORT_SYMBOL_GPL(usbip_recv);
@@ -591,6 +581,20 @@ static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
 	}
 }
 
+int usbip_recvmsg(struct usbip_device *ud, struct msghdr *msg,
+		  struct kvec *vec, size_t num, size_t size, int flags)
+{
+	return kernel_recvmsg(ud->tcp_socket, msg, vec, num, size, flags);
+}
+EXPORT_SYMBOL_GPL(usbip_recvmsg);
+
+int usbip_sendmsg(struct usbip_device *ud, struct msghdr *msg,
+		  struct kvec *vec, size_t num, size_t size)
+{
+	return kernel_sendmsg(ud->tcp_socket, msg, vec, num, size);
+}
+EXPORT_SYMBOL_GPL(usbip_sendmsg);
+
 /* must free buffer */
 struct usbip_iso_packet_descriptor*
 usbip_alloc_iso_desc_pdu(struct urb *urb, ssize_t *bufflen)
@@ -637,7 +641,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	if (!buff)
 		return -ENOMEM;
 
-	ret = usbip_recv(ud->tcp_socket, buff, size);
+	ret = usbip_recv(ud, buff, size);
 	if (ret != size) {
 		dev_err(&urb->dev->dev, "recv iso_frame_descriptor, %d\n",
 			ret);
@@ -741,7 +745,7 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 	if (!(size > 0))
 		return 0;
 
-	ret = usbip_recv(ud->tcp_socket, urb->transfer_buffer, size);
+	ret = usbip_recv(ud, urb->transfer_buffer, size);
 	if (ret != size) {
 		dev_err(&urb->dev->dev, "recv xbuf, %d\n", ret);
 		if (ud->side == USBIP_STUB) {
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 69b3f8a..8b0ac52 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -308,7 +308,7 @@ struct usbip_device {
 void usbip_dump_urb(struct urb *purb);
 void usbip_dump_header(struct usbip_header *pdu);
 
-int usbip_recv(struct socket *sock, void *buf, int size);
+int usbip_recv(struct usbip_device *ui, void *buf, int size);
 
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
 		    int pack);
@@ -328,6 +328,11 @@ void usbip_stop_eh(struct usbip_device *ud);
 void usbip_event_add(struct usbip_device *ud, unsigned long event);
 int usbip_event_happened(struct usbip_device *ud);
 
+int usbip_recvmsg(struct usbip_device *ui, struct msghdr *msg,
+		  struct kvec *vec, size_t num, size_t size, int flags);
+int usbip_sendmsg(struct usbip_device *ui, struct msghdr *msg,
+		  struct kvec *vec, size_t num, size_t size);
+
 static inline int interface_to_busnum(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index 00e4a54..38cee58 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -205,7 +205,7 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	memset(&pdu, 0, sizeof(pdu));
 
 	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	ret = usbip_recv(ud, &pdu, sizeof(pdu));
 	if (ret < 0) {
 		if (ret == -ECONNRESET)
 			pr_info("connection reset by peer\n");
diff --git a/drivers/usb/usbip/vhci_tx.c b/drivers/usb/usbip/vhci_tx.c
index 409fd99..09663e6 100644
--- a/drivers/usb/usbip/vhci_tx.c
+++ b/drivers/usb/usbip/vhci_tx.c
@@ -115,7 +115,7 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 			txsize += len;
 		}
 
-		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 3, txsize);
+		ret = usbip_sendmsg(&vdev->ud, &msg, iov, 3, txsize);
 		if (ret != txsize) {
 			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
 			       txsize);
@@ -184,7 +184,7 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 		iov[0].iov_len  = sizeof(pdu_header);
 		txsize += sizeof(pdu_header);
 
-		ret = kernel_sendmsg(vdev->ud.tcp_socket, &msg, iov, 1, txsize);
+		ret = usbip_sendmsg(&vdev->ud, &msg, iov, 1, txsize);
 		if (ret != txsize) {
 			pr_err("sendmsg failed!, ret=%d for %zd\n", ret,
 			       txsize);
-- 
2.1.0

