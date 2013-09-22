Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IVVWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:22:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36542 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab3IVVWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:22:45 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1379882338-7209-11-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu> <1379882338-7209-11-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH, RFC 10/12] random: cap the rate which the /dev/urandom pool gets reseeded
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 22 Sep 2013 14:21:48 -0700
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
CC: joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de
Message-ID: <e665f20c-9154-4dbd-bb93-cf144922bf29@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this really an improvement on a system with plenty of entropy? Would it not make more sense to modulate this bad on entropy production rates?

Also, the urandom pool is only reseeded once per read, no matter how large...

Theodore Ts'o <tytso@mit.edu> wrote:
>In order to avoid draining the input pool of its entropy at too high
>of a rate, enforce a minimum time interval between reseedings of the
>urandom pool.  This is set to 60 seconds by default.
>
>Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>---
> drivers/char/random.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
>
>diff --git a/drivers/char/random.c b/drivers/char/random.c
>index 292e717..3439b1c 100644
>--- a/drivers/char/random.c
>+++ b/drivers/char/random.c
>@@ -306,6 +306,13 @@ static int random_read_wakeup_thresh = 64;
> static int random_write_wakeup_thresh = 128;
> 
> /*
>+ * The minimum number of seconds between urandom pool resending.  We
>+ * do this to limit the amount of entropy that can be drained from the
>+ * input pool even if there are heavy demands on /dev/urandom.
>+ */
>+static int random_min_urandom_seed = 60;
>+
>+/*
>  * When the input pool goes over trickle_thresh, start dropping most
>  * samples to avoid wasting CPU time and reduce lock contention.
>  */
>@@ -437,6 +444,7 @@ struct entropy_store {
> 	struct entropy_store *pull;
> 
> 	/* read-write data: */
>+	unsigned long last_pulled;
> 	spinlock_t lock;
> 	unsigned short add_ptr;
> 	unsigned short input_rotate;
>@@ -885,6 +893,15 @@ static void xfer_secondary_pool(struct
>entropy_store *r, size_t nbytes)
> {
> 	__u32	tmp[OUTPUT_POOL_WORDS];
> 
>+	if (r->limit == 0 && random_min_urandom_seed) {
>+		unsigned long now = jiffies;
>+
>+		if (time_before(now,
>+				r->last_pulled + random_min_urandom_seed * HZ)) {
>+			return;
>+		}
>+		r->last_pulled = now;
>+	}
> 	if (r->pull &&
> 	    r->entropy_count < (nbytes << (ENTROPY_SHIFT + 3)) &&
> 	    r->entropy_count < r->poolinfo->poolfracbits) {
>@@ -1188,6 +1205,7 @@ static void init_std_data(struct entropy_store
>*r)
> 	r->entropy_count = 0;
> 	r->entropy_total = 0;
> 	r->last_data_init = 0;
>+	r->last_pulled = jiffies;
> 	mix_pool_bytes(r, &now, sizeof(now), NULL);
> 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
> 		if (!arch_get_random_long(&rv))
>@@ -1539,6 +1557,13 @@ struct ctl_table random_table[] = {
> 		.extra2		= &max_write_thresh,
> 	},
> 	{
>+		.procname	= "urandom_min_reseed_secs",
>+		.data		= &random_min_urandom_seed,
>+		.maxlen		= sizeof(int),
>+		.mode		= 0644,
>+		.proc_handler	= proc_dointvec,
>+	},
>+	{
> 		.procname	= "boot_id",
> 		.data		= &sysctl_bootid,
> 		.maxlen		= 16,

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
