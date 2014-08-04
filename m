Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaHDQ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:58:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56589 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Olof Johansson" <olof@lixom.net>,
        "Aaron Durbin" <adurbin@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Puneet Kumar" <puneetster@chromium.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.98931941@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 31/94] ACPI / EC: Ensure lock is acquired before
 accessing ec struct members
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Puneet Kumar <puneetster@chromium.org>

commit 36b15875a7819a2ec4cb5748ff7096ad7bd86cbb upstream.

A bug was introduced by commit b76b51ba0cef ('ACPI / EC: Add more debug
info and trivial code cleanup') that erroneously caused the struct member
to be accessed before acquiring the required lock.  This change fixes
it by ensuring the lock acquisition is done first.

Found by Aaron Durbin <adurbin@chromium.org>

Fixes: b76b51ba0cef ('ACPI / EC: Add more debug info and trivial code cleanup')
References: http://crbug.com/319019
Signed-off-by: Puneet Kumar <puneetster@chromium.org>
Reviewed-by: Aaron Durbin <adurbin@chromium.org>
[olof: Commit message reworded a bit]
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/ec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -178,9 +178,10 @@ static void start_transaction(struct acp
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	struct transaction *t = ec->curr;
+	struct transaction *t;
 
 	spin_lock_irqsave(&ec->curr_lock, flags);
+	t = ec->curr;
 	if (!t)
 		goto unlock;
 	if (t->wlen > t->wi) {

