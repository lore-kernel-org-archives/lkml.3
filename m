Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaLVT5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:57:00 -0500
Received: from mail-bn1bon0112.outbound.protection.outlook.com ([157.56.111.112]:47470
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754598AbaLVT46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:56:58 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 14:56:57 EST
X-WSS-ID: 0NH01F1-08-5I7-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <bp@alien8.de>, <dougthompson@xmission.com>,
        <mchehab@osg.samsung.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>
CC: <dave.hansen@linux.intel.com>, <mgorman@suse.de>, <bp@suse.de>,
        <riel@redhat.com>, <jacob.w.shin@gmail.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 0/3] Fix MCE handling for AMD multi-node processors
Date: Mon, 22 Dec 2014 14:10:09 -0600
Message-ID: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(64706001)(53416004)(20776003)(47776003)(101416001)(21056001)(87936001)(97736003)(31966008)(84676001)(2201001)(99396003)(50226001)(50986999)(120916001)(46102003)(89996001)(4396001)(106466001)(92566001)(229853001)(107046002)(86362001)(36756003)(105586002)(50466002)(77096005)(62966003)(48376002)(68736005)(77156002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 19:42:44.2104
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a MCE happens that is to be logged onto bank 4 of AMD multi-node
processors, they are reported only to corresponding node base core of
the cpu on which the error occurred.

Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
clarifications on the reporting of MC4 errors only to NBC MSRs.

We don't have the exception handler wired up to handle this currently.
As a consequence, do_machine_check only runs on the core on which error
occurred and (since according to the BKDGs, reads to MC4_STATUS MSR of
non-NBC will simply RAZ) the exception is ignored for the core.

This is a problem as now we have dropped MCEs.
I tested this on Fam10h and Fam15h using mce_amd_inj and by triggering
a real HW MCE using Boris' new interface; And can confirm the behavior.

This patch set fixes the issue by looking at the NBC MSRs when bank 4
errors happen on AMD multi node processors.

Patch 1: Refactor AMD cpu topology functions so that we can get some
	 relevant info that we need to use in EDAC, MC handler routines
Patch 2: The fix to our problem
Patch 3: Modify mce_amd_inj interfaces to write to only NBC for bank 4
	 errors. Only then will they be picked up for error handling.

Aravind Gopalakrishnan (3):
  x86,amd: Refactor amd cpu topology functions for multi-node processors
  x86, mce: Handle AMD MCE on bank4 on NBC for multi-node processors
  edac, mce_amd_inj: Inject errors only on NBC for bank 4 errors

 arch/x86/include/asm/processor.h |   1 +
 arch/x86/kernel/cpu/amd.c        |  78 ++++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce.c | 167 +++++++++++++++++++++++++++++++++++----
 drivers/edac/mce_amd_inj.c       |  21 ++++-
 4 files changed, 235 insertions(+), 32 deletions(-)

-- 
2.0.2

