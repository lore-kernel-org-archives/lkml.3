Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaF3Sjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:39:32 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:36440
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752438AbaF3Sjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:39:31 -0400
Date: Mon, 30 Jun 2014 11:39:19 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: timers & suspend
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(189002)(199002)(70736001)(53416004)(83322001)(4396001)(104016002)(21056001)(64706001)(106466001)(20776003)(77982001)(80022001)(46102001)(47776003)(76482001)(74502001)(44976005)(95666004)(81542001)(102836001)(6806004)(77096002)(81342001)(31696002)(74316001)(99396002)(85852003)(1496007)(87936001)(83506001)(23676002)(85182001)(92566001)(31966008)(74662001)(85306003)(92726001)(33646001)(54356999)(86362001)(79102001)(83072002)(50986999)(229853001)(107046002)(50466002)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB001;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0258E7CCD4
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm currently working on suspend for Zynq and try to track down some
spurious wakes. It looks like the spurious wakes are caused by timers,
hence I was wondering whether there are any special requirements for
timer drivers when it comes to suspend support or if I just missed
something.

Zynq sets the 'IRQCHIP_MASK_ON_SUSPEND' flag, which should mask all
interrupts but the wake source. Reading through kernel/irq/pm.c
indicates, that timer interrupts get some special treatment though.
Therefore I implemented some suspend/resume callbacks for the
cadence_ttc which disable and clear the timer's interrupts when going
into suspend. That seems to mitigate the issue quite a bit, but I still
saw spurious wakes - just a lot less often.
Digging a little deeper revealed, the spurious wakes are caused by the
ARM's smp_twd timer now. Given that that driver is probably used by a few
more ARM platforms, I get the feeling that I'm missing something.

It's probably worth mentioning that the suspend state in Zynq does not
power off the CPU cores. It just asserts the resets on secondary cores
and the primary one waits in wfi.

	Thanks,
	Sören

