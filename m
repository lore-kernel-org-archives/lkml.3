Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161399Ab3LGAmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:42:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758839Ab3LGAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:41:26 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-arch@vger.kernel.org, rostedt@goodmis.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, arnd@arndb.de, rusty@rustcorp.com.au,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 2/5] static_key: cancel rate limit timer on rmmod
Date: Sat,  7 Dec 2013 01:40:03 +0100
Message-Id: <1386376806-924-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
References: <1386376806-924-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug when we free module's memory while a timer is pending by
canceling all deferred timers from the unloaded module.

static_key_rate_limit() still can't be called more than once.

Reproducer: (host crasher)
  modprobe kvm_intel
  (sleep 1; echo quit) \
    | qemu-kvm -kernel /dev/null -monitor stdio &
  sleep 0.5
  until modprobe -rv kvm_intel 2>/dev/null; do :; done

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
I decided not to post a patch that uses __deferred_key in kernel/module init,
so these three functions might seem like an overkill.

 kernel/jump_label.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 9019f15..02d610a 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -125,6 +125,27 @@ void jump_label_rate_limit(struct static_key_deferred *key,
 }
 EXPORT_SYMBOL_GPL(jump_label_rate_limit);
 
+/* could (should?) be abstracted more */
+static void with_deferred_keys(struct static_key_deferred *entry,
+                               struct static_key_deferred *stop,
+                               void (*op)(struct static_key_deferred *))
+{
+	struct static_key_deferred *iter;
+
+	for (iter = entry; iter < stop; iter++)
+		op(iter);
+}
+
+#define with_module_deferred_keys(mod, op) \
+	with_deferred_keys(mod->deferred_keys, \
+	                   mod->deferred_keys + mod->num_deferred_keys, \
+	                   op)
+
+static void deferred_key_cancel_work(struct static_key_deferred *dkey)
+{
+	cancel_delayed_work_sync(&dkey->work);
+}
+
 static int addr_conflict(struct jump_entry *entry, void *start, void *end)
 {
 	if (entry->code <= (unsigned long)end &&
@@ -385,6 +406,7 @@ jump_label_module_notify(struct notifier_block *self, unsigned long val,
 		jump_label_unlock();
 		break;
 	case MODULE_STATE_GOING:
+		with_module_deferred_keys(mod, deferred_key_cancel_work);
 		jump_label_lock();
 		jump_label_del_module(mod);
 		jump_label_unlock();
-- 
1.8.4.2

