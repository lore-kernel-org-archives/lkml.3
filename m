Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3JQKRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:17:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3JQKRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:17:47 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/7] static_key: keep deferred enabled counter debt
Date: Thu, 17 Oct 2013 12:10:26 +0200
Message-Id: <1382004631-25895-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When '.enabled.counter == 1', static_key_slow_dec_deferred() gets
silently dropped if the decrease is already pending.

We print a warning if this happens and because .enabled.counter cannot
go below 1 before the decrease has finished, the number of ignored
static_key_slow_dec_deferred() is kept and we skip an equal amount of
static_key_slow_inc_deferred().

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
atomic_dec_if_positive() is weird ...

 include/linux/jump_label_ratelimit.h |  1 +
 kernel/jump_label.c                  | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index e2fa2e7..e3a7a83 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -9,6 +9,7 @@ struct static_key_deferred {
 	struct static_key key;
 	unsigned long timeout;
 	struct delayed_work work;
+	atomic_t enabled_debt;
 };
 #endif
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index ff67257..30aa3b0 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -75,13 +75,15 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 
 void static_key_slow_inc_deferred(struct static_key_deferred *key)
 {
+	if (atomic_dec_if_positive(&key->enabled_debt) >= 0)
+		return;
 	if (!cancel_delayed_work(&key->work))
 		static_key_slow_inc(&key->key);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc_deferred);
 
 static void __static_key_slow_dec(struct static_key *key,
-		unsigned long rate_limit, struct delayed_work *work)
+		struct static_key_deferred *dkey)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
 		WARN(atomic_read(&key->enabled) < 0,
@@ -89,9 +91,12 @@ static void __static_key_slow_dec(struct static_key *key,
 		return;
 	}
 
-	if (rate_limit) {
+	if (dkey && dkey->timeout) {
 		atomic_inc(&key->enabled);
-		schedule_delayed_work(work, rate_limit);
+		if (!schedule_delayed_work(&dkey->work, dkey->timeout)) {
+			atomic_inc(&dkey->enabled_debt);
+			WARN(1, "jump label: negative deferred count!\n");
+		}
 	} else {
 		if (!jump_label_get_branch_default(key))
 			jump_label_update(key, JUMP_LABEL_DISABLE);
@@ -105,18 +110,18 @@ static void jump_label_update_timeout(struct work_struct *work)
 {
 	struct static_key_deferred *key =
 		container_of(work, struct static_key_deferred, work.work);
-	__static_key_slow_dec(&key->key, 0, NULL);
+	__static_key_slow_dec(&key->key, NULL);
 }
 
 void static_key_slow_dec(struct static_key *key)
 {
-	__static_key_slow_dec(key, 0, NULL);
+	__static_key_slow_dec(key, NULL);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_dec);
 
 void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
-	__static_key_slow_dec(&key->key, key->timeout, &key->work);
+	__static_key_slow_dec(&key->key, key);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
 
-- 
1.8.3.1

