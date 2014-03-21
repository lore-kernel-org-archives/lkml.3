Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbaCUOey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:34:54 -0400
Received: from verein.lst.de ([213.95.11.211]:40368 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbaCUOew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:34:52 -0400
Date: Fri, 21 Mar 2014 15:34:51 +0100
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140321143451.GL1763@lst.de>
References: <20140321142950.GI1763@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321142950.GI1763@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a derating factor to struct hwrng for
the random bits going into the kernel input pool, and a common
default derating for drivers which do not specify one.

Signed-off-by: Torsten Duwe <duwe@suse.de>

---
 drivers/char/hw_random/core.c |   11 ++++++++++-
 include/linux/hw_random.h     |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- linux/include/linux/hw_random.h.orig
+++ linux/include/linux/hw_random.h
@@ -29,6 +29,8 @@
  * @read:		New API. drivers can fill up to max bytes of data
  *			into the buffer. The buffer is aligned for any type.
  * @priv:		Private data, for use by the RNG driver.
+ * @derating:		Estimation of true entropy in RNG's bitstream
+ *			(per mill).
  */
 struct hwrng {
 	const char *name;
@@ -38,6 +39,7 @@ struct hwrng {
 	int (*data_read)(struct hwrng *rng, u32 *data);
 	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);
 	unsigned long priv;
+	unsigned short derating;
 
 	/* internal. */
 	struct list_head list;
--- linux/drivers/char/hw_random/core.c.orig
+++ linux/drivers/char/hw_random/core.c
@@ -56,11 +56,15 @@ static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
-static unsigned short derating_current = 700; /* an arbitrary 70% */
+static unsigned short derating_current;
+static unsigned short derating_default = 700; /* an arbitrary 70% */
 
 module_param(derating_current, ushort, 0644);
 MODULE_PARM_DESC(derating_current,
 		 "current hwrng entropy estimation per mill");
+module_param(derating_default, ushort, 0644);
+MODULE_PARM_DESC(derating_default,
+		 "default entropy content of hwrng per mill");
 
 static void start_khwrngd(void);
 
@@ -79,6 +83,11 @@ static inline int hwrng_init(struct hwrn
 	if (err)
 		return err;
 
+	derating_current = rng->derating ? : derating_default;
+	derating_current &= 1023;
+
+	if (derating_current == 0 && hwrng_fill)
+		kthread_stop(hwrng_fill);
 	if (derating_current > 0 && !hwrng_fill)
 		start_khwrngd();
 
