Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3BSIBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:01:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36758 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab3BSIBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:01:16 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Rob Herring <robherring2@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        "Nori, Sekhar" <nsekhar@ti.com>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: RE: [RFC 2/8] ARM: twd: register clock event for 1 core SMP
Thread-Topic: [RFC 2/8] ARM: twd: register clock event for 1 core SMP
Thread-Index: AQHODaHTgGJd/bPs20OR7GBLiFPJQJh/RYWAgAF6A2A=
Date: Tue, 19 Feb 2013 08:00:07 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA8534@DBDE01.ent.ti.com>
References: <cover.1361166003.git.afzal@ti.com>
 <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361166003.git.afzal@ti.com>
 <512230F1.8020208@gmail.com>
In-Reply-To: <512230F1.8020208@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1J81LH4028151

Hi Rob,

On Mon, Feb 18, 2013 at 19:17:29, Rob Herring wrote:
> On 02/18/2013 12:30 AM, Afzal Mohammed wrote:

> > Register percpu local timer for scheduler tick in the case of one core
> > SMP configuration. In other cases - secondary cpu's as well as boot
> > cpu's having more than one core, this is being registered as per
> > existing boot flow, with a difference that they happens after delay
> > calibration. Registering the clock for tick in case of one core should
> > be done before Kernel calibrates delay (this is required to boot,
> > unless local timer is the only one registered for tick). Registering
> > twd local timer at init_time (which platforms are doing now) helps
> > achieve that with the proposed change.
> > 
> > This helps in an almost booting Kernel (minimal) by only relying on
> > ARM parts for an A9 one core SMP.

> >  arch/arm/kernel/smp_twd.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
> > index 616268c..118f4f2 100644
> > --- a/arch/arm/kernel/smp_twd.c
> > +++ b/arch/arm/kernel/smp_twd.c
> > @@ -335,6 +335,9 @@ static int __init twd_local_timer_common_register(struct device_node *np)
> >  
> >  	twd_get_clock(np);
> >  
> > +	if (num_possible_cpus() == 1)
> > +		twd_timer_setup(evt);
> > +

> Shouldn't this be fixed in the core code, so the same issue is fixed for
> all timers?

Is the following that you had in mind ? (with it, this patch as well as
1/8 would not be required),

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index d3a22be..2b6417d 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -42,6 +42,8 @@ void handle_IPI(int ipinr, struct pt_regs *regs);
  */
 extern void smp_init_cpus(void);
 
+extern void smp_monocore_timer_setup(void);
+
 
 /*
  * Provide a function to raise an IPI cross call on CPUs in callmap.
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 5f73f70..7431b77 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -504,6 +504,15 @@ int local_timer_register(struct local_timer_ops *ops)
 }
 #endif
 
+void __init smp_monocore_timer_setup(void)
+{
+       unsigned int cpu = smp_processor_id();
+       struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
+
+       if (!lt_ops)
+               lt_ops->setup(evt);
+}
+
 static void __cpuinit percpu_timer_setup(void)
 {
        unsigned int cpu = smp_processor_id();
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 955d92d..eb023ee 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -116,5 +116,6 @@ int __init register_persistent_clock(clock_access_fn read_boot,
 void __init time_init(void)
 {
        machine_desc->init_time();
+       smp_monocore_timer_setup();
        sched_clock_postinit();
 }

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
