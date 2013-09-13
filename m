Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3IMWcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:32:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:44577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab3IMWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,901,1371106800"; 
   d="scan'208";a="401444554"
Date: Fri, 13 Sep 2013 15:31:59 -0700
From: Andi Kleen <ak@linux.intel.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] jump_labels: Add WARN_ON for too early jump label use
Message-ID: <20130913223159.GA22222@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spent a few hours tracking down a regression in my TSX code,
which turned out that it is not legal anymore to change jump
labels before the jump label code is initialized.

Add a WARN_ON() for this case.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 297a924..c6c5290 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -17,6 +17,8 @@
 
 #ifdef HAVE_JUMP_LABEL
 
+static bool jump_label_initialized;
+
 /* mutex to protect coming/going of the the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
@@ -58,6 +60,8 @@ static void jump_label_update(struct static_key *key, int enable);
 
 void static_key_slow_inc(struct static_key *key)
 {
+	WARN_ON(!jump_label_initialized);
+
 	if (atomic_inc_not_zero(&key->enabled))
 		return;
 
@@ -76,6 +80,7 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
+	WARN_ON(!jump_label_initialized);
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
 		WARN(atomic_read(&key->enabled) < 0,
 		     "jump label: negative count!\n");
@@ -213,6 +218,7 @@ void __init jump_label_init(void)
 #endif
 	}
 	jump_label_unlock();
+	jump_label_initialized = true;
 }
 
 #ifdef CONFIG_MODULES
-- 
ak@linux.intel.com -- Speaking for myself only
