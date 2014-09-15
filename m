Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbaIOU4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:56:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbaIOT1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 100/158] ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC
Date: Mon, 15 Sep 2014 12:25:39 -0700
Message-Id: <20140915192545.886024370@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4 upstream.

There is platform refusing to respond QR_EC when SCI_EVT isn't set
which is Acer Aspire V5-573G.

By disallowing QR_EC to be issued before the previous one has been
completed we are able to reduce the possibilities to trigger issues on
such platforms.

Note that this fix can only reduce the occurrence rate of this issue, but
this issue may still occur when such a platform doesn't clear SCI_EVT
before or immediately after completing the previous QR_EC transaction.
This patch cannot fix the CLEAR_ON_RESUME quirk which also relies on
the assumption that the platforms are able to respond even when SCI_EVT
isn't set.

But this patch is still useful as it can help to reduce the number of
scheduled QR_EC work items.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reported-and-tested-by: Alexander Mezin <mezin.alexander@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -303,11 +303,11 @@ static int acpi_ec_transaction_unlocked(
 	/* following two actions should be kept atomic */
 	ec->curr = t;
 	start_transaction(ec);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
-		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
+	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	ec->curr = NULL;
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	return ret;


