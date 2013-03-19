Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3CSUZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:25:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20138 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab3CSUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:25:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/acpi-processor: Don't dereference struct acpi_processor on all CPUs.
Date: Tue, 19 Mar 2013 16:25:26 -0400
Message-Id: <1363724726-757-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With git commit c705c78c0d0835a4aa5d0d9a3422e3218462030c
"acpi: Export the acpi_processor_get_performance_info" we are now
using a different mechanism to access the P-states.

The acpi_processor per-cpu structure is set and filtered by the
core ACPI code which shrinks the per_cpu contents to only online CPUs.
In the past we would call acpi_processor_register_performance()
which would have not tried to dereference offline cpus.

With the new patch and the fact that the loop we take is for
for_all_possible_cpus we end up crashing on some machines.
We could modify the loop to be for online_cpus - but all the other
loops in the code use possible_cpus (for a good reason) - so lets
leave it as so and just check if per_cpu(processor) is NULL.

With this patch we will bypass the !online but possible CPUs.
This fixes:

IP: [<ffffffffa00d13b5>] xen_acpi_processor_init+0x1b6/0xe01 [xen_acpi_processor]
PGD 4126e6067 PUD 4126e3067 PMD 0
Oops: 0002 [#1] SMP
Pid: 432, comm: modprobe Not tainted 3.9.0-rc3+ #28 To be filled by O.E.M. To be filled by O.E.M./M5A97
RIP: e030:[<ffffffffa00d13b5>]  [<ffffffffa00d13b5>] xen_acpi_processor_init+0x1b6/0xe01 [xen_acpi_processor]
RSP: e02b:ffff88040c8a3ce8  EFLAGS: 00010282
.. snip..
Call Trace:
 [<ffffffffa00d11ff>] ? read_acpi_id+0x12b/0x12b [xen_acpi_processor]
 [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
 [<ffffffff810c42c3>] load_module+0x1cd3/0x2870
 [<ffffffff81319b70>] ? ddebug_proc_open+0xc0/0xc0
 [<ffffffff810c4f37>] sys_init_module+0xd7/0x120
 [<ffffffff8166ce19>] system_call_fastpath+0x16/0x1b

on some machines.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-processor.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index f3278a6..90e34ac 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -505,6 +505,9 @@ static int __init xen_acpi_processor_init(void)
 
 		pr = per_cpu(processors, i);
 		perf = per_cpu_ptr(acpi_perf_data, i);
+		if (!pr)
+			continue;
+
 		pr->performance = perf;
 		rc = acpi_processor_get_performance_info(pr);
 		if (rc)
-- 
1.8.0.2

