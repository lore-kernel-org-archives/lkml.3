Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3CaMFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 08:05:45 -0400
Received: from smtp-out.abv.bg ([194.153.145.99]:33668 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab3CaMFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 08:05:43 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=TRdqtoCXL1IK13R+uODdCiuAWxLEbLEWRnszbFHEjbGkPPMMGwxDMSouwPdmGQbjW
	mRqdA5JsOxrP3e/qSJnc25F3jemBT4vjoNA6F+odEO/S9JYlPJHKVuXtc7BbFrX/sNP
	SVV1vplcpuXSuWY7abd3UPj0pFNOVls6RVLhUNk=
Date: Sun, 31 Mar 2013 15:05:42 +0300 (EEST)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: tony@atomide.com, juha.yrjola@solidboot.com, linux@arm.linux.org.uk,
        mpm@selenic.com, herbert@gondor.hengli.com.au,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <2059303614.30062.1364731542427.JavaMail.apache@mail83.abv.bg>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Pali,

Yep, the code looks almost identical, I guess with some tweaks all SMC code from that patch could be removed and instead used the one from SMC PPA API. 

What I don't get, is why one needs to disable/enable fiqs/irqs:

+static int call_sec_rom(u32 appl_id, u32 proc_id, u32 flag, ...)
+{
+	va_list ap;
+	u32 ret;
+	u32 val;
+
+	va_start(ap, flag);
+	val = *(u32 *) &ap;
+	local_irq_disable();
+	local_fiq_disable();
+	ret = omap3_rom_rng_call(appl_id, proc_id, flag,
+				 (u32) virt_to_phys((void *) val));
+	local_fiq_enable();
+	local_irq_enable();
+	va_end(ap);
+
+	return ret;
+}

Do you have any idea why is that needed? Any other code I've ever seen to call SM, does not disable fiqs/irqs, is RNG SMC somehow special? I know this is Nokia's code, but still, if we can get some understanding...

Regards,
Ivo

 >-------- Оригинално писмо --------
 >От:  Pali Rohár 
 >Относно: Re: [PATCH] OMAP3 ROM Random Number Generator support
 >До: Tony Lindgren 
 >Изпратено на: Неделя, 2013, Март 31 12:28:12 EEST
 >
 >
 >On Thursday 28 March 2013 22:44:11 Tony Lindgren wrote:
 >> * Pali Rohár  [130328 10:58]:
 >> > Here is new version of patch:
 >> > 
 >> > --- a/arch/arm/mach-omap2/devices.c
 >> > +++ b/arch/arm/mach-omap2/devices.c
 >> > @@ -486,6 +486,23 @@ static void omap_init_mcspi(void)
 >> > 
 >> >  static inline void omap_init_mcspi(void) {}
 >> >  #endif
 >> > 
 >> > +extern u32 *omap3_rom_rng_call(u32 id, u32 proc, u32 flags,
 >> > u32 va_ptr); +
 >> > +static struct platform_device omap3_rom_rng_device = {
 >> > +	.name		= &quot;omap3-rom-rng&quot;,
 >> > +	.id		= -1,
 >> > +	.dev	= {
 >> > +		.platform_data	= omap3_rom_rng_call,
 >> > +	},
 >> > +};
 >> > +
 >> > +static void omap_init_rom_rng(void)
 >> > +{
 >> > +	if (!cpu_is_omap34xx() || omap_type() ==
 >> > OMAP2_DEVICE_TYPE_GP) +		return;
 >> > +	platform_device_register(&amp;omap3_rom_rng_device);
 >> > +}
 >> > +
 >> > 
 >> >  /**
 >> >  
 >> >   * omap_init_rng - bind the RNG hwmod to the RNG
 >> >   omap_device *
 >> 
 >> This driver probably only works on Nokia boards because of the
 >> different SMC call numbering. Until it's been verified on some
 >> other HS omap34xx, I'd probably register this only from the
 >> Nokia board-*.c file.
 >> 
 >
 >Freemangordon, can you look at this smc and errara 430973 code if 
 >they could be merged? Really omap3_rom_rng_call function looks 
 >like n900 specific.
 >
 >Link: https://lkml.org/lkml/2013/3/28/398
 >
 >> > --- /dev/null
 >> > +++ b/drivers/char/hw_random/omap3-rom-rng.c
 >> > +static int omap3_rom_rng_probe(struct platform_device
 >> > *pdev) +{
 >> > +	printk(KERN_INFO &quot;%s: initializing&#92;n&quot;,
 >> > omap3_rom_rng_name); +
 >> > +	omap3_rom_rng_call = pdev->dev.platform_data;
 >> > +	if (!omap3_rom_rng_call) {
 >> > +		printk(KERN_ERR &quot;%s: omap3_rom_rng_call is NULL&#92;n&quot;,
 >> > +		       omap3_rom_rng_name);
 >> > +		return -EINVAL;
 >> > +	}
 >> > +
 >> > +	setup_timer(&amp;idle_timer, omap3_rom_idle_rng, 0);
 >> > +	rng_clk = clk_get_sys(&quot;omap_rng&quot;, &quot;ick&quot;);
 >> > +	if (IS_ERR(rng_clk)) {
 >> > +		printk(KERN_ERR &quot;%s: unable to get RNG clock&#92;n&quot;,
 >> > +		       omap3_rom_rng_name);
 >> > +		return IS_ERR(rng_clk);
 >> > +	}
 >> 
 >> You can use regular clk_get if you add the alias to
 >> struct omap_clk omap3xxx_clks table.
 >> 
 >> Regards,
 >> 
 >> Tony
 >
 >Tony, can you show me how?
 >
 >-- 
 >Pali Rohár
 >pali.rohar@gmail.com
 >
