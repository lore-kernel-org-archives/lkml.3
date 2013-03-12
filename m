Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab3CLW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:58:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3CLWoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 12/40] hw_random: make buffer usable in scatterlist.
Date: Tue, 12 Mar 2013 15:43:33 -0700
Message-Id: <20130312223212.790278686@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit f7f154f1246ccc5a0a7e9ce50932627d60a0c878 upstream.

virtio_rng feeds the randomness buffer handed by the core directly
into the scatterlist, since commit bb347d98079a547e80bd4722dee1de61e4dca0e8.

However, if CONFIG_HW_RANDOM=m, the static buffer isn't a linear address
(at least on most archs).  We could fix this in virtio_rng, but it's actually
far easier to just do it in the core as virtio_rng would have to allocate
a buffer every time (it doesn't know how much the core will want to read).

Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 
 
@@ -52,8 +53,12 @@ static struct hwrng *current_rng;
 static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
-static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
-	__cacheline_aligned;
+static u8 *rng_buffer;
+
+static size_t rng_buffer_size(void)
+{
+	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
+}
 
 static inline int hwrng_init(struct hwrng *rng)
 {
@@ -116,7 +121,7 @@ static ssize_t rng_dev_read(struct file
 
 		if (!data_avail) {
 			bytes_read = rng_get_data(current_rng, rng_buffer,
-				sizeof(rng_buffer),
+				rng_buffer_size(),
 				!(filp->f_flags & O_NONBLOCK));
 			if (bytes_read < 0) {
 				err = bytes_read;
@@ -307,6 +312,14 @@ int hwrng_register(struct hwrng *rng)
 
 	mutex_lock(&rng_mutex);
 
+	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
+	err = -ENOMEM;
+	if (!rng_buffer) {
+		rng_buffer = kmalloc(rng_buffer_size(), GFP_KERNEL);
+		if (!rng_buffer)
+			goto out_unlock;
+	}
+
 	/* Must not register two RNGs with the same name. */
 	err = -EEXIST;
 	list_for_each_entry(tmp, &rng_list, list) {


