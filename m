Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbATWVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:21:07 -0500
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:60889
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbbATWVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:21:05 -0500
From: Tom Huynh <tom.huynh@freescale.com>
To: <benh@kernel.crashing.org>, <paulus@samba.org>, <mpe@ellerman.id.au>,
        <cl@linux.com>, <tj@kernel.org>
CC: <kim.phillips@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, Tom Huynh <tom.huynh@freescale.com>
Subject: [PATCH] powerpc/perf: fix fsl_emb_pmu_start to write correct pmc value
Date: Tue, 20 Jan 2015 16:19:50 -0600
Message-ID: <1421792390-2400-1-git-send-email-tom.huynh@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=tom.huynh@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(50226001)(47776003)(2201001)(64706001)(86362001)(46102003)(48376002)(6806004)(19580405001)(50986999)(50466002)(97736003)(19580395003)(77156002)(87936001)(77096005)(68736005)(229853001)(57986006)(36756003)(105606002)(104016003)(106466001)(76506005)(62966003)(92566002)(85426001)(33646002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0748;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:CY1PR0301MB0748;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0748;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0748;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 22:21:00.4895
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0748
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0713;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PMCs on PowerPC increases towards 0x80000000 and triggers an overflow
interrupt when the msb is set to collect a sample. Therefore, to setup
for the next sample collection, pmu_start should set the pmc value to
0x80000000 - left instead of left which incorrectly delays the next
overflow interrupt. Same as commit 9a45a9407c69 ("powerpc/perf:
power_pmu_start restores incorrect values, breaking frequency events")
for book3s.

Signed-off-by: Tom Huynh <tom.huynh@freescale.com>
---
 arch/powerpc/perf/core-fsl-emb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-fsl-emb.c b/arch/powerpc/perf/core-fsl-emb.c
index 4acaea0..e9fe904 100644
--- a/arch/powerpc/perf/core-fsl-emb.c
+++ b/arch/powerpc/perf/core-fsl-emb.c
@@ -389,6 +389,7 @@ static void fsl_emb_pmu_del(struct perf_event *event, int flags)
 static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
 {
 	unsigned long flags;
+	unsigned long val;
 	s64 left;
 
 	if (event->hw.idx < 0 || !event->hw.sample_period)
@@ -405,7 +406,10 @@ static void fsl_emb_pmu_start(struct perf_event *event, int ef_flags)
 
 	event->hw.state = 0;
 	left = local64_read(&event->hw.period_left);
-	write_pmc(event->hw.idx, left);
+	val = 0;
+	if (left < 0x80000000L)
+		val = 0x80000000L - left;
+	write_pmc(event->hw.idx, val);
 
 	perf_event_update_userpage(event);
 	perf_pmu_enable(event->pmu);
-- 
1.9.1

