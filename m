Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaLAJMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:12:09 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:62827
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752671AbaLAJMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:12:02 -0500
From: "Zhuoyu.Zhang@freescale.com" <Zhuoyu.Zhang@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "chenhui.zhao@freescale.com" <chenhui.zhao@freescale.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: RE: [PATCH v2 1/2] arm: ls1: add CPU hotplug platform support
Thread-Topic: [PATCH v2 1/2] arm: ls1: add CPU hotplug platform support
Thread-Index: AQHQB6egCSA+D8+6nk621VAjg987gJx13hIAgASWf/A=
Date: Mon, 1 Dec 2014 08:40:05 +0000
Message-ID: <CY1PR0301MB0668558136F0EAF9A2D2A717897D0@CY1PR0301MB0668.namprd03.prod.outlook.com>
References: <1416806890-26920-1-git-send-email-Zhuoyu.Zhang@freescale.com>
 <20141128103304.GA25883@leverpostej>
In-Reply-To: <20141128103304.GA25883@leverpostej>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0729;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0729;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(199003)(377454003)(24454002)(13464003)(95666004)(120916001)(99396003)(19580395003)(19580405001)(97736003)(99286002)(40100003)(77096004)(106116001)(33656002)(106356001)(87936001)(110136001)(105586002)(101416001)(107046002)(86362001)(2656002)(46102003)(92566001)(92726001)(4396001)(31966008)(76176999)(54356999)(50986999)(21056001)(54206007)(77156002)(62966003)(74316001)(20776003)(76576001)(54606007)(64706001)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0729;H:CY1PR0301MB0668.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0602;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Mark Rutland [mailto:mark.rutland@arm.com]
> Sent: Friday, November 28, 2014 6:33 PM
> To: Zhang Zhuoyu-B46552
> Cc: linux-kernel@vger.kernel.org; kernel@pengutronix.de; linux-arm-
> kernel@lists.infradead.org; Li Yang-Leo-R58472; linuxppc-
> release@linux.freescale.net; Jin Zhengxiong-R64188; Zhao Chenhui-B35336;
> linux@arm.linux.org.uk
> Subject: Re: [PATCH v2 1/2] arm: ls1: add CPU hotplug platform support
> 
> On Mon, Nov 24, 2014 at 05:28:09AM +0000, Zhuoyu Zhang wrote:
> > From: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>
> >
> > This implements CPU hotplug for ls1. When cpu is down, it will be put
> > in WFI state. When cpu is up, it will always soft reset and boots up
> > the same path as a cold boot.
> >
> > Signed-off-by: Zhang Zhuoyu <Zhuoyu.Zhang@freescale.com>
> > ---
> >  arch/arm/mach-imx/common.h  |   4 ++
> >  arch/arm/mach-imx/hotplug.c |  25 +++++++++
> > arch/arm/mach-imx/platsmp.c | 132
> +++++++++++++++++++++++++++++++++++++++-----
> >  arch/arm/mach-imx/src.c     |  21 +++++++
> >  4 files changed, 169 insertions(+), 13 deletions(-)
> >
> 
> [...]
> 
> > +
> > +/*
> > + * For LS102x platforms, shutdowning a CPU is not supported by hardware.
> > + * So we just put the offline CPU into lower-power state here.
> > + */
> > +void __ref ls1021a_cpu_die(unsigned int cpu) {
> > +       v7_exit_coherency_flush(louis);
> > +
> > +       /* LS1021a platform can't really power down a CPU, so we
> > +        * just put it into WFI state here.
> > +        */
> > +       wfi();
> > +}
> > +
> > +int ls1021a_cpu_kill(unsigned int cpu) {
> > +       unsigned long timeout = jiffies + msecs_to_jiffies(50);
> > +
> > +       while (!ls1_get_cpu_arg(cpu))
> > +               if (time_after(jiffies, timeout))
> > +                       return 0;
> > +       return 1;
> > +}
> 
> While simpler than the last posting [1], this is still no better, and Russell's
> comments [2] still apply, so this is still unacceptable.
> 
> If the CPU does not leave the kernel entirely, it is not CPU hotplug.
> As this stands, this is completely incompatible with kexec and suspend.
> 

There are some hardware limitations for ls1 platform, core cannot power down, so the only thing we can do here is to put it into low-power state when CPU offline. 

For suspend compatibility, I quote Leo's comments in last posting, "I don't think it breaks the system suspend case as tasks and interrupts have been moved out of the non-booting CPU." 

For kexec compatibility, it means we should always reset core and boots up the same path as a cold boot when CPU re-online. That's exactly what we are doing in ls1021a_reset_secondary(). I will explain it in detail below.

> [...]
> 
> > +static int ls1021a_reset_secondary(unsigned int cpu) {
> > +       u32 tmp;
> > +
> > +       if (!scfg_base || !dcfg_base)
> > +               return -ENOMEM;
> > +
> > +       writel_relaxed(secondary_pre_boot_entry,
> > +                       dcfg_base + DCFG_CCSR_SCRATCHRW1);
> > +
> > +       /* Apply LS1021A specific to write to the BE SCFG space */
> > +       tmp = ioread32be(scfg_base + SCFG_REVCR);
> > +       iowrite32be(0xffffffff, scfg_base + SCFG_REVCR);
> > +
> > +       /* Soft reset secondary core */
> > +       iowrite32be(0x80000000, scfg_base + SCFG_CORESRENCR);
> > +       iowrite32be(0x80000000, scfg_base +
> > +                               SCFG_CORE0_SFT_RST + STRIDE_4B * cpu);
> > +
> > +       /* Release secondary core */
> > +       iowrite32be(1 << cpu, dcfg_base + DCFG_CCSR_BRR);
> > +
> > +       ls1021a_set_secondary_entry();
> > +
> > +       /* Disable core soft reset register */
> > +       iowrite32be(0x0, scfg_base + SCFG_CORESRENCR);
> > +
> > +       /* Revert back to the default */
> > +       iowrite32be(tmp, scfg_base + SCFG_REVCR);
> > +
> > +       return 0;
> > +}
> > +
> > +static int ls1021a_boot_secondary(unsigned int cpu, struct
> > +task_struct *idle) {
> > +       int ret = 0;
> > +
> > +       if (system_state == SYSTEM_RUNNING)
> > +               ret = ls1021a_reset_secondary(cpu);
> > +
> > +       udelay(1);
> > +
> > +       arch_send_wakeup_ipi_mask(cpumask_of(cpu));
> > +
> > +       return ret;
> > +}
> 
> How does this interact with the pseudo-hotplug above?
> 
> Mark.

When CPU come online, secondary core reset and boots up the same path as a cold boot:

1) Write 1 to core soft reset register SCFG_CORE1_SFT_RST will reset the secondary core. 
Resetting means a totally new start to secondary core, it will re-initialization(TLB, Caches, MMU) just like a cold boot.

2) The reentry address of secondary core is determined by the  DCFG_CCSR_SCRATCHRW1 register.
Writing the secondary core reentry physic address to this register to make sure secondary core restart executing a new code section after reset. This can make sure it is compatible with kexec.

3) Set the corresponding bit of DCFG_CCSR_BRR to release secondary core to re-initialize itself again. 

Zhuoyu
