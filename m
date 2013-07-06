Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3GFMPp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 08:15:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47904 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3GFMPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 08:15:22 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] apic: add lock annotations to squelch sparse warnings
Date: Sat,  6 Jul 2013 17:41:25 +0530
Message-Id: <1373112686-28501-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.733.gf8abaeb
In-Reply-To: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
References: <1373112686-28501-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse, being a static analyzer, emits the following warnings:

  context imbalance in 'lock_vector_lock' - wrong count at exit
  context imbalance in 'unlock_vector_lock' - unexpected unlock

Help it by annotating the pair of functions with __acquires and
__releases.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..b756417 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1061,6 +1061,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
 void lock_vector_lock(void)
+	__acquires(&vector_lock)
 {
 	/* Used to the online set of cpus does not change
 	 * during assign_irq_vector.
@@ -1069,6 +1070,7 @@ void lock_vector_lock(void)
 }
 
 void unlock_vector_lock(void)
+	__releases(&vector_lock)
 {
 	raw_spin_unlock(&vector_lock);
 }
-- 
1.8.3.2.733.gf8abaeb

