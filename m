Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaIPVsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:48:05 -0400
Received: from vidar.hosts.sieglitzhof.net ([62.113.200.140]:60222 "EHLO
	vidar.hosts.sieglitzhof.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753488AbaIPVrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:47:06 -0400
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: linux-kernel@vger.kernel.org
Cc: valentina.manea.m@gmail.com, shuah.kh@samsung.com,
        gregkh@linuxfoundation.org, Dominik Paulus <dominik.paulus@fau.de>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        Fjodor Schelichow <fjodor.schelichow@hotmail.com>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>
Date: Tue, 16 Sep 2014 23:38:52 +0000
Message-Id: <1410910735-27929-16-git-send-email-maximilian@eschenbacher.email>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email>
X-SA-Exim-Connect-IP: 172.16.2.6
X-SA-Exim-Mail-From: maximilian@eschenbacher.email
Subject: [PATCH 15/18] usbip: Add encryption support to kernel
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on vidar.hosts.sieglitzhof.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominik Paulus <dominik.paulus@fau.de>

This adds code performing the actual encryption and authentication
operations in the usbip kernel code. The whole data stream may now be
encrypted and authenticated with AES-GCM and symmetric 128 bit keys.

Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Signed-off-by: Fjodor Schelichow <fjodor.schelichow@hotmail.com>
Signed-off-by: Johannes Stadlinger <johannes.stadlinger@fau.de>
Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/usb/usbip/Kconfig        |   2 +-
 drivers/usb/usbip/stub.h         |   3 +
 drivers/usb/usbip/stub_dev.c     |   8 +
 drivers/usb/usbip/usbip_common.c | 351 ++++++++++++++++++++++++++++++++++++++-
 drivers/usb/usbip/usbip_common.h |  22 +++
 drivers/usb/usbip/vhci_hcd.c     |   4 +-
 drivers/usb/usbip/vhci_sysfs.c   |  10 ++
 7 files changed, 396 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/usbip/Kconfig b/drivers/usb/usbip/Kconfig
index bd99e9e..4ad96ef 100644
--- a/drivers/usb/usbip/Kconfig
+++ b/drivers/usb/usbip/Kconfig
@@ -1,6 +1,6 @@
 config USBIP_CORE
 	tristate "USB/IP support"
-	depends on USB && NET
+	depends on USB && NET && CRYPTO_GCM && CRYPTO_AES && CRYPTO_CRYPTD
 	---help---
 	  This enables pushing USB packets over IP to allow remote
 	  machines direct access to USB devices. It provides the
diff --git a/drivers/usb/usbip/stub.h b/drivers/usb/usbip/stub.h
index b2d3d55..0b982d6 100644
--- a/drivers/usb/usbip/stub.h
+++ b/drivers/usb/usbip/stub.h
@@ -26,6 +26,9 @@
 #include <linux/types.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/scatterlist.h>
 
 #define STUB_BUSID_OTHER 0
 #define STUB_BUSID_REMOV 1
diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index d237351..fdfab0f 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -21,6 +21,7 @@
 #include <linux/file.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
+#include <linux/kfifo.h>
 
 #include "usbip_common.h"
 #include "stub.h"
@@ -118,6 +119,12 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 
 		spin_unlock_irq(&sdev->ud.lock);
 
+		if (sdev->ud.use_crypto) {
+			err = usbip_init_crypto(&sdev->ud, sendkey, recvkey);
+			if (err < 0)
+				goto err;
+		}
+
 		sdev->ud.tcp_rx = kthread_get_run(stub_rx_loop, &sdev->ud,
 						  "stub_rx");
 		sdev->ud.tcp_tx = kthread_get_run(stub_tx_loop, &sdev->ud,
@@ -272,6 +279,7 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 	}
 
 	/* 3. free used data */
+	usbip_deinit_crypto(ud);
 	stub_device_cleanup_urbs(sdev);
 
 	/* 4. free stub_unlink */
diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 559fe53..3610842 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -26,6 +26,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <net/sock.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
 
 #include "usbip_common.h"
 
@@ -581,17 +583,362 @@ static void usbip_pack_iso(struct usbip_iso_packet_descriptor *iso,
 	}
 }
 
