Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaGIQHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:07:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60856 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbaGIQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:07:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+GOWdh/F+hmPfdHGb0Ys6luspvFU8I2Pw=
X-DKIM: OpenDKIM Filter v2.0.1 titan C54835A6BAF
Date: Wed, 9 Jul 2014 12:07:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: [RFC PATCH] hwrng: sysfs entry rng_seed_kernel, was: "Re: [PATCH
 v2 1/2] hwrng: fetch randomness only after device init"
Message-ID: <20140709160725.GP13433@titan.lakedaemon.net>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <515a12ecc5fca5452bf0bfda4d54546d8fb5829c.1404538109.git.amit.shah@redhat.com>
 <20140709115317.GM13433@titan.lakedaemon.net>
 <20140709130822.GA4553@grmbl.mre>
 <20140709131737.GO13433@titan.lakedaemon.net>
 <20140709132524.GB4667@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709132524.GB4667@grmbl.mre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit, Kees,

On Wed, Jul 09, 2014 at 06:55:24PM +0530, Amit Shah wrote:
> On (Wed) 09 Jul 2014 [09:17:37], Jason Cooper wrote:
> > On Wed, Jul 09, 2014 at 06:38:22PM +0530, Amit Shah wrote:
> > > On (Wed) 09 Jul 2014 [07:53:17], Jason Cooper wrote:
> > > > On Sat, Jul 05, 2014 at 11:04:52AM +0530, Amit Shah wrote:
> > > > > Commit d9e7972619334 "hwrng: add randomness to system from rng sources"
> > > > > added a call to rng_get_data() from the hwrng_register() function.
> > > > > However, some rng devices need initialization before data can be read
> > > > > from them.
> > > > > 
> > > > > This commit makes the call to rng_get_data() depend on no init fn
> > > > > pointer being registered by the device.  If an init function is
> > > > > registered, this call is made after device init.
> > > > > 
> > > > > CC: Kees Cook <keescook@chromium.org>
> > > > > CC: Jason Cooper <jason@lakedaemon.net>
> > > > > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > > > > CC: <stable@vger.kernel.org> # For v3.15+
> > > > > Signed-off-by: Amit Shah <amit.shah@redhat.com>
> > > > > ---
> > > > >  drivers/char/hw_random/core.c | 31 +++++++++++++++++++++++++------
> > > > >  1 file changed, 25 insertions(+), 6 deletions(-)
> > > > 
> > > > Thanks for cleaning this up!
> > > 
> > > Thanks!
> > > 
> > > Any thoughts on the follow-up patch posted later that resolves some of
> > > the weirdness in init?
> > 
> > hmm, I'd rather see an init function for virtio-rng that checks the bit
> > and returns 0 or -EAGAIN.  With your proposed change, you would get
> > hangs again.
> 
> Confused; I meant the patch in
> 
> https://lkml.org/lkml/2014/7/7/58

Yes, I meant without 2/2 of this current series.

I'm cooling to the idea of the init function for virtio-rng, and it
might be best just to admit that there's no way to seed the entropy pool
from the virtio-rng at probe time.  After all, once userspace is up, the
system should take advantage of /dev/hwrng for the generation of
long-term keys.  Either via rngd feeding /dev/random, or directly.

As for the follow-on patch you asked about, I think that's fine.  More
entropy can't hurt.

The below patch might be worth considering so that the user of a system
with only virtio-rng can kick the entropy pool as they see fit.  It's
probably not too kosher as is, but if the idea is liked, I could clean
it up and submit.

The advantage is that users don't need to have rngd installed and
running on the system in order to jump-start the entropy pool.

thx,

Jason.

------------>8----------------
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index df95e2ff9d48..b54af066d075 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -63,14 +63,25 @@ static size_t rng_buffer_size(void)
 	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
 }
 
-static void add_early_randomness(struct hwrng *rng)
+static void add_early_randomness(struct hwrng *rng, u8 size)
 {
-	unsigned char bytes[16];
+	unsigned char *bytes;
 	int bytes_read;
 
+	/* size can come from the user, sanitize */
+	size = size > 256 ? 256 : size;
+
+	size = size == 0 ? 16 : size;
+
+	bytes = kmalloc(size, GFP_KERNEL);
+	if (!bytes)
+		return;
+
 	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
 	if (bytes_read > 0)
 		add_device_randomness(bytes, bytes_read);
+
+	kfree(bytes);
 }
 
 static inline int hwrng_init(struct hwrng *rng)
@@ -84,7 +95,7 @@ static inline int hwrng_init(struct hwrng *rng)
 	if (ret)
 		return ret;
 
-	add_early_randomness(rng);
+	add_early_randomness(rng, 0);
 	return ret;
 }
 
@@ -281,18 +292,54 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 	return ret;
 }
 
+/*
+ * seed the kernel's entropy pool from the current hwrng.
+ *
+ * 'echo "n" >rng_seed_kernel', where n >= 0.
+ *   n = 0: default size added (16 bytes)
+ *   0 < n <= 256: n bytes added.
+ *   n > 256: 256 bytes added.
+ */
+static ssize_t hwrng_attr_seed_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	int err;
+	u8  sz;
+
+	if (!current_rng)
+		return -ENODEV;
+
+	err = kstrtou8(buf, 10, &sz);
+	if (err)
+		return err;
+
+	err = mutex_lock_interruptible(&rng_mutex);
+	if (err)
+		return -ERESTARTSYS;
+
+	add_early_randomness(current_rng, sz);
+
+	mutex_unlock(&rng_mutex);
+
+	return err ? : len;
+}
+
 static DEVICE_ATTR(rng_current, S_IRUGO | S_IWUSR,
 		   hwrng_attr_current_show,
 		   hwrng_attr_current_store);
 static DEVICE_ATTR(rng_available, S_IRUGO,
 		   hwrng_attr_available_show,
 		   NULL);
-
+static DEVICE_ATTR(rng_seed_kernel, S_IWUSR,
+		   NULL,
+		   hwrng_attr_seed_store);
 
 static void unregister_miscdev(void)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_seed_kernel);
 	misc_deregister(&rng_miscdev);
 }
 
@@ -311,9 +358,15 @@ static int register_miscdev(void)
 				 &dev_attr_rng_available);
 	if (err)
 		goto err_remove_current;
+	err = device_create_file(rng_miscdev.this_device,
+				 &dev_attr_rng_seed_kernel);
+	if (err)
+		goto err_remove_available;
 out:
 	return err;
 
+err_remove_available:
+	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 err_remove_current:
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
 err_misc_dereg:
@@ -367,7 +420,7 @@ int hwrng_register(struct hwrng *rng)
 	list_add_tail(&rng->list, &rng_list);
 
 	if (!rng->init)
-		add_early_randomness(rng);
+		add_early_randomness(rng, 0);
 
 out_unlock:
 	mutex_unlock(&rng_mutex);
