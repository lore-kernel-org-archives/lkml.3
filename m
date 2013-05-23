Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3EWJ7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:59:49 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34089 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3EWJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:59:47 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Date: Thu, 23 May 2013 11:59:39 +0200
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Message-ID: <20130523115939.7c2e6325@tauon>
In-Reply-To: <20130522203441.79c2f22f@tauon>
References: <20130521084455.5c651991@tauon>
	<CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
	<20130521190157.GD22559@thunk.org>
	<CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
	<20130522082058.5592b2aa@tauon>
	<CACXcFm=Quwx-Mi9s67jQe3HvJ55S3zb+3qsPxkYPvy4A+0Hrqw@mail.gmail.com>
	<20130522203441.79c2f22f@tauon>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sandy,

> On Wed, 22 May 2013 13:40:04 -0400
> Sandy Harris <sandyinchina@gmail.com> wrote:
> 
[...]
> > 
> > >> > What I'm against is relying only on solutions such as HAVEGE or
> > >> > replacing /dev/random with something scheme that only relies on
> > >> > CPU timing and ignores interrupt timing.
> > >>
> > >> My question is how to incorporate some of that into /dev/random.
> > >> At one point, timing info was used along with other stuff. Some
> > >> of that got deleted later, What is the current state? Should we
> > >> add more?
> > >
> > > Again, I would like to suggest that we look beyond a central
> > > entropy collector like /dev/random. I would like to suggest to
> > > consider decentralizing the collection of entropy.
> > 
> > I'm with Ted on this one.
> 
> When you want to consider the jitter RNG for /dev/random, it should be
> used as a seed source similar to the add_*_randomness functions. I
> could implement a suggestion if that is the wish. For example, such a
> seed source could be triggered if the entropy estimator of the
> input_pool falls below some threshold. The jitter RNG could be used to
> top the entropy off to some level above another threshold.

Please see a possible integration of the CPU Jitter RNG
into /dev/random as follows. The patch does not contain the
jitterentropy-base.c, jitterentropy.h and jitterentropy-base-kernel.h
from the tarball available at http://www.chronox.de.

This patch would only use the CPU Jitter RNG if there is no more
entropy in the entropy pool. Thus, the CPU Jitter RNG is only used as a
fallback.

The patch is tested with 3.9.

Signed-off-by: Stephan Mueller <smueller@chronox.de>

---
diff -urNp linux-3.9.orig/drivers/char/Makefile linux-3.9/drivers/char/Makefile
--- linux-3.9.orig/drivers/char/Makefile	2013-05-22 20:55:58.547094987 +0200
+++ linux-3.9/drivers/char/Makefile	2013-05-22 22:11:32.975008931 +0200
@@ -2,7 +2,7 @@
 # Makefile for the kernel character device drivers.
 #
 
-obj-y				+= mem.o random.o
+obj-y				+= mem.o random.o jitterentropy-base.o
 obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
diff -urNp linux-3.9.orig/drivers/char/random.c linux-3.9/drivers/char/random.c
--- linux-3.9.orig/drivers/char/random.c	2013-05-22 20:55:58.675094985 +0200
+++ linux-3.9/drivers/char/random.c	2013-05-23 11:26:25.214103807 +0200
@@ -269,6 +269,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
+#include "jitterentropy.h"
+
 /*
  * Configuration information
  */
@@ -435,6 +437,8 @@ struct entropy_store {
 	unsigned int initialized:1;
 	bool last_data_init;
 	__u8 last_data[EXTRACT_SIZE];
+	int jent_enable;
+	struct rand_data entropy_collector;
 };
 
 static __u32 input_pool_data[INPUT_POOL_WORDS];
@@ -446,7 +450,8 @@ static struct entropy_store input_pool =
 	.name = "input",
 	.limit = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
-	.pool = input_pool_data
+	.pool = input_pool_data,
+	.jent_enable = -1
 };
 
 static struct entropy_store blocking_pool = {
@@ -455,7 +460,8 @@ static struct entropy_store blocking_poo
 	.limit = 1,
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(blocking_pool.lock),
-	.pool = blocking_pool_data
+	.pool = blocking_pool_data,
+	.jent_enable = -1
 };
 
 static struct entropy_store nonblocking_pool = {
@@ -463,7 +469,8 @@ static struct entropy_store nonblocking_
 	.name = "nonblocking",
 	.pull = &input_pool,
 	.lock = __SPIN_LOCK_UNLOCKED(nonblocking_pool.lock),
-	.pool = nonblocking_pool_data
+	.pool = nonblocking_pool_data,
+	.jent_enable = -1
 };
 
 static __u32 const twist_table[8] = {
@@ -633,6 +640,47 @@ struct timer_rand_state {
 	unsigned dont_count_entropy:1;
 };
 
+/* lock of the entropy_store must already been taken */
+void add_jent_randomness(struct entropy_store *r)
+{
+#define JENTBLOCKSIZE 8 /* the most efficient use of the CPU jitter RNG is a block
+			   aligned invocation. The block size of the CPU jitter RNG
+			   is 8 bytes */
+	char rand[JENTBLOCKSIZE];
+	int ret = 0;
+
+	/* the initialization process determines that we cannot use the
+	 * CPU Jitter RNG */
+	if(!r->jent_enable)
+		return;
+	memset(rand, 0, JENTBLOCKSIZE);
+	if(-1 == r->jent_enable)
+	{
+		/* we are uninitialized, try to initialize */
+		if(jent_entropy_init())
+		{
+			/* there is no CPU Jitter, disable the entropy collector */
+			r->jent_enable = 0;
+			return;
+		}
+		/* we do not use jent_entropy_collector_alloc as we are in early
+		 * boot */
+		memset(&r->entropy_collector, 0, sizeof(struct rand_data));
+		/* initialize the entropy collector */
+		jent_read_entropy(&r->entropy_collector, rand, JENTBLOCKSIZE);
+		r->jent_enable = 1;
+	}
+	ret = jent_read_entropy(&r->entropy_collector, rand, JENTBLOCKSIZE);
+	if(JENTBLOCKSIZE == ret)
+	{
+		/* we do not need to worry about trickle threshold as we are called
+		 * when we are low on entropy */
+		_mix_pool_bytes(r, rand, JENTBLOCKSIZE, NULL);
+		credit_entropy_bits(r, JENTBLOCKSIZE * 8);
+	}
+	memset(rand, 0, JENTBLOCKSIZE);
+}
+
 /*
  * Add device- or boot-specific data to the input and nonblocking
  * pools to help initialize them to unique values.
@@ -862,6 +910,10 @@ static size_t account(struct entropy_sto
 		  nbytes * 8, r->name);
 
 	/* Can we pull enough? */
+	/* XXX shall we limit this call to r->limit? */
+	if (r->entropy_count / 8 < min + reserved)
+		add_jent_randomness(r);
+
 	if (r->entropy_count / 8 < min + reserved) {
 		nbytes = 0;
 	} else {
