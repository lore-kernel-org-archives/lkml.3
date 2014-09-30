Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaI3AJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:41 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63356 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751906AbaI3AJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH 3/5] ACPICA: Clear all non-wakeup GPEs in acpi_hw_enable_wakeup_gpe_block()
Date: Tue, 30 Sep 2014 02:24:38 +0200
Message-ID: <3372372.EFFo7DnmJF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1622293.rpSt5UtDk3@vostro.rjw.lan>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_hw_enable_wakeup_gpe_block() is currently always called
after disabling all GPEs, it can actually write zeros to all
non-wakeup enable bits unconditionally.

That will be useful going forward for disabling runtime GPEs and
enabling wakeup GPEs in one go instead of doing that in two steps
(disable runtime and enable wakeup) which in theory may lead to a
loss of a wakeup event.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Bob, please let me know if I can fast-track this.

---
 drivers/acpi/acpica/hwgpe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/acpica/hwgpe.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpica/hwgpe.c
+++ linux-pm/drivers/acpi/acpica/hwgpe.c
@@ -396,11 +396,11 @@ acpi_hw_enable_wakeup_gpe_block(struct a
 	/* Examine each GPE Register within the block */
 
 	for (i = 0; i < gpe_block->register_count; i++) {
-		if (!gpe_block->register_info[i].enable_for_wake) {
-			continue;
-		}
 
-		/* Enable all "wake" GPEs in this register */
+		/*
+		 * Enable all "wake" GPEs in this register and disable the
+		 * remaining ones.
+		 */
 
 		status =
 		    acpi_hw_write(gpe_block->register_info[i].enable_for_wake,

