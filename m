Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaHNFoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:44:24 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42643 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaHNFoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:44:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH v6 2/7] random, timekeeping: Collect timekeeping entropy in the timekeeping code
Date: Wed, 13 Aug 2014 22:43:56 -0700
Message-Id: <532c68b54b1894b9da1d9807701872cab28f8a70.1407994704.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
In-Reply-To: <cover.1407994704.git.luto@amacapital.net>
References: <cover.1407994704.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, init_std_data calls ktime_get_real().  This imposes
awkward constraints on when init_std_data can be called, and
init_std_data is unlikely to collect the full unpredictable data
available to the timekeeping code, especially after resume.

Remove this code from random.c and add the appropriate
add_device_randomness calls to timekeeping.c instead.

Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c     |  2 --
 kernel/time/timekeeping.c | 11 +++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7673e60..8dc3e3a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1263,12 +1263,10 @@ static void seed_entropy_store(void *ctx, u32 data)
 static void init_std_data(struct entropy_store *r)
 {
 	int i;
-	ktime_t now = ktime_get_real();
 	unsigned long rv;
 	char log_prefix[128];
 
 	r->last_pulled = jiffies;
-	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32d8d6a..9609db9 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -23,6 +23,7 @@
 #include <linux/stop_machine.h>
 #include <linux/pvclock_gtod.h>
 #include <linux/compiler.h>
+#include <linux/random.h>
 
 #include "tick-internal.h"
 #include "ntp_internal.h"
@@ -835,6 +836,9 @@ void __init timekeeping_init(void)
 	memcpy(&shadow_timekeeper, &timekeeper, sizeof(timekeeper));
 
 	write_seqcount_end(&timekeeper_seq);
+
+	add_device_randomness(tk, sizeof(tk));
+
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 
@@ -976,6 +980,13 @@ static void timekeeping_resume(void)
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, TK_MIRROR | TK_CLOCK_WAS_SET);
 	write_seqcount_end(&timekeeper_seq);
+
+	/*
+	 * The timekeeping state has a decent chance of differing
+	 * between resumptions of the same image.
+	 */
+	add_device_randomness(tk, sizeof(tk));
+
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
-- 
1.9.3

