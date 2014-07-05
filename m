Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbaGETqN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:46:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaGETqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:46:12 -0400
Date: Sat, 5 Jul 2014 12:45:42 -0700
From: tip-bot for Keith Busch <tipbot@zytor.com>
Message-ID: <tip-8844aad89ed61545b4db6a3467e1b21ca1c49460@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keith.busch@intel.com, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keith.busch@intel.com, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1404167084-8070-1-git-send-email-keith.busch@intel.com>
References: <1404167084-8070-1-git-send-email-keith.busch@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Fix memory leak when calling irq_free_hwirqs()
Git-Commit-ID: 8844aad89ed61545b4db6a3467e1b21ca1c49460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8844aad89ed61545b4db6a3467e1b21ca1c49460
Gitweb:     http://git.kernel.org/tip/8844aad89ed61545b4db6a3467e1b21ca1c49460
Author:     Keith Busch <keith.busch@intel.com>
AuthorDate: Mon, 30 Jun 2014 16:24:44 -0600
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 Jul 2014 21:42:08 +0200

genirq: Fix memory leak when calling irq_free_hwirqs()

irq_free_hwirqs() always calls irq_free_descs() with a cnt == 0
which makes it a no-op since the interrupt count to free is
decremented in itself.

Fixes: 7b6ef1262549f6afc5c881aaef80beb8fd15f908

Signed-off-by: Keith Busch <keith.busch@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/1404167084-8070-1-git-send-email-keith.busch@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/irqdesc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 7339e42..1487a12 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -455,9 +455,9 @@ EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);
  */
 void irq_free_hwirqs(unsigned int from, int cnt)
 {
-	int i;
+	int i, j;
 
-	for (i = from; cnt > 0; i++, cnt--) {
+	for (i = from, j = cnt; j > 0; i++, j--) {
 		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
 		arch_teardown_hwirq(i);
 	}
