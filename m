Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaGPVrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:47:23 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:50244 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaGPVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:45:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/5] random: Seed pools from arch_get_slow_rng_u64 at startup
Date: Wed, 16 Jul 2014 14:45:35 -0700
Message-Id: <8de3797d8f49579b0751aea09f7686ef33232146.1405546879.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405546879.git.luto@amacapital.net>
References: <cover.1405546879.git.luto@amacapital.net>
In-Reply-To: <cover.1405546879.git.luto@amacapital.net>
References: <cover.1405546879.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should help solve the problem of guests starting out with
predictable RNG state.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0a7ac0a..17ad33d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1261,6 +1261,13 @@ static void init_std_data(struct entropy_store *r)
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
+
+	for (i = 0; i < 4; i++) {
+		u64 rv64;
+
+		if (arch_get_slow_rng_u64(&rv64))
+			mix_pool_bytes(r, &rv64, sizeof(rv64), NULL);
+	}
 }
 
 /*
-- 
1.9.3

