Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaILOBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:01:04 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44337 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaILOA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:00:59 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 03/18] ACPI / table: Count matched and successfully parsed entries without specifying max entries
Date: Fri, 12 Sep 2014 22:00:01 +0800
Message-Id: <1410530416-30200-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Nowicki <tomasz.nowicki@linaro.org>

It is very useful to traverse all available table entries without max
number of expected entries type. Current acpi_parse_entries()
implementation gives that feature but it does not count those entries,
it returns 0 instead, so fix it to count matched and successfully
entries and return it.

NOTE: This change has no impact to x86 and ia64 archs since existing code
checks for error occurrence only (acpi_parse_entries(...,0) < 0).

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/tables.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 21ae521..b18e45e 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -225,10 +225,13 @@ acpi_parse_entries(unsigned long table_size,
 	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
 	       table_end) {
 		if (entry->type == entry_id
-		    && (!max_entries || count++ < max_entries))
+		    && (!max_entries || count < max_entries)) {
 			if (handler(entry, table_end))
 				return -EINVAL;
 
+			count++;
+		}
+
 		/*
 		 * If entry->length is 0, break from this loop to avoid
 		 * infinite loop.
-- 
1.7.9.5

