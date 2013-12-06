Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162622Ab3LFXox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:44:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48542 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162054Ab3LFXPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Puneet Kumar <puneetster@chromium.org>, Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 134/152] ACPI / EC: Ensure lock is acquired before accessing ec struct members
Date: Fri,  6 Dec 2013 15:10:58 -0800
Message-Id: <1386371476-2477-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/ec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 0b58c9d..97fcfb0 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -175,9 +175,10 @@ static void start_transaction(struct acpi_ec *ec)
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	struct transaction *t = ec->curr;
+	struct transaction *t;
 
 	spin_lock_irqsave(&ec->lock, flags);
+	t = ec->curr;
 	if (!t)
 		goto unlock;
 	if (t->wlen > t->wi) {
-- 
1.8.3.2

