Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaGHXu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:50:59 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:35998
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbaGHXu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:50:58 -0400
Date: Tue, 8 Jul 2014 16:50:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: timers & suspend
References: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2489e9cb-51c2-4901-9ab5-c952877d8a9d@BL2FFO11FD057.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(51704005)(377424004)(199002)(189002)(104016002)(107046002)(85306003)(33646001)(77982001)(47776003)(20776003)(46102001)(106466001)(50466002)(64706001)(74316001)(83506001)(87936001)(50986999)(79102001)(85202003)(86362001)(31966008)(81342001)(102836001)(74502001)(85182001)(74662001)(76176999)(81542001)(54356999)(44976005)(83322001)(80022001)(21056001)(6806004)(70736001)(99396002)(92726001)(85852003)(77096002)(76482001)(53416004)(95666004)(4396001)(31696002)(92566001)(1496007)(23676002)(83072002)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB049;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me extend the audience a bit.

On Mon, 2014-06-30 at 11:39AM -0700, Sören Brinkmann wrote:
> Hi,
> 
> I'm currently working on suspend for Zynq and try to track down some
> spurious wakes. It looks like the spurious wakes are caused by timers,
> hence I was wondering whether there are any special requirements for
> timer drivers when it comes to suspend support or if I just missed
> something.
> 
> Zynq sets the 'IRQCHIP_MASK_ON_SUSPEND' flag, which should mask all
> interrupts but the wake source. Reading through kernel/irq/pm.c
> indicates, that timer interrupts get some special treatment though.
> Therefore I implemented some suspend/resume callbacks for the
> cadence_ttc which disable and clear the timer's interrupts when going
> into suspend. That seems to mitigate the issue quite a bit, but I still
> saw spurious wakes - just a lot less often.
> Digging a little deeper revealed, the spurious wakes are caused by the
> ARM's smp_twd timer now. Given that that driver is probably used by a few
> more ARM platforms, I get the feeling that I'm missing something.
> 
> It's probably worth mentioning that the suspend state in Zynq does not
> power off the CPU cores. It just asserts the resets on secondary cores
> and the primary one waits in wfi.

I think I found the issue. When going into suspend, all device
interrupts get disabled, but timers are kept running until very late.
Then in kernel/power/suspend.c:
 - arch_suspend_disable_irqs() disables interrupts (locally)
 - syscore_suspend is called, which disables timers through
   tick_suspend()

I think what happens is: The interrupts get disabled locally, but the
timers are still running and generating interrupts.
Such an interrupt happens and stays pending since interrupts are already
disabled and no longer handled.
Then, since Zynq does not power off but only goes into wfi, it
immediately resumes due to a pending timer IRQ.

Especially with the TTC this can happen quite often since it is only
16 bit wide. But I also see spurious wakes caused by the twd.

Does that sound like a possible scenario?

	Sören
