Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbaGXE57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:57:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63793 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934165AbaGXE5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:57:47 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 2/5] random: Add and use arch_get_rng_seed
Date: Wed, 23 Jul 2014 21:57:28 -0700
Message-Id: <fe3cfe03047cc170bcde652175a00146d290bb20.1406177531.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, init_std_data contains its own logic for using arch
random sources.  This replaces that logic with a generic function
arch_get_rng_seed that allows arch code to supply its own logic.
The default implementation tries arch_get_random_seed_long and
arch_get_random_long individually.

The only functional change here is that random_get_entropy() is used
unconditionally instead of being used only when the arch sources
fail.  This may add a tiny amount of security.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c  | 14 +++++++++++---
 include/linux/random.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..be7a94e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1236,6 +1236,10 @@ void get_random_bytes_arch(void *buf, int nbytes)
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
+static void seed_entropy_store(void *ctx, u32 data)
+{
+	mix_pool_bytes((struct entropy_store *)ctx, &data, sizeof(data), NULL);
+}
 
 /*
  * init_std_data - initialize pool with system data
@@ -1251,15 +1255,19 @@ static void init_std_data(struct entropy_store *r)
 	int i;
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
+	char log_prefix[128];
 
 	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
-			rv = random_get_entropy();
+		rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
+
+	sprintf(log_prefix, "random: seeded %s pool", r->name);
+	arch_get_rng_seed(r, seed_entropy_store, 8 * r->poolinfo->poolbytes,
+			  log_prefix);
+
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
 }
 
diff --git a/include/linux/random.h b/include/linux/random.h
index 57fbbff..81a6145 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -106,6 +106,46 @@ static inline int arch_has_random_seed(void)
 }
 #endif
 
+#ifndef __HAVE_ARCH_GET_RNG_SEED
+
+/**
+ * arch_get_rng_seed() - get architectural rng seed data
+ * @ctx: context for the seed function
+ * @seed: function to call for each u32 obtained
+ * @bits_per_source: number of bits from each source to try to use
+ * @log_prefix: beginning of log output (may be NULL)
+ *
+ * Synchronously load some architectural entropy or other best-effort
+ * random seed data.  An arch-specific implementation should be no worse
+ * than this generic implementation.  If the arch code does something
+ * interesting, it may log something of the form "log_prefix with
+ * 8 bits of stuff".
+ *
+ * No arch-specific implementation should be any worse than the generic
+ * implementation.
+ */
+static inline void arch_get_rng_seed(void *ctx,
+				     void (*seed)(void *ctx, u32 data),
+				     int bits_per_source,
+				     const char *log_prefix)
+{
+	int i;
+
+	for (i = 0; i < bits_per_source; i += 8 * sizeof(long)) {
+		unsigned long rv;
+
+		if (arch_get_random_seed_long(&rv) ||
+		    arch_get_random_long(&rv)) {
+			seed(ctx, (u32)rv);
+#if BITS_PER_LONG > 32
+			seed(ctx, (u32)(rv >> 32));
+#endif
+		}
+	}
+}
+
+#endif /* __HAVE_ARCH_GET_RNG_SEED */
+
 /* Pseudo random number generator from numerical recipes. */
 static inline u32 next_pseudo_random32(u32 seed)
 {
-- 
1.9.3

