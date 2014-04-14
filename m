Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaDNQG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:06:57 -0400
Received: from verein.lst.de ([213.95.11.211]:49511 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbaDNQGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:06:55 -0400
Date: Mon, 14 Apr 2014 18:06:53 +0200
From: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        ingo.tuchscherer@de.ibm.com, linux-kernel@vger.kernel.org,
        Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v3 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140414160653.GC29351@lst.de>
References: <20140321142950.GI1763@lst.de> <20140321143342.GK1763@lst.de> <533375C1.5060904@mit.edu> <158d2776-1ea4-4f32-a9e9-0488047e6b70@email.android.com> <20140414160211.GE711@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414160211.GE711@lst.de>
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
+static unsigned short derating_default = 500; /* an arbitrary 50% */
 
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
 
