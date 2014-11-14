Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161241AbaKNPUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:20:36 -0500
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:8881
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965562AbaKNPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:20:33 -0500
Date: Fri, 14 Nov 2014 07:20:23 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v2] can: Fix bug in suspend/resume
References: <e7070431858e49e29cd03d76fd7a66c3@BN1AFFO11FD055.protection.gbl>
 <5465C34D.4030805@pengutronix.de>
 <e5f5913b51a54222aa1bb0680a77e56d@BN1AFFO11FD055.protection.gbl>
 <54661B2F.2000704@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54661B2F.2000704@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21104.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <8d29d376aa02429dabd754b505fb336d@BN1BFFO11FD041.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(377454003)(189002)(377424004)(24454002)(51704005)(85182001)(93886004)(23676002)(19580395003)(86362001)(44976005)(87936001)(19580405001)(83506001)(6806004)(108616004)(76176999)(92566001)(54356999)(21056001)(50986999)(46102003)(62966003)(77156002)(120916001)(85202003)(95666004)(104016003)(107046002)(20776003)(99396003)(110136001)(64706001)(31966008)(4396001)(74316001)(50466002)(102836001)(53416004)(106466001)(77096003)(47776003)(33646002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB033;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB033;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB033;
X-Forefront-PRVS: 03950F25EC
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB033;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 04:09PM +0100, Marc Kleine-Budde wrote:
> On 11/14/2014 04:05 PM, Sören Brinkmann wrote:
> > On Fri, 2014-11-14 at 09:54AM +0100, Marc Kleine-Budde wrote:
> >> On 11/14/2014 09:16 AM, Kedareswara rao Appana wrote:
> >>> The drvdata in the suspend/resume is of type struct net_device,
> >>> not the platform device.Enable the clocks in the suspend before
> >>> accessing the registers of the CAN.
> >>>
> >>> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> >>> ---
> >>> Changes for v2:
> >>>   - Removed the struct platform_device* from suspend/resume
> >>>     as suggest by Lothar.
> >>>   - The clocks are getting disabled and un prepared at the end of the probe. 
> >>>     In the suspend the driver is doing a register write.In order
> >>>     To do that register write we have to again enable and prepare the clocks.
> >>
> >> Please look the at suspend/resume code and count the
> >> clock_enable/disable manually. After a suspend/resume cycle, you have
> >> enabled the clock twice, but disabled it once.
> >>
> >> I think you have to abstract the clock handling behind runtime PM. I
> >> haven't done this myself yet, but the strong feeling that this is a
> >> possible solution to your problem. These links might help:
> > 
> > I agree, the clock handling looks weird. Also the clk_disable calls in
> > xcan_get_berr_counter() look suspicious to me, but I might be wrong.
> > I think you can take a look at gpio-zynq for an example for runtime_pm
> > usage. I think the usage model in that driver is similar to here.
> 
> The xcan_get_berr_counter() function is correct, when doing manual (i.e.
> non runtime-pm) clock handling. This function might be called if the
> interface is down, this means clocks are disabled.

I see, thanks for the clarification. Guess that should become
pm_runtime_get_sync() and pm_runtime_put() when converting to
runtime_pm.

	Sören
