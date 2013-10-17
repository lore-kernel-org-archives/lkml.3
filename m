Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3JQKRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485Ab3JQKRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:17:40 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Jones <drjones@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/7] static_key: add static_key_slow_inc_deferred()
Date: Thu, 17 Oct 2013 12:10:25 +0200
Message-Id: <1382004631-25895-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can cancel deferred static_key_slow_dec() instead of increasing
.enabled.counter.

Timer now won't fire before 'timeout' since last increase, so this patch
further stabilizes the case of frequent switching.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 include/linux/jump_label_ratelimit.h | 5 +++++
 kernel/jump_label.c                  | 7 +++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index 1137883..e2fa2e7 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -13,6 +13,7 @@ struct static_key_deferred {
 #endif
 
 #ifdef HAVE_JUMP_LABEL
+extern void static_key_slow_inc_deferred(struct static_key_deferred *key);
 extern void static_key_slow_dec_deferred(struct static_key_deferred *key);
 extern void
 jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
@@ -21,6 +22,10 @@ jump_label_rate_limit(struct static_key_deferred *key, unsigned long rl);
 struct static_key_deferred {
 	struct static_key  key;
 };
+static inline void static_key_slow_inc_deferred(struct static_key_deferred *key)
+{
+	static_key_slow_inc(&key->key);
+}
 static inline void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
 	static_key_slow_dec(&key->key);
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 7018042..ff67257 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -73,6 +73,13 @@ void static_key_slow_inc(struct static_key *key)
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
+void static_key_slow_inc_deferred(struct static_key_deferred *key)
+{
+	if (!cancel_delayed_work(&key->work))
+		static_key_slow_inc(&key->key);
+}
+EXPORT_SYMBOL_GPL(static_key_slow_inc_deferred);
+
 static void __static_key_slow_dec(struct static_key *key,
 		unsigned long rate_limit, struct delayed_work *work)
 {
-- 
1.8.3.1

