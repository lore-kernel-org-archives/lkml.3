Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaK0XqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:46:15 -0500
Received: from mail-bn1bon0073.outbound.protection.outlook.com ([157.56.111.73]:29195
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751910AbaK0XqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:46:11 -0500
Date: Thu, 27 Nov 2014 15:46:03 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v3] can: Convert to runtime_pm
References: <6b6db31d46074512a322eae6e4ef64d4@BN1BFFO11FD038.protection.gbl>
 <54779501.8060009@pengutronix.de>
 <820358d5369f465188dfa9306eae5658@BL2FFO11FD009.protection.gbl>
 <5477ABF3.1020605@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5477ABF3.1020605@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21136.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <cb000149727543b5a08b9f56d9cc0626@BN1BFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(479174003)(199003)(377454003)(24454002)(51704005)(189002)(164054003)(74316001)(104016003)(6806004)(93886004)(50466002)(46102003)(44976005)(83506001)(20776003)(47776003)(102836001)(92566001)(62966003)(33646002)(85202003)(120916001)(21056001)(87936001)(95666004)(85182001)(23676002)(86362001)(77156002)(99396003)(31966008)(53416004)(4396001)(54356999)(19580395003)(19580405001)(77096003)(64706001)(76176999)(107046002)(108616004)(50986999)(110136001)(106466001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB014;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB014;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB014;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB014;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 11:55PM +0100, Marc Kleine-Budde wrote:
> On 11/27/2014 11:47 PM, Sören Brinkmann wrote:
> > On Thu, 2014-11-27 at 10:17PM +0100, Marc Kleine-Budde wrote:
> >> On 11/27/2014 02:08 PM, Kedareswara rao Appana wrote:
> >>> Instead of enabling/disabling clocks at several locations in the driver,
> >>> use the runtime_pm framework. This consolidates the actions for
> >>> runtime PM in the appropriate callbacks and makes the driver more
> >>> readable and mantainable.
> >>>
> >>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> >>> ---
> >>> Changes for v3:
> >>>   - Converted the driver to use runtime_pm.
> >>> Changes for v2:
> >>>   - Removed the struct platform_device* from suspend/resume
> >>>     as suggest by Lothar.
> >>>
> >>>  drivers/net/can/xilinx_can.c |  119 +++++++++++++++++++++++++----------------
> >>>  1 files changed, 72 insertions(+), 47 deletions(-)
> >>>
> >>> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> >>> index 8a998e3..1be28ed 100644
> >>> --- a/drivers/net/can/xilinx_can.c
> >>> +++ b/drivers/net/can/xilinx_can.c
> > [...]
> >>> @@ -1030,7 +1046,10 @@ static int __maybe_unused xcan_resume(struct device *dev)
> >>>  	return 0;
> >>>  }
> >>>  
> >>> -static SIMPLE_DEV_PM_OPS(xcan_dev_pm_ops, xcan_suspend, xcan_resume);
> >>> +static const struct dev_pm_ops xcan_dev_pm_ops = {
> >>> +	SET_SYSTEM_SLEEP_PM_OPS(xcan_suspend, xcan_resume)
> >>> +	SET_PM_RUNTIME_PM_OPS(xcan_runtime_suspend, xcan_runtime_resume, NULL)
> >>> +};
> >>>  
> >>>  /**
> >>>   * xcan_probe - Platform registration call
> >>> @@ -1071,7 +1090,7 @@ static int xcan_probe(struct platform_device *pdev)
> >>>  		return -ENOMEM;
> >>>  
> >>>  	priv = netdev_priv(ndev);
> >>> -	priv->dev = ndev;
> >>> +	priv->dev = &pdev->dev;
> >>>  	priv->can.bittiming_const = &xcan_bittiming_const;
> >>>  	priv->can.do_set_mode = xcan_do_set_mode;
> >>>  	priv->can.do_get_berr_counter = xcan_get_berr_counter;
> >>> @@ -1137,6 +1156,11 @@ static int xcan_probe(struct platform_device *pdev)
> >>>  
> >>>  	netif_napi_add(ndev, &priv->napi, xcan_rx_poll, rx_max);
> >>>  
> >>> +	pm_runtime_set_active(&pdev->dev);
> >>> +	pm_runtime_irq_safe(&pdev->dev);
> >>
> >> You use just clock_enable()/disable() in the runtime functions, thus you
> >> can say they are irq_safe. On the other the the zync grpio driver uses
> >> "full" prepare_enable/disable_unprepare calls. What's best practice here?
> > 
> > IIRC, the prepare/unprepare functions can sleep. xcan_get_berr_counter
> > is called from atomic context. So, I think we have to use the
> > disable/enable functions without the prepare/unprepare.
> > In the GPIO driver the that problem does not exist.
> 
> IC, yes, correct.
> 
> This is why we introducted in other drivers a __get_berr_counter()
> function, that doesn't touch the clocks, which is used from within the
> driver (from the atomic contects), while get_berr_counter() will fiddle
> with the clocks. This function is used for the
> priv->can.do_get_berr_counter callback.

I have the feeling I'm missing something. If I remove the 'must not
sleep' requirement from the runtime suspend/resume functions, I get
this:

BUG: sleeping function called from invalid context at drivers/base/power/runtime.c:954
in_atomic(): 0, irqs_disabled(): 0, pid: 161, name: ip
INFO: lockdep is turned off.
CPU: 0 PID: 161 Comm: ip Not tainted 3.18.0-rc1-xilinx-00059-g21da26693b61-dirty #104
[<c00186a8>] (unwind_backtrace) from [<c00139f4>] (show_stack+0x20/0x24)
[<c00139f4>] (show_stack) from [<c055a41c>] (dump_stack+0x8c/0xd0)
[<c055a41c>] (dump_stack) from [<c0054808>] (__might_sleep+0x1ac/0x1e4)
[<c0054808>] (__might_sleep) from [<c034f8f0>] (__pm_runtime_resume+0x40/0x9c)
[<c034f8f0>] (__pm_runtime_resume) from [<c03b48d8>] (xcan_get_berr_counter+0x2c/0x9c)
[<c03b48d8>] (xcan_get_berr_counter) from [<c03b2ecc>] (can_fill_info+0x160/0x1f4)
[<c03b2ecc>] (can_fill_info) from [<c049f3b0>] (rtnl_fill_ifinfo+0x794/0x970)
[<c049f3b0>] (rtnl_fill_ifinfo) from [<c04a0048>] (rtnl_dump_ifinfo+0x1b4/0x2fc)
[<c04a0048>] (rtnl_dump_ifinfo) from [<c04af9c8>] (netlink_dump+0xe4/0x270)
[<c04af9c8>] (netlink_dump) from [<c04b0764>] (__netlink_dump_start+0xdc/0x170)
[<c04b0764>] (__netlink_dump_start) from [<c04a1fc4>] (rtnetlink_rcv_msg+0x154/0x1e0)
[<c04a1fc4>] (rtnetlink_rcv_msg) from [<c04b1e88>] (netlink_rcv_skb+0x68/0xc4)
[<c04b1e88>] (netlink_rcv_skb) from [<c04a045c>] (rtnetlink_rcv+0x28/0x34)
[<c04a045c>] (rtnetlink_rcv) from [<c04b1770>] (netlink_unicast+0x144/0x210)
[<c04b1770>] (netlink_unicast) from [<c04b1c9c>] (netlink_sendmsg+0x394/0x414)
[<c04b1c9c>] (netlink_sendmsg) from [<c046ffcc>] (sock_sendmsg+0x8c/0xc0)
[<c046ffcc>] (sock_sendmsg) from [<c04726bc>] (SyS_sendto+0xd8/0x114)
[<c04726bc>] (SyS_sendto) from [<c000f3e0>] (ret_fast_syscall+0x0/0x48)

I.e. the core calls this function from atomic context. And in an earlier
thread you said the core can also call this before/after calling the
open/close callbacks (which applies here too, I think).

I think the callback is required to
 - not sleep
 - get the device in a power state that allows querying its registers

So, I don't see how splitting the xcan_get_berr_counter callback helps
here, especially since it is not even used within the driver.

	Thanks,
	Sören
