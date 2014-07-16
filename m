Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbaGPRrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:47:15 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53718 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760294AbaGPRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:46:24 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 4/5] random: Log how many bits we managed to seed with in init_std_data
Date: Wed, 16 Jul 2014 10:45:59 -0700
Message-Id: <e168570a9d9769e1f9e4e0a5c81d55bd5c1ba9b6.1405532533.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405532533.git.luto@amacapital.net>
References: <cover.1405532533.git.luto@amacapital.net>
In-Reply-To: <cover.1405532533.git.luto@amacapital.net>
References: <cover.1405532533.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for making sure that init_std_data is working
correctly and for allaying fear when this happens:

    random: xyz urandom read with SMALL_NUMBER bits of entropy available

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index e2c3d02..10e9642 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1251,12 +1251,16 @@ static void init_std_data(struct entropy_store *r)
 	int i;
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
+	int arch_seed_bits = 0, arch_random_bits = 0, slow_rng_bits = 0;
 
 	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
-		if (!arch_get_random_seed_long(&rv) &&
-		    !arch_get_random_long(&rv))
+		if (arch_get_random_seed_long(&rv))
+			arch_seed_bits += 8 * sizeof(rv);
+		else if (arch_get_random_long(&rv))
+			arch_random_bits += 8 * sizeof(rv);
+		else
 			rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
@@ -1265,10 +1269,14 @@ static void init_std_data(struct entropy_store *r)
 	for (i = 0; i < 4; i++) {
 		u64 rv64;
 
-		if (arch_get_slow_rng_u64(&rv64))
+		if (arch_get_slow_rng_u64(&rv64)) {
 			mix_pool_bytes(r, &rv64, sizeof(rv64), NULL);
+			slow_rng_bits += 8 * sizeof(rv64);
 		}
 	}
+
+	pr_info("random: seeded %s pool with %d bits of arch random seed, %d bits of arch random, and %d bits of arch slow rng\n",
+		r->name, arch_seed_bits, arch_random_bits, slow_rng_bits);
 }
 
 /*
-- 
1.9.3

