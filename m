Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3I1Rnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:43:39 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:47883 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754943Ab3I1Rnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:43:31 -0400
X-RRZE-Submit-IP: 212.255.254.196
From: Dominik Paulus <dominik.paulus@fau.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>, linux-kernel@i4.cs.fau.de,
        devel@driverdev.osuosl.org, tobias.polzer@fau.de,
        Dominik Paulus <dominik.paulus@fau.de>
Subject: [PATCHv3  13/16] staging: usbip: Wrap kernel_sendmsg()/recvmsg()
Date: Sat, 28 Sep 2013 19:42:50 +0200
Message-Id: <1380390173-3746-13-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
References: <20130925233638.GA21396@kroah.com>
 <1380390173-3746-1-git-send-email-dominik.paulus@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds two simple wrappers around kernel_sendmsg() and
kernel_recvmsg() that can be extended to perform additional
cryptographic operations on the data before sending it.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/stub_rx.c      |  2 +-
 drivers/staging/usbip/stub_tx.c      |  6 ++--
 drivers/staging/usbip/usbip_common.c | 66 ++++++++++++++++++++----------------
 drivers/staging/usbip/usbip_common.h |  7 +++-
 drivers/staging/usbip/vhci_rx.c      |  2 +-
 drivers/staging/usbip/vhci_tx.c      |  4 +--
 6 files changed, 48 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index db48a78..6ba9969 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -553,7 +553,7 @@ static void stub_rx_pdu(struct usbip_device *ud)
 	memset(&pdu, 0, sizeof(pdu));
 
 	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	ret = usbip_recv(ud, &pdu, sizeof(pdu));
 	if (ret != sizeof(pdu)) {
 		dev_err(dev, "recv a header, %d\n", ret);
 		usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index cd5326a..9a9f9e6 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -257,8 +257,7 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 			iovnum++;
 		}
 
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg,
-						iov,  iovnum, txsize);
+		ret = usbip_sendmsg(&sdev->ud, &msg, iov, iovnum, txsize);
 		if (ret != txsize) {
 			dev_err(&sdev->interface->dev,
 				"sendmsg failed!, retval %d for %zd\n",
@@ -332,8 +331,7 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
 		iov[0].iov_len  = sizeof(pdu_header);
 		txsize += sizeof(pdu_header);
 
-		ret = kernel_sendmsg(sdev->ud.tcp_socket, &msg, iov,
-				     1, txsize);
+		ret = usbip_sendmsg(&sdev->ud, &msg, iov, 1, txsize);
 		if (ret != txsize) {
 			dev_err(&sdev->interface->dev,
 				"sendmsg failed!, retval %d for %zd\n",
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index e3fc749..83ec279 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -339,7 +339,7 @@ void usbip_dump_header(struct usbip_header *pdu)
 EXPORT_SYMBOL_GPL(usbip_dump_header);
 
 /* Receive data over TCP/IP. */
-int usbip_recv(struct socket *sock, void *buf, int size)
+int usbip_recv(struct usbip_device *ud, void *buf, int size)
 {
 	int result;
 	struct msghdr msg;
@@ -352,34 +352,29 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 
 	usbip_dbg_xmit("enter\n");
 
-	if (!sock || !buf || !size) {
-		pr_err("invalid arg, sock %p buff %p size %d\n", sock, buf,
+	if (!ud || !buf || !size) {
+		pr_err("invalid arg, ud %p buff %p size %d\n", ud, buf,
 		       size);
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
-		msg.msg_namelen    = 0;
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
+	msg.msg_namelen    = 0;
+	msg.msg_flags      = MSG_NOSIGNAL;
+
+	result = usbip_recvmsg(ud, &msg, &iov, 1, size, MSG_WAITALL);
+
+	if (result < 0) {
+		pr_debug("receive sock %p buf %p size %u ret %d total %d\n",
+			 ud->tcp_socket, buf, size, result, total);
+		return result;
+	}
 
 	if (usbip_dbg_flag_xmit) {
 		if (!in_interrupt())
@@ -393,9 +388,6 @@ int usbip_recv(struct socket *sock, void *buf, int size)
 			 osize, result, size, total);
 	}
 
-	return total;
-
-err:
 	return result;
 }
 EXPORT_SYMBOL_GPL(usbip_recv);
@@ -634,6 +626,20 @@ static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
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
@@ -680,7 +686,7 @@ int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
 	if (!buff)
 		return -ENOMEM;
 
-	ret = usbip_recv(ud->tcp_socket, buff, size);
+	ret = usbip_recv(ud, buff, size);
 	if (ret != size) {
 		dev_err(&urb->dev->dev, "recv iso_frame_descriptor, %d\n",
 			ret);
@@ -785,7 +791,7 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 	if (!(size > 0))
 		return 0;
 
-	ret = usbip_recv(ud->tcp_socket, urb->transfer_buffer, size);
+	ret = usbip_recv(ud, urb->transfer_buffer, size);
 	if (ret != size) {
 		dev_err(&urb->dev->dev, "recv xbuf, %d\n", ret);
 		if (ud->side == USBIP_STUB) {
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 96c87ee..bdad29f 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -323,7 +323,7 @@ struct usbip_device {
 void usbip_dump_urb(struct urb *purb);
 void usbip_dump_header(struct usbip_header *pdu);
 
-int usbip_recv(struct socket *sock, void *buf, int size);
+int usbip_recv(struct usbip_device *ui, void *buf, int size);
 struct socket *sockfd_to_socket(unsigned int sockfd);
 
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
@@ -344,6 +344,11 @@ void usbip_stop_eh(struct usbip_device *ud);
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
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index d07fcb5..34706a8 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -207,7 +207,7 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	memset(&pdu, 0, sizeof(pdu));
 
 	/* receive a pdu header */
-	ret = usbip_recv(ud->tcp_socket, &pdu, sizeof(pdu));
+	ret = usbip_recv(ud, &pdu, sizeof(pdu));
 	if (ret < 0) {
 		if (ret == -ECONNRESET)
 			pr_info("connection reset by peer\n");
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index 409fd99..09663e6 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
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
1.8.4

