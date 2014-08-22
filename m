Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaHVBGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:06:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:44406 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbaHVBGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:06:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,376,1406617200"; 
   d="scan'208";a="471435132"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 2/2] ACPI/EC: Add support to disallow QR_EC to be issued
 before completing the previous QR_EC.
Thread-Topic: [PATCH 2/2] ACPI/EC: Add support to disallow QR_EC to be
 issued before completing the previous QR_EC.
Thread-Index: AQHPvQryzjBaUJxvYEm9W2/dwnNrEpvbeWSWgABWBrA=
Date: Fri, 22 Aug 2014 01:06:29 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880265EEBB@SHSMSX101.ccr.corp.intel.com>
References: <cover.1408601898.git.lv.zheng@intel.com>,<54a1dc3591438f6fc5765dbabc17bdaa50df0dd4.1408601898.git.lv.zheng@intel.com>
 <8f2s2dygqwh6mr6ccsao7k5m.1408650984840@email.android.com>
In-Reply-To: <8f2s2dygqwh6mr6ccsao7k5m.1408650984840@email.android.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7M16fXM009904

Hi, Rafael

I think PATCH 1 is required for now and this PATCH is not that useful if you are planning to merge my storming fix, the logic has already been cleaned there.

This flag originally is used to mark the period after SCI_EVT is indicated and before the QR_EC is polled.
This flag is useful because during this period some malfunctioning firmware may trigger GPE storm as we haven't handled SCI_EVT right in the IRQ context.
But so far we havenâ€™t ACPICA GPE APIs ready to achieve such storm prevention, the original use case is not that obvious nowâ€¦.
Actually this flag is currently only used to masking query issuing...

This patch change the flag to be used for this case â€“ marking the period after SCI_EVT is indicated and before the QR_EC is completed.
Since the original usage is actually not implemented, we can do this change.

But you also can ignore this patch as the cleanup in the storming series is cleaner than this.
In that series, the both cases are marked and thus can be protected by further code.

So itâ€™s up to you whether you need PATCH 2 or not. â˜º
If you took it, I would re-base the storming series to reflect this change.

Thanks and best regards
-Lv


From: Wysocki, Rafael J 
Sent: Friday, August 22, 2014 3:55 AM
To: Zheng, Lv; Brown, Len
Cc: Lv Zheng; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org
Subject: RE: [PATCH 2/2] ACPI/EC: Add support to disallow QR_EC to be issued before completing the previous QR_EC.

Looks OK to me.

Rafael



-------- Original message --------
>From "Zheng, Lv" <lv.zheng@intel.com> 
Date: 21/08/2014 08:41 (GMT+01:00) 
To "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,"Brown, Len" <len.brown@intel.com> 
Cc "Zheng, Lv" <lv.zheng@intel.com>,Lv Zheng <zetalog@gmail.com>,linux-kernel@vger.kernel.org,linux-acpi@vger.kernel.org 
Subject [PATCH 2/2] ACPI/EC: Add support to disallow QR_EC to be issued before completing the previous QR_EC. 

There is platform refusing to respond QR_EC when SCI_EVT isn't set.
A known such platform is Acer Aspire V5-573G.

By disallowing QR_EC issuing without completing the previous one, we are
able to reduce the possibilities to trigger issues on such platforms.

Note that this fix can only reduce the occurrence rate of this issue, but
this issue may still occur when such a platform doesn't clear SCI_EVT
before or immediately after completing the previous QR_EC transaction. This
patch cannot fix CLEAR_ON_RESUME quirk which also relies on the assumption
that the platforms are able to respond even when SCI_EVT isn't set.

But this patch is still useful as it can help to reduce the number of
scheduled QR_EC work items.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reported-and-tested-by: Alexander Mezin <mezin.alexander@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
Â drivers/acpi/ec.c |Â Â Â  4 ++--
Â 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5e1ed31..9922cc4 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -303,11 +303,11 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
Â Â Â Â Â Â Â Â  /* following two actions should be kept atomic */
Â Â Â Â Â Â Â Â  ec->curr = t;
Â Â Â Â Â Â Â Â  start_transaction(ec);
-Â Â Â Â Â Â  if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
-Â Â Â Â Â Â Â Â Â Â Â Â Â Â  clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
Â Â Â Â Â Â Â Â  spin_unlock_irqrestore(&ec->lock, tmp);
Â Â Â Â Â Â Â Â  ret = ec_poll(ec);
Â Â Â Â Â Â Â Â  spin_lock_irqsave(&ec->lock, tmp);
+Â Â Â Â Â Â  if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+Â Â Â Â Â Â Â Â Â Â Â Â Â Â  clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
Â Â Â Â Â Â Â Â  ec->curr = NULL;
Â Â Â Â Â Â Â Â  spin_unlock_irqrestore(&ec->lock, tmp);
Â Â Â Â Â Â Â Â  return ret;
-- 
1.7.10
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
