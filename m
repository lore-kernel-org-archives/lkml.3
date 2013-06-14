Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3FNVbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3FNVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:31:41 -0400
Date: Fri, 14 Jun 2013 14:31:23 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-5a2c7ccc51a2bc42d96e05dd3d920ef0c09eb730@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        trenn@suse.de, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        trenn@suse.de, rjw@sisk.pl, hpa@linux.intel.com
In-Reply-To: <1371128589-8953-5-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-5-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, ACPI:
  Search buffer above 4GB in a second try for acpi initrd table override
Git-Commit-ID: 5a2c7ccc51a2bc42d96e05dd3d920ef0c09eb730
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:31:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a2c7ccc51a2bc42d96e05dd3d920ef0c09eb730
Gitweb:     http://git.kernel.org/tip/5a2c7ccc51a2bc42d96e05dd3d920ef0c09eb730
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:02:51 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:03:49 -0700

x86, ACPI: Search buffer above 4GB in a second try for acpi initrd table override

Now we only search buffer for new acpi tables in initrd under
4GB. In some case, like user use memmap to exclude all low ram,
we may not find range for it under 4GB. So do second try to
search for buffer above 4GB.

Since later accessing to the tables is using early_ioremap(),
using memory above 4GB is OK.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-5-git-send-email-tangchen@cn.fujitsu.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
