Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaHDQuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:50:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Feng Tang" <feng.tang@intel.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.755420222@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 33/94] ACPI / EC: Don't count a SCI interrupt as a
 false one
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit a3cd8d2789c2e265e09377f260e7d2ac9cec81bb upstream.

Currently when advance_transaction() is called in EC interrupt handler,
if there is nothing driver can do with the interrupt, it will be taken
as a false one.

But this is not always true, as there may be a SCI EC interrupt fired
during normal read/write operation, which should not be counted as a
false one. This patch fixes the problem.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -205,9 +205,13 @@ static void advance_transaction(struct a
 		t->done = true;
 	goto unlock;
 err:
-	/* false interrupt, state didn't change */
-	if (in_interrupt())
+	/*
+	 * If SCI bit is set, then don't think it's a false IRQ
+	 * otherwise will take a not handled IRQ as a false one.
+	 */
+	if (in_interrupt() && !(status & ACPI_EC_FLAG_SCI))
 		++t->irq_count;
+
 unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }

