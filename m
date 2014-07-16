Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbaGPCsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:48:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55822 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759176AbaGPCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:48:35 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/4] random: Seed pools from arch_get_slow_rng_u64 at startup
Date: Tue, 15 Jul 2014 19:48:09 -0700
Message-Id: <c6f07a63601fbb36c09bf250b5538abb47b51e44.1405477965.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405477965.git.luto@amacapital.net>
References: <cover.1405477965.git.luto@amacapital.net>
In-Reply-To: <cover.1405477965.git.luto@amacapital.net>
References: <cover.1405477965.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should help solve the problem of guests starting out with
predictable RNG state.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..bd88a24 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1248,7 +1248,7 @@ EXPORT_SYMBOL(get_random_bytes_arch);
  */
 static void init_std_data(struct entropy_store *r)
 {
-	int i;
+	int i, slow_rng_bits = 0;
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
 
@@ -1261,6 +1261,18 @@ static void init_std_data(struct entropy_store *r)
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
+
+	for (i = 0; i < 4; i++) {
+		u64 rv64;
+
+		if (arch_get_slow_rng_u64(&rv64)) {
+			mix_pool_bytes(r, &rv64, sizeof(rv64), NULL);
+			slow_rng_bits += 8 * sizeof(rv64);
+		}
+	}
+	if (slow_rng_bits)
+		pr_info("random: seeded %s pool with %d bits of arch slow rng data\n",
+		       r->name, slow_rng_bits);
 }
 
 /*
-- 
1.9.3