+int usbip_init_crypto(struct usbip_device *ud, unsigned char *sendkey, unsigned
+		      char *recvkey)
+{
+	int ret;
+
+	ud->use_crypto = 1;
+
+	ud->tfm_recv = crypto_alloc_aead("gcm(aes)", 0, 0);
+	if (IS_ERR(ud->tfm_recv))
+		return PTR_ERR(ud->tfm_recv);
+	ud->tfm_send = crypto_alloc_aead("gcm(aes)", 0, 0);
+	if (IS_ERR(ud->tfm_send)) {
+		ret = PTR_ERR(ud->tfm_send);
+		goto err_free_recv;
+	}
+	ret = kfifo_alloc(&ud->recv_queue, RECVQ_SIZE, GFP_KERNEL);
+	if (ret)
+		goto err_free_send;
+
+	if (crypto_aead_setkey(ud->tfm_send, sendkey, USBIP_KEYSIZE) ||
+	    crypto_aead_setkey(ud->tfm_recv, recvkey, USBIP_KEYSIZE) ||
+	    crypto_aead_setauthsize(ud->tfm_send, USBIP_AUTHSIZE) ||
+	    crypto_aead_setauthsize(ud->tfm_recv, USBIP_AUTHSIZE)) {
+		ret = -EINVAL;
+		goto err_free_fifo;
+	}
+
+	ud->ctr_send = 0;
+	ud->ctr_recv = 0;
+
+	return 0;
+
+err_free_fifo:
+	kfifo_free(&ud->recv_queue);
+err_free_send:
+	crypto_free_aead(ud->tfm_send);
+err_free_recv:
+	crypto_free_aead(ud->tfm_recv);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usbip_init_crypto);
+
+void usbip_deinit_crypto(struct usbip_device *ud)
+{
+	if (ud->use_crypto) {
+		crypto_free_aead(ud->tfm_send);
+		crypto_free_aead(ud->tfm_recv);
+		kfifo_free(&ud->recv_queue);
+		ud->use_crypto = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(usbip_deinit_crypto);
+
+struct tcrypt_result {
+	struct completion completion;
+	int err;
+};
+
+static void tcrypt_complete(struct crypto_async_request *req, int err)
+{
+	struct tcrypt_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+#define USBIP_ENCRYPT 1
+#define USBIP_DECRYPT 0
+/*
+ * Perform encryption/decryption on one chunk of data.
+ * Uses global crypto state stored in usbip_device.
+ * Parameters:
+ * encrypt: USBIP_ENCRYPT to perform encryption, USBIP_DECRYPT to perform
+ * decryption
+ * packetsize: Size of the encrypted packet, including the authentication tag,
+ * not including the associated data (length field).
+ * plaintext and ciphertext have to be appropiately managed by the caller
+ * (i.e. they must be at least packetsize bytes long).
+ * Returns: 0 on success, negative error code on failure
+ */
+static int usbip_crypt(struct usbip_device *ud, int encrypt,
+		uint32_t packetsize, unsigned char *plaintext,
+		unsigned char *ciphertext)
+{
+	struct crypto_aead *tfm;
+	struct aead_request *req;
+	struct tcrypt_result result;
+	struct scatterlist plain, cipher, assoc;
+	char iv[16];
+	u64 *iv_num;
+	u64 iv_net;
+	const int plainsize = packetsize - USBIP_AUTHSIZE;
+	int ret;
+
+	/* Currently, this is guaranteed by the caller */
+	if (packetsize < USBIP_AUTHSIZE)
+		return -EINVAL;
+
+	memset(iv, 0, sizeof(iv));
+	if (encrypt) {
+		tfm = ud->tfm_send;
+		iv_num = &ud->ctr_send;
+	} else {
+		tfm = ud->tfm_recv;
+		iv_num = &ud->ctr_recv;
+	}
+	iv_net = cpu_to_be64(*iv_num);
+	memcpy(iv, &iv_net, sizeof(iv_net));
+
+	req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	init_completion(&result.completion);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  tcrypt_complete, &result);
+
+	sg_init_one(&cipher, ciphertext, packetsize);
+	sg_init_one(&plain, plaintext, plainsize);
+	crypto_aead_clear_flags(tfm, ~0);
+
+	if (encrypt)
+		aead_request_set_crypt(req, &plain, &cipher, plainsize, iv);
+	else
+		aead_request_set_crypt(req, &cipher, &plain, packetsize, iv);
+	packetsize = cpu_to_be32(packetsize);
+	sg_init_one(&assoc, &packetsize, sizeof(packetsize));
+	/* Associated data: Unencrypted length tag */
+	aead_request_set_assoc(req, &assoc, sizeof(packetsize));
+
+	if (encrypt)
+		ret = crypto_aead_encrypt(req);
+	else
+		ret = crypto_aead_decrypt(req);
+
+	switch (ret) {
+	case 0: /* Success */
+		break;
+	case -EINPROGRESS:
+	case -EBUSY:
+		wait_for_completion(&result.completion);
+		ret = result.err;
+		break;
+	default:
+		aead_request_free(req);
+		return ret;
+	}
+
+	aead_request_free(req);
+
+	(*iv_num)++; /* Increment IV */
+
+	return ret;
+}
+
+/*
+ * Wrapper to kernel_recvmsg. If necessary, also does the necessary decryption.
+ * If decryption is enabled, you _MUST_ pass 1 as parameter for num, i.e.
+ * only receive into a single continuous buffer.
+ */
 int usbip_recvmsg(struct usbip_device *ud, struct msghdr *msg,
 		  struct kvec *vec, size_t num, size_t size, int flags)
 {
-	return kernel_recvmsg(ud->tcp_socket, msg, vec, num, size, flags);
+	int ret;
+	size_t total = 0;
+	unsigned char *plainbuf, *cipherbuf;
+
+	if (!ud->use_crypto)
+		return kernel_recvmsg(ud->tcp_socket, msg, vec, num, size,
+				      flags);
+
+	if (vec[0].iov_len < size)
+		return -EINVAL;
+	if (num != 1)
+		return -EINVAL;
+
+	plainbuf = kmalloc(USBIP_PACKETSIZE, GFP_KERNEL);
+	if (!plainbuf)
+		return -ENOMEM;
+	cipherbuf = kmalloc(USBIP_PACKETSIZE, GFP_KERNEL);
+	if (!cipherbuf) {
+		kfree(plainbuf);
+		return -ENOMEM;
+	}
+
+	while (total < size) {
+		uint32_t packetsize;
+		struct kvec recvvec;
+
+		/*
+		 * We use a global kfifo to buffer unrequested plaintext bytes.
+		 * Flush this buffer first before receiving new data.
+		 */
+		if (kfifo_len(&ud->recv_queue)) {
+			size_t next = min_t(size_t, kfifo_len(&ud->recv_queue),
+					    size - total);
+			/* No error checking necessary - see previous line */
+			ret = kfifo_out(&ud->recv_queue,
+					vec[0].iov_base + total, next);
+			total += next;
+			continue;
+		}
+
+		/* See usbip_sendmsg() for the format of one encrypted packet */
+
+		/*
+		 * Receive size of next crypto packet
+		 */
+		recvvec.iov_base = &packetsize;
+		recvvec.iov_len = sizeof(packetsize);
+
+		ret = kernel_recvmsg(ud->tcp_socket, msg, &recvvec, 1,
+				     sizeof(packetsize), flags);
+		packetsize = be32_to_cpu(packetsize);
+		if (ret < 0) {
+			total = ret;
+			goto err;
+		} else if (ret != sizeof(packetsize)) {
+			total = -EBADMSG;
+			goto err;
+		}
+
+		if (packetsize > USBIP_PACKETSIZE) {
+			total = -EBADMSG;
+			goto err;
+		}
+
+		/*
+		 * Receive the rest of the packet
+		 */
+		recvvec.iov_base = cipherbuf;
+		recvvec.iov_len = packetsize;
+		ret = kernel_recvmsg(ud->tcp_socket, msg, &recvvec, 1,
+				packetsize, flags);
+		if (ret <= 0) {
+			total = ret;
+			goto err;
+		} else if (ret != packetsize) {
+			total = -EBADMSG;
+			goto err;
+		}
+
+		/*
+		 * Decrypt the packet. This will also authenticate the length
+		 * field
+		 */
+		ret = usbip_crypt(ud, 0, packetsize, plainbuf, cipherbuf);
+		if (ret != 0) {
+			total = ret;
+			goto err;
+		}
+
+		/*
+		 * Add this packet to our global buffer (It will be stored in
+		 * the user buffer in the next loop iteration) No error
+		 * checking necessary - we already know the packet is going to
+		 * fit.
+		 */
+		(void) kfifo_in(&ud->recv_queue, plainbuf, packetsize -
+				USBIP_AUTHSIZE);
+	}
+
+err:
+	kfree(plainbuf);
+	kfree(cipherbuf);
+
+	return total;
 }
 EXPORT_SYMBOL_GPL(usbip_recvmsg);
 
 int usbip_sendmsg(struct usbip_device *ud, struct msghdr *msg,
 		  struct kvec *vec, size_t num, size_t size)
 {
-	return kernel_sendmsg(ud->tcp_socket, msg, vec, num, size);
+	int i = 0, ret, offset = 0;
+	size_t total = 0;
+	unsigned char *cipherbuf;
+
+	/* If crypto is disabled, we just wrap the normal kernel calls. */
+	if (!ud->use_crypto)
+		return kernel_sendmsg(ud->tcp_socket, msg, vec, num, size);
+
+	cipherbuf = kmalloc(USBIP_PACKETSIZE, GFP_KERNEL);
+	if (!cipherbuf)
+		return -ENOMEM;
+
+	/*
+	 * The receiver has to decrypt whole packets. To avoid the need
+	 * to allocate large buffers at the receiving side, we split the
+	 * data to be sent in USBIP_PACKETSIZE large chunks that can be
+	 * decrypted separately. See below for the format of each chunk.
+	 */
+
+	/* Iterate over all kvecs, splitting them up as necessary. */
+	for (i = 0; i != num && size; ) {
+		/* Compute the remaining number of bytes to send for
+		 * this kvec */
+		const size_t PLAIN_SIZE = min_t(size_t, vec[i].iov_len - offset,
+				min_t(size_t, size,
+				      USBIP_PACKETSIZE - USBIP_AUTHSIZE));
+		const size_t PACKET_SIZE = PLAIN_SIZE + USBIP_AUTHSIZE;
+		uint32_t packet_size_net = cpu_to_be32(PACKET_SIZE);
+		struct kvec sendvec[2];
+
+		if (PLAIN_SIZE == 0) {
+			++i;
+			offset = 0;
+			continue;
+		}
+
+		/*
+		 * One encrypted packet consists of:
+		 *  - An unencrypted, authenticated length tag (exactly 4
+		 *    bytes) containing the length of the packet.
+		 *  - Up to USBIP_PACKETSIZE - USBIP_AUTHSIZE bytes of user
+		 *    payload, encrypted
+		 *  - Exactly USBIP_AUTHSIZE bytes authentication tag.
+		 * Note: The packet length is also authenticated, but has
+		 * - for obvious reasons - to be sent in plaintext. This
+		 * packet format will be parsed by usbip_recvmsg (see above).
+		 */
+		ret = usbip_crypt(ud, 1, PACKET_SIZE, vec[i].iov_base + offset,
+				  cipherbuf);
+		if (ret != 0) {
+			kfree(cipherbuf);
+			return ret;
+		}
+
+		/* Length field */
+		sendvec[0].iov_base = &packet_size_net;
+		sendvec[0].iov_len = sizeof(packet_size_net);
+		/* Payload and authentication tag */
+		sendvec[1].iov_base = cipherbuf;
+		sendvec[1].iov_len = PACKET_SIZE;
+		ret = kernel_sendmsg(ud->tcp_socket, msg, sendvec,
+				     ARRAY_SIZE(sendvec), sendvec[0].iov_len +
+				     sendvec[1].iov_len);
+		if (ret < 0) {
+			kfree(cipherbuf);
+			return ret;
+		}
+		if (ret != sendvec[0].iov_len + sendvec[1].iov_len) {
+			kfree(cipherbuf);
+			return -EPROTO;
+		}
+		offset += PLAIN_SIZE;
+		size -= PLAIN_SIZE;
+		total += PLAIN_SIZE;
+	}
+
+	kfree(cipherbuf);
+
+	return total;
 }
 EXPORT_SYMBOL_GPL(usbip_sendmsg);
 
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 8b0ac52..6831d99 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -30,15 +30,28 @@
 #include <linux/usb.h>
 #include <linux/wait.h>
 #include <uapi/linux/usbip.h>
+#include <linux/kfifo.h>
 
 #define USBIP_VERSION "1.0.0"
 
 /*
+ * Length of the authentication tag associated with each packet, in bytes. Can
+ * be set to 4, 8, 12, 13, 14, 15 or 16. See crypto_gcm_setauthsize in
+ * crypto/gcm.c. Increasing this will increase crypto protocol overhead.
+ */
+#define USBIP_AUTHSIZE 4
+/*
  * Length of symmetric keys. Currently, this should be fixed at 16 bytes.
  * Will break code if changed, look at userspace and stub_dev.c/vhci_sysfs.c
  * where this constant is used before changing.
  */
 #define USBIP_KEYSIZE 16
+/*
+ * Maximum size of encrypted packets. Decreasing this will increase overhead
+ * and decrease memory usage.
+ */
+#define USBIP_PACKETSIZE 1024
+#define RECVQ_SIZE (2*USBIP_PACKETSIZE)
 
 #undef pr_fmt
 
@@ -285,6 +298,11 @@ struct usbip_device {
 
 	/* Crypto support */
 	int use_crypto;
+	struct crypto_aead *tfm_recv;
+	struct crypto_aead *tfm_send;
+	/* Counters to be used as IVs */
+	u64 ctr_send, ctr_recv;
+	DECLARE_KFIFO_PTR(recv_queue, char);
 };
 
 #define kthread_get_run(threadfn, data, namefmt, ...)			   \
@@ -308,6 +326,10 @@ struct usbip_device {
 void usbip_dump_urb(struct urb *purb);
 void usbip_dump_header(struct usbip_header *pdu);
 
+int usbip_init_crypto(struct usbip_device *ud, unsigned char *sendkey,
+		unsigned char *recvkey);
+void usbip_deinit_crypto(struct usbip_device *ud);
+
 int usbip_recv(struct usbip_device *ui, void *buf, int size);
 
 void usbip_pack_pdu(struct usbip_header *pdu, struct urb *urb, int cmd,
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index c02374b..13db326 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -785,7 +785,9 @@ static void vhci_shutdown_connection(struct usbip_device *ud)
 		kthread_stop_put(vdev->ud.tcp_tx);
 		vdev->ud.tcp_tx = NULL;
 	}
-	pr_info("stop threads\n");
+	pr_info("stopped threads\n");
+
+	usbip_deinit_crypto(&vdev->ud);
 
 	/* active connection is closed */
 	if (vdev->ud.tcp_socket) {
diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index fa948ad..19d6141 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -20,6 +20,8 @@
 #include <linux/kthread.h>
 #include <linux/file.h>
 #include <linux/net.h>
+#include <linux/crypto.h>
+#include <linux/kfifo.h>
 
 #include "usbip_common.h"
 #include "vhci.h"
@@ -237,6 +239,13 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 	/* begin a lock */
 	spin_lock(&the_controller->lock);
 	vdev = port_to_vdev(rhport);
+	if (use_crypto) {
+		ret = usbip_init_crypto(&vdev->ud, sendkey, recvkey);
+		if (ret < 0) {
+			spin_unlock(&the_controller->lock);
+			return ret;
+		}
+	}
 	spin_lock(&vdev->ud.lock);
 
 	if (vdev->ud.status != VDEV_ST_NULL) {
@@ -247,6 +256,7 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
 		sockfd_put(socket);
 
 		dev_err(dev, "port %d already used\n", rhport);
+		usbip_deinit_crypto(&vdev->ud);
 		return -EINVAL;
 	}
 
-- 
2.1.0

