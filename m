Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3ETLZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:25:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:10392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab3ETLZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:25:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,707,1363158000"; 
   d="scan'208";a="244088727"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2] ACPI: implement acpi_os_get_timer() according the spec
Date: Mon, 20 May 2013 14:28:02 +0300
Message-Id: <1369049282-18550-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <31117704.gbekCQk8l6@vostro.rjw.lan>
References: <31117704.gbekCQk8l6@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI Timer() opcode should return monotonically increasing clock with 100ns
granularity according the ACPI 5.0 spec.

Testing the current Timer() implementation with following ASL code (and an
additional debug print in acpi_os_sleep() to get the sleep times dumped out
to dmesg):

	// Test: 10ms
	Store(Timer, Local1)
	Sleep(10)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

	// Test: 200ms
	Store(Timer, Local1)
	Sleep(200)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

	// Test 1300ms
	Store(Timer, Local1)
	Sleep(1300)
	Divide(Subtract(Timer, Local1), 10000,, Local1)
	Sleep(Local1)

The second sleep value is calculated using Timer(). If the implementation
is good enough we should be able to get the second value pretty close to
the first.

However, the current Timer() gives pretty bad sleep times:

	[   11.488100] ACPI: acpi_os_get_timer() TBD
	[   11.492150] ACPI: Sleep(10)
	[   11.502993] ACPI: Sleep(0)
	[   11.506315] ACPI: Sleep(200)
	[   11.706237] ACPI: Sleep(0)
	[   11.709550] ACPI: Sleep(1300)
	[   13.008929] ACPI: Sleep(0)

Fix this with the help of ktime_get(). Once the fix is applied and run
against the same ASL code we get:

	[   11.486786] ACPI: Sleep(10)
	[   11.499029] ACPI: Sleep(12)
	[   11.512350] ACPI: Sleep(200)
	[   11.712282] ACPI: Sleep(200)
	[   11.912170] ACPI: Sleep(1300)
	[   13.211577] ACPI: Sleep(1300)

That is much more closer to the values we expected.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/osl.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e721863..cdda7cf 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -835,19 +835,7 @@ void acpi_os_stall(u32 us)
  */
 u64 acpi_os_get_timer(void)
 {
-	static u64 t;
-
-#ifdef	CONFIG_HPET
-	/* TBD: use HPET if available */
-#endif
-
-#ifdef	CONFIG_X86_PM_TIMER
-	/* TBD: default to PM timer if HPET was not available */
-#endif
-	if (!t)
-		printk(KERN_ERR PREFIX "acpi_os_get_timer() TBD\n");
-
-	return ++t;
+	return ktime_to_ns(ktime_get()) / 100;
 }
 
 acpi_status acpi_os_read_port(acpi_io_address port, u32 * value, u32 width)
-- 
1.7.10.4

