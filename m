Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbaGCRkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:40:37 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:46290
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755012AbaGCRkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:40:36 -0400
Date: Thu, 3 Jul 2014 10:40:21 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: timers & suspend
References: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl>
 <53B54AC2.5040908@linaro.org>
 <83fa689b-a06a-4f1c-97cb-f7a7121a0f25@BL2FFO11FD041.protection.gbl>
 <53B5922A.7020006@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B5922A.7020006@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <12596549-d0f6-43b6-810d-ccd908404364@BL2FFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(24454002)(377454003)(479174003)(51704005)(377424004)(1496007)(70736001)(74316001)(80022001)(47776003)(85852003)(74502001)(50466002)(87936001)(92566001)(85202003)(92726001)(20776003)(81342001)(21056001)(86362001)(83322001)(81542001)(74662001)(83072002)(104016002)(95666004)(64706001)(50986999)(85182001)(76176999)(44976005)(31966008)(102836001)(54356999)(99396002)(93886003)(85306003)(53416004)(77096002)(83506001)(77982001)(33646001)(6806004)(76482001)(23676002)(107046002)(79102001)(46102001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB036;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0261CCEEDF
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 07:26PM +0200, Daniel Lezcano wrote:
> On 07/03/2014 06:09 PM, Sören Brinkmann wrote:
> >On Thu, 2014-07-03 at 02:21PM +0200, Daniel Lezcano wrote:
> >>On 06/30/2014 08:39 PM, Sören Brinkmann wrote:
> >>>Hi,
> >>>
> >>>I'm currently working on suspend for Zynq and try to track down some
> >>>spurious wakes. It looks like the spurious wakes are caused by timers,
> >>>hence I was wondering whether there are any special requirements for
> >>>timer drivers when it comes to suspend support or if I just missed
> >>>something.
> >>>
> >>>Zynq sets the 'IRQCHIP_MASK_ON_SUSPEND' flag, which should mask all
> >>>interrupts but the wake source. Reading through kernel/irq/pm.c
> >>>indicates, that timer interrupts get some special treatment though.
> >>>Therefore I implemented some suspend/resume callbacks for the
> >>>cadence_ttc which disable and clear the timer's interrupts when going
> >>>into suspend. That seems to mitigate the issue quite a bit, but I still
> >>>saw spurious wakes - just a lot less often.
> >>>Digging a little deeper revealed, the spurious wakes are caused by the
> >>>ARM's smp_twd timer now. Given that that driver is probably used by a few
> >>>more ARM platforms, I get the feeling that I'm missing something.
> >>
> >>Do you receive any interrupt from the cadence_ttc ? (/proc/interrupts)
> >>
> >>That's funny because I realize that you cadence ttc timer is never
> >>used as there are the architected timers. The cadence ttc would be
> >>only useful if there were an idle state powering down the smp_twd
> >>timers but it is not the case on this board, IIUC.
> >Yes they are used. They TTC is the only broadcast capable timer for
> >Zynq. In my experience, I can not even boot without it (may have
> >dependencies on CPUidle or something).
> 
> Actually the cpuidle driver is wrong. It assumes the state #1 will
> power off the different cores with their architected timers and then
> switch to the broadcast timer. But this one is not needed as we
> don't power down the core with the twd timers, so no need to switch
> to a backup timer device.
> 
> The implementation of the DDR self refresh idle state (incoming
> patchset) removes the cpu_pm notifiers + the flag TIMER_STOP. The
> result is 0 interrupts for ttc cadence timer. I removed in the dts
> the cadence ttc and my board booted without problem (it is a zynq
> 702).
> 
> Except I missed something, the cadence ttc is actually not used at all.
I tested on the current master branch. I see TTC interrupts on CPU0 and
timer_list shows the TTC to be the broadcast device. Removing the TTC
nodes from my DT results in boot hanging - shortly after cpuidle is
started.

Removing cpuidle from my kernel makes the system boot. And it has no
broadcast device anymore.

	Sören
