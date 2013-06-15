Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3FOA7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 20:59:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17646 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3FOA5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:57:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH v5 04/22] x86, ACPI: Search buffer above 4G in second try for acpi override tables
Date: Fri, 14 Jun 2013 17:56:22 -0700
Message-Id: <1371257800-11720-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we only search buffer for override acpi table under 4G.
In some case, like user use memmap to exclude all low ram,
we may not find range for it under 4G.

Do second try to search above 4G.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/osl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 93e3194..42c48fc 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -627,6 +627,10 @@ void __init acpi_initrd_override(void *data, size_t size)
 	/* under 4G at first, then above 4G */
 	acpi_tables_addr = memblock_find_in_range(0, (1ULL<<32) - 1,
 					all_tables_size, PAGE_SIZE);
+	if (!acpi_tables_addr)
+		acpi_tables_addr = memblock_find_in_range(0,
+					~(phys_addr_t)0,
+					all_tables_size, PAGE_SIZE);
 	if (!acpi_tables_addr) {
 		WARN_ON(1);
 		return;
-- 
1.8.1.4

