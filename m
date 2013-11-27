Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3K0A6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3K0A62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Puneet Kumar <puneetster@chromium.org>,
        Aaron Durbin <adurbin@chromium.org>, Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 021/116] ACPI / EC: Ensure lock is acquired before accessing ec struct members
Date: Tue, 26 Nov 2013 16:56:34 -0800
Message-Id: <20131127005738.412195780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -175,9 +175,10 @@ static void start_transaction(struct acp
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


