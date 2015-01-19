Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbbASSEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:04:20 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:64837
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751677AbbASSET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:04:19 -0500
X-WSS-ID: 0NIFQTK-07-2DA-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <bp@suse.de>, <riel@redhat.com>, <mgorman@suse.de>,
        <jolsa@kernel.org>, <pbonzini@redhat.com>, <jacob.w.shin@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] x86, cpu, amd: Use 8-bit extractor for NodeId field
Date: Mon, 19 Jan 2015 12:18:58 -0600
Message-ID: <1421691538-7152-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(19580405001)(19580395003)(50466002)(46102003)(229853001)(105586002)(53416004)(106466001)(2201001)(48376002)(36756003)(77156002)(87936001)(64706001)(62966003)(47776003)(97736003)(50226001)(92566002)(77096005)(50986999)(68736005)(86362001)(101416001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB203;
X-Forefront-PRVS: 046164D5C4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2015 17:48:58.5259
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NodeId field in cpuid_ecx(0x8000001e) is a 8 bit field.
Although current extractor works fine, it will break if/when
the most significant 5 bits ever get used.

So, lets honor the field as architected in the BKDG

Reference: BKDG for AMD Fam15h Models 00h-0fh,
CPUID Fn8000_001E_ECX Node Identifiers

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a220239..9942b83 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -300,7 +300,7 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
 		nodes = ((ecx >> 8) & 7) + 1;
-		node_id = ecx & 7;
+		node_id = ecx & 0xff;
 
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
-- 
1.9.1

