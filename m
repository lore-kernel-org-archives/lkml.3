Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaG3ByQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:54:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaG3BuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jason Cooper <jason@lakedaemon.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 3.15 34/37] hwrng: virtio - ensure reads happen after successful probe
Date: Tue, 29 Jul 2014 18:49:10 -0700
Message-Id: <20140730014829.391723028@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit e052dbf554610e2104c5a7518c4d8374bed701bb upstream.

The hwrng core asks for random data in the hwrng_register() call itself
from commit d9e7972619.  This doesn't play well with virtio -- the
DRIVER_OK bit is only set by virtio core on a successful probe, and
we're not yet out of our probe routine when this call is made.  This
causes the host to not acknowledge any requests we put in the virtqueue,
and the insmod or kernel boot process just waits for data to arrive from
the host, which never happens.

CC: Kees Cook <keescook@chromium.org>
CC: Jason Cooper <jason@lakedaemon.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c       |    6 ++++++
 drivers/char/hw_random/virtio-rng.c |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -68,6 +68,12 @@ static void add_early_randomness(struct
 	unsigned char bytes[16];
 	int bytes_read;
 
+	/*
+	 * Currently only virtio-rng cannot return data during device
+	 * probe, and that's handled in virtio-rng.c itself.  If there
+	 * are more such devices, this call to rng_get_data can be
+	 * made conditional here instead of doing it per-device.
+	 */
 	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -30,6 +30,8 @@ static unsigned int data_avail;
 static DECLARE_COMPLETION(have_data);
 static bool busy;
 
+static bool probe_done;
+
 static void random_recv_done(struct virtqueue *vq)
 {
 	/* We can get spurious callbacks, e.g. shared IRQs + virtio_pci. */
@@ -56,6 +58,13 @@ static int virtio_read(struct hwrng *rng
 {
 	int ret;
 
+	/*
+	 * Don't ask host for data till we're setup.  This call can
+	 * happen during hwrng_register(), after commit d9e7972619.
+	 */
+	if (unlikely(!probe_done))
+		return 0;
+
 	if (!busy) {
 		busy = true;
 		init_completion(&have_data);
@@ -110,6 +119,7 @@ static int probe_common(struct virtio_de
 		return err;
 	}
 
+	probe_done = true;
 	return 0;
 }
 


