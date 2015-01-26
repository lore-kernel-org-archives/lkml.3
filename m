Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbbAZDWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 22:22:18 -0500
Received: from mail-bn1on0085.outbound.protection.outlook.com ([157.56.110.85]:23661
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbbAZDWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 22:22:15 -0500
Date: Sun, 25 Jan 2015 19:22:04 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: zynq: Force CPU_2X clock to be ungated
References: <1422056653-11271-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422056653-11271-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21284.004
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <3b7e448a3a9c4d8a8f566ef01160ba89@BY2FFO11FD041.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; lists.infradead.org; dkim=none
 (message not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377424004)(24454002)(86362001)(19580395003)(50986999)(575784001)(87936001)(76176999)(74316001)(6806004)(85182001)(19580405001)(50466002)(108616004)(2950100001)(53416004)(92726002)(77156002)(23676002)(46102003)(54356999)(92566002)(62966003)(47776003)(106466001)(85202003)(104016003)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB017;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB017;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 03:22:13.3208
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-23 at 03:44PM -0800, Soren Brinkmann wrote:
> The CPU_2X clock does not have a classical in kernel user, but is,
> amongst other things, required for OCM and debug access. Make sure this
> clock does not mistakenly disabled during boot up by enabling it in the
> platforms clock driver.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> I just noticed this on Linus' latest tip. I can't remember having had issues
> connecting the debugger before, but it might be a candidate for stable in case
> people report something like that.

I bisected this down to commit:

ae43b3289186480f81c78bb63d788a85a3631f47 is the first bad commit
commit ae43b3289186480f81c78bb63d788a85a3631f47
Author: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Date:   Fri Nov 14 09:48:57 2014 +0100

    ARM: 8202/1: dmaengine: pl330: Add runtime Power Management support v12
    
    This patch adds runtime PM support to pl330 DMA engine driver.
    
    The runtime power management for pl330 DMA driver allows gating of AMBA
    clock (PDMA) in FSYS clock domain, when the device is not processing any
    requests. This is necessary to enter low power modes on Exynos SoCs
    (e.g. LPA on Exynos4x12 or W-AFTR on Exynos3250).
    
    Runtime PM resuming of the device may happen in atomic context (during
    call device_issue_pending()) so pm_runtime_irq_safe() is used. This will
    lead only to disabling/enabling of the clock but this is sufficient for
    gating the clock and for reducing energy usage.
    
    Driver uses runtime PM callbacks from amba/bus.c driver only.
    
    Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
    Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

:040000 040000 16e0cb02587254ea396e9d913d7997ac63bd3d49 97c1ee366f0790e65df00e85d06b2bcd07aa9f58 M      drivers

which makes sense, since the PL330 clock in Zynq is the mentioned
CPU_2X_CLK. I guess the additional runtime_pm in the driver causes the
clock to be gated which causes the issues for the mentioned other users
of this clock.
Looks like this patch got introduced in the 3.19 merge window. Hence,
stable should be off the table.

	Sören
