Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbbAWRx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:53:57 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:37888
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbbAWRxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:53:52 -0500
X-WSS-ID: 0NIN5PM-07-PEP-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH] perf/x86/amd/ibs: Convert force_ibs_eilvt_setup to void
Date: Fri, 23 Jan 2015 12:19:35 -0600
Message-ID: <1422037175-20957-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; chello.nl; dkim=none (message
 not signed) header.d=none;chello.nl; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(2201001)(92566002)(229853001)(47776003)(101416001)(33646002)(77096005)(46102003)(53416004)(50466002)(105586002)(50226001)(19580395003)(62966003)(77156002)(19580405001)(86362001)(50986999)(48376002)(87936001)(106466001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR02MB198;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 17:53:49.0824
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller of force_ibs_eilvt_setup() is ibs_eilvt_setup()
which does not care about the return values.

So, marking it void and cleaning up the return statements.

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index a61f5c6..989d3c2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -796,7 +796,7 @@ static int setup_ibs_ctl(int ibs_eilvt_off)
  * the IBS interrupt vector is handled by perf_ibs_cpu_notifier that
  * is using the new offset.
  */
-static int force_ibs_eilvt_setup(void)
+static void force_ibs_eilvt_setup(void)
 {
 	int offset;
 	int ret;
@@ -811,26 +811,24 @@ static int force_ibs_eilvt_setup(void)
 
 	if (offset == APIC_EILVT_NR_MAX) {
 		printk(KERN_DEBUG "No EILVT entry available\n");
-		return -EBUSY;
+		return;
 	}
 
 	ret = setup_ibs_ctl(offset);
 	if (ret)
 		goto out;
 
-	if (!ibs_eilvt_valid()) {
-		ret = -EFAULT;
+	if (!ibs_eilvt_valid())
 		goto out;
-	}
 
 	pr_info("IBS: LVT offset %d assigned\n", offset);
 
-	return 0;
+	return;
 out:
 	preempt_disable();
 	put_eilvt(offset);
 	preempt_enable();
-	return ret;
+	return;
 }
 
 static void ibs_eilvt_setup(void)
-- 
2.1.0

