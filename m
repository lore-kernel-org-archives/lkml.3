Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161490Ab3LGAmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:42:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884Ab3LGAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:41:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arch@vger.kernel.org, rostedt@goodmis.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, arnd@arndb.de, rusty@rustcorp.com.au,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 4/5] static_key: keep deferred enabled counter debt
Date: Sat,  7 Dec 2013 01:40:05 +0100
Message-Id: <1386376806-924-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
References: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
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
 include/linux/jump_label_ratelimit.h |  1 +
 kernel/jump_label.c                  | 17 +++++++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/jump_label_ratelimit.h b/include/linux/jump_label_ratelimit.h
index a18aded..2d5fa1a 100644
--- a/include/linux/jump_label_ratelimit.h
+++ b/include/linux/jump_label_ratelimit.h
@@ -14,6 +14,7 @@ struct static_key_deferred {
 	struct static_key key;
 	unsigned long timeout;
 	struct delayed_work work;
+	atomic_t enabled_debt;
 };
 #endif
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 41592ba..bd7ad31 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -77,12 +77,14 @@ EXPORT_SYMBOL_GPL(static_key_slow_inc);
 void static_key_slow_inc_deferred(struct static_key_deferred *key)
 {
 	STATIC_KEY_CHECK_USE();
+	if (atomic_dec_if_positive(&key->enabled_debt) >= 0)
+		return;
 	static_key_slow_inc(&key->key);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_inc_deferred);
 
 static void __static_key_slow_dec(struct static_key *key,
-		unsigned long rate_limit, struct delayed_work *work)
+		struct static_key_deferred *dkey)
 {
 	if (!atomic_dec_and_mutex_lock(&key->enabled, &jump_label_mutex)) {
 		WARN(atomic_read(&key->enabled) < 0,
@@ -90,9 +92,12 @@ static void __static_key_slow_dec(struct static_key *key,
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
@@ -106,20 +111,20 @@ static void jump_label_update_timeout(struct work_struct *work)
 {
 	struct static_key_deferred *key =
 		container_of(work, struct static_key_deferred, work.work);
-	__static_key_slow_dec(&key->key, 0, NULL);
+	__static_key_slow_dec(&key->key, NULL);
 }
 
 void static_key_slow_dec(struct static_key *key)
 {
 	STATIC_KEY_CHECK_USE();
-	__static_key_slow_dec(key, 0, NULL);
+	__static_key_slow_dec(key, NULL);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_dec);
 
 void static_key_slow_dec_deferred(struct static_key_deferred *key)
 {
 	STATIC_KEY_CHECK_USE();
-	__static_key_slow_dec(&key->key, key->timeout, &key->work);
+	__static_key_slow_dec(&key->key, key);
 }
 EXPORT_SYMBOL_GPL(static_key_slow_dec_deferred);
 
-- 
1.8.4.2

