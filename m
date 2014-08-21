Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaHUTyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:54:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:19195 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383AbaHUTyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:54:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,374,1406617200"; 
   d="scan'208";a="580059693"
From: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>, "Brown, Len" <len.brown@intel.com>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [PATCH 1/2] ACPI/EC: Add support to disallow QR_EC to be issued
 when SCI_EVT isn't set.
Thread-Topic: [PATCH 1/2] ACPI/EC: Add support to disallow QR_EC to be
 issued when SCI_EVT isn't set.
Thread-Index: AQHPvQr2JUyZaFTHTEqysb260PMA25vbeTZG
Date: Thu, 21 Aug 2014 19:53:59 +0000
Message-ID: <t5ih48qxyoaaoynlvcp730r5.1408650859569@email.android.com>
References: <cover.1408601898.git.lv.zheng@intel.com>,<9a544afa81d0108f9aef655d0fb6e9709f34afe0.1408601898.git.lv.zheng@intel.com>
In-Reply-To: <9a544afa81d0108f9aef655d0fb6e9709f34afe0.1408601898.git.lv.zheng@intel.com>
Reply-To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of putting a link to the BZ entry in the comment, please what machine is affected in there. Looks good otherwise.

Rafael



-------- Original message --------
>From "Zheng, Lv" <lv.zheng@intel.com>
Date: 21/08/2014 08:41 (GMT+01:00)
To "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,"Brown, Len" <len.brown@intel.com>
Cc "Zheng, Lv" <lv.zheng@intel.com>,Lv Zheng <zetalog@gmail.com>,linux-kernel@vger.kernel.org,linux-acpi@vger.kernel.org
Subject [PATCH 1/2] ACPI/EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set.


There is platform refusing to respond QR_EC when SCI_EVT isn't set. A known
such platform is Acer Aspire V5-573G.

Currently we rely on the behaviour that the EC firmware can respond
something (for example, 0x00 to indicate "no outstanding events") to QR_EC
even when SCI_EVT is not set. But reporter has complained for AC/battery
pluging/unpluging, video brightness change delay on such platform.

This is because the work item that has issued QR_EC has to wait until
timeout in this case, and the _Qxx method evaluation work item queued after
QR_EC one is delayed.

It sounds reasonable to fix this issue by:
1. Implementing SCI_EVT sanity check before issuing QR_EC in the EC
   driver's main state machine.
2. Moving QR_EC issuing out of the work queue used by _Qxx evaluation to a
   seperate IRQ handling thread.

This patch fixes this issue using solution 1. The solution 2 has been
implemented by another already published patch:
"https://lkml.org/lkml/2014/7/21/41".

By disallowing QR_EC to be issued when SCI_EVT isn't set, we are able to
handle such platform in the EC driver's main state machine. This patch
enhances the state machine in this way to survive with such malfunctioning
EC firmware.

Note that this patch can also fix CLEAR_ON_RESUME quirk which also relies
on the assumption that the platforms are able to respond even when SCI_EVT
isn't set.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=82611
Reported-and-tested-by: Alexander Mezin <mezin.alexander@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a66ab65..5e1ed31 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -197,6 +197,8 @@ static bool advance_transaction(struct acpi_ec *ec)
                                 t->rdata[t->ri++] = acpi_ec_read_data(ec);
                                 if (t->rlen == t->ri) {
                                         t->flags |= ACPI_EC_COMMAND_COMPLETE;
+                                       if (t->command == ACPI_EC_COMMAND_QUERY)
+                                               pr_debug("hardware QR_EC completion\n");
                                         wakeup = true;
                                 }
                         } else
@@ -208,7 +210,20 @@ static bool advance_transaction(struct acpi_ec *ec)
                 }
                 return wakeup;
         } else {
-               if ((status & ACPI_EC_FLAG_IBF) == 0) {
+               /*
+                * There is firmware refusing to respond QR_EC when SCI_EVT
+                * is not set, for which case, we complete the QR_EC
+                * without issuing it to the firmware.
+                * https://bugzilla.kernel.org/show_bug.cgi?id=86211
+                */
+               if (!(status & ACPI_EC_FLAG_SCI) &&
+                   (t->command == ACPI_EC_COMMAND_QUERY)) {
+                       t->flags |= ACPI_EC_COMMAND_POLL;
+                       t->rdata[t->ri++] = 0x00;
+                       t->flags |= ACPI_EC_COMMAND_COMPLETE;
+                       pr_debug("software QR_EC completion\n");
+                       wakeup = true;
+               } else if ((status & ACPI_EC_FLAG_IBF) == 0) {
                         acpi_ec_write_cmd(ec, t->command);
                         t->flags |= ACPI_EC_COMMAND_POLL;
                 } else
--
1.7.10

