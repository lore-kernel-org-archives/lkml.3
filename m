Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3CAHxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:53:52 -0500
Received: from smtp-out.abv.bg ([194.153.145.99]:50162 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab3CAHxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:53:50 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 02:53:50 EST
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=LRhIMhaqPdU8AHTWxB8TsMmVYGcZ0RIJb38D+nFjq+/njIaJM1a6CCg849hNgREgY
	y7eOM73PKTMzn/QVH+j/809EpFuiSCPcUYpc5JvfLNaXTGiLUjzc6sZJg/CXG2AZ5Eg
	SECWvrvWnXLyQ7Jup4SKEnY3GUXls/7+BJbN5OQ=
Date: Fri, 1 Mar 2013 09:47:03 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Nishanth Menon <nm@ti.com>
Cc: pali.rohar@gmail.com, tony@atomide.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <517283541.62064.1362124023621.JavaMail.apache@mail81.abv.bg>
Subject: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 130.204.50.168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   
They look similar, but they are not equivalent :). The first major difference is here (code taken from omap-smc.S)

> ENTRY(omap_smc2)
>          stmfd   sp!, {r4-r12, lr}
>          mov     r3, r2
>          mov     r2, r1
>          mov     r1, #0x0        @ Process ID
>          mov     r6, #0xff
>          mov     r12, #0x00      @ Secure Service ID

Always zero, while RX51 PPA expects a real value. I wonder if it is a bug, but anyway I don't see the id parameter (R0) used.

>          mov     r7, #0
>          mcr     p15, 0, r7, c7, c5, 6

According to ARM TRM, this is "Invalidate entire branch predictor array"(IIUC). NFC why it is needed here, but this will not work on RX-51 until IBE bit in ACR is set. 

>          dsb
>          dmb
>          smc     #0

RX-51 needs smc #1 ;)

>          ldmfd   sp!, {r4-r12, pc}


The next major difference is that RX-51 expects parameter count passed in R3[0] to be the count of the remaining parameters +1, but omap_secure_dispatcher (in omap-secure.c) is passing the exact count of the remaining parameters.

I guess all of the above problems can be fixed/workarounded, but I wonder does it worth. Not to say that I don't have BB around to test if the code still works if I make changes to omap2-secure.c/omap-smc.S :)


 >-------- Оригинално писмо --------
 >От:  Nishanth Menon 
 >Относно: Re: [PATCH] arm: omap: RX-51: ARM errata 430973 workaround
 >До: Pali Rohár 
 >Изпратено на: Четвъртък, 2013, Февруари 28 16:40:05 EET
 >
 >
 >On 10:42-20130228, Pali Rohár wrote:
 >> Signed-off-by: Ivaylo Dimitrov 
 >> Signed-off-by: Pali Rohár 
 >> ---
 >>  arch/arm/mach-omap2/Makefile            |    1 +
 >>  arch/arm/mach-omap2/board-rx51-secure.c |   66 +++++++++++++++++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51-secure.h |   36 +++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51-smc.S    |   34 ++++++++++++++++
 >>  arch/arm/mach-omap2/board-rx51.c        |    7 ++++
 >
 >Wondering if we can integrate these into 
 >arch/arm/mach-omap2/omap-smc.S
 >and
 >arch/arm/mach-omap2/omap-secure.c
 >on a quick look, it does seem there are commonalities.
 >
 >>  5 files changed, 144 insertions(+)
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.c
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-secure.h
 >>  create mode 100644 arch/arm/mach-omap2/board-rx51-smc.S
 >> 
 >> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
 >> index 0ebbdd50..8eb4fb4 100644
 >> --- a/arch/arm/mach-omap2/Makefile
 >> +++ b/arch/arm/mach-omap2/Makefile
 >> @@ -241,6 +241,7 @@ obj-&#36;(CONFIG_MACH_NOKIA_RX51)		+= board-rx51.o sdram-nokia.o
 >>  obj-&#36;(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-peripherals.o
 >>  obj-&#36;(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-video.o
 >>  obj-&#36;(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-camera.o
 >> +obj-&#36;(CONFIG_MACH_NOKIA_RX51)		+= board-rx51-smc.o board-rx51-secure.o
 >>  obj-&#36;(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom.o board-zoom-peripherals.o
 >>  obj-&#36;(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom-display.o
 >>  obj-&#36;(CONFIG_MACH_OMAP_ZOOM2)		+= board-zoom-debugboard.o
 >> diff --git a/arch/arm/mach-omap2/board-rx51-secure.c b/arch/arm/mach-omap2/board-rx51-secure.c
 >> new file mode 100644
 >> index 0000000..361dc78
 >> --- /dev/null
 >> +++ b/arch/arm/mach-omap2/board-rx51-secure.c
 >> @@ -0,0 +1,66 @@
 >> +/*
 >> + * RX51 Secure PPA API.
 >> + *
 >> + * Copyright (C) 2012 Ivaylo Dimitrov 
 >> + *
 >> + *
 >> + * This program is free software,you can redistribute it and/or modify
 >> + * it under the terms of the GNU General Public License version 2 as
 >> + * published by the Free Software Foundation.
 >> + */
 >> +#include 
 >> +
 >> +#include &quot;board-rx51-secure.h&quot;
 >> +
 >> +/**
 >> + * rx51_secure_dispatcher: Routine to dispatch secure PPA API calls
 >> + * @idx: The PPA API index
 >> + * @flag: The flag indicating criticality of operation
 >> + * @nargs: Number of valid arguments out of four.
 >> + * @arg1, arg2, arg3 args4: Parameters passed to secure API
 >> + *
 >> + * Return the non-zero error value on failure.
 >> + */
 >> +u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs, u32 arg1, u32 arg2,
 >> +			   u32 arg3, u32 arg4)
 >> +{
 >> +	u32 ret;
 >> +	u32 param[5];
 >> +
 >> +	param[0] = nargs+1;
 >> +	param[1] = arg1;
 >> +	param[2] = arg2;
 >> +	param[3] = arg3;
 >> +	param[4] = arg4;
 >> +
 >> +	/*
 >> +	 * Secure API needs physical address
 >> +	 * pointer for the parameters
 >> +	 */
 >> +	flush_cache_all();
 >> +	outer_clean_range(__pa(param), __pa(param + 5));
 >> +	ret = rx51_ppa_smc(idx, flag, __pa(param));
 >> +
 >> +	return ret;
 >> +}
 >> +
 >> +/**
 >> + * rx51_secure_update_aux_cr: Routine to modify the contents of Auxiliary Control Register
 >> + *  @set_bits: bits to set in ACR
 >> + *  @clr_bits: bits to clear in ACR
 >> + *
 >> + * Return the non-zero error value on failure.
 >> +*/
 >> +u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits)
 >> +{
 >> +	u32 acr;
 >> +
 >> +	/* Read ACR */
 >> +	asm volatile (&quot;mrc p15, 0, %0, c1, c0, 1&quot; : &quot;=r&quot; (acr));
 >> +	acr &amp;= ~clear_bits;
 >> +	acr |= set_bits;
 >> +
 >> +	return rx51_secure_dispatcher(RX51_PPA_WRITE_ACR,
 >> +			       FLAG_START_CRITICAL,
 >> +			       1,acr,0,0,0);
 >> +}
 >> diff --git a/arch/arm/mach-omap2/board-rx51-secure.h b/arch/arm/mach-omap2/board-rx51-secure.h
 >> new file mode 100644
 >> index 0000000..61c760b
 >> --- /dev/null
 >> +++ b/arch/arm/mach-omap2/board-rx51-secure.h
 >> @@ -0,0 +1,36 @@
 >> +/*
 >> + * board-rx51-secure.h: OMAP Secure infrastructure header.
 >> + *
 >> + * Copyright (C) 2012 Ivaylo Dimitrov 
 >> + *
 >> + * This program is free software; you can redistribute it and/or modify
 >> + * it under the terms of the GNU General Public License version 2 as
 >> + * published by the Free Software Foundation.
 >> + */
 >> +#ifndef OMAP_RX51_SECURE_H
 >> +#define OMAP_RX51_SECURE_H
 >> +
 >> +/* HAL API error codes */
 >> +#define  API_HAL_RET_VALUE_OK           0x00
 >> +#define  API_HAL_RET_VALUE_FAIL         0x01
 >> +
 >> +/* Secure HAL API flags */
 >> +#define FLAG_START_CRITICAL             0x4
 >> +#define FLAG_IRQFIQ_MASK                0x3
 >> +#define FLAG_IRQ_ENABLE                 0x2
 >> +#define FLAG_FIQ_ENABLE                 0x1
 >> +#define NO_FLAG                         0x0
 >> +
 >> +/* Secure PPA(Primary Protected Application) APIs */
 >> +#define RX51_PPA_L2_INVAL               40
 >> +#define RX51_PPA_WRITE_ACR              42
 >> +
 >> +#ifndef __ASSEMBLER__
 >> +
 >> +extern u32 rx51_secure_dispatcher(u32 idx, u32 flag, u32 nargs,
 >> +                                u32 arg1, u32 arg2, u32 arg3, u32 arg4);
 >> +extern u32 rx51_ppa_smc(u32 id, u32 flag, u32 pargs);
 >> +
 >> +extern u32 rx51_secure_update_aux_cr(u32 set_bits, u32 clear_bits);
 >> +#endif /* __ASSEMBLER__ */
 >> +#endif /* OMAP_RX51_SECURE_H */
 >> diff --git a/arch/arm/mach-omap2/board-rx51-smc.S b/arch/arm/mach-omap2/board-rx51-smc.S
 >> new file mode 100644
 >> index 0000000..70e2eb7
 >> --- /dev/null
 >> +++ b/arch/arm/mach-omap2/board-rx51-smc.S
 >> @@ -0,0 +1,34 @@
 >> +/*
 >> + * RX51 secure APIs file.
 >> + *
 >> + * Copyright (C) 2012 Ivaylo Dimitrov 
 >> + *
 >> + *
 >> + * This program is free software,you can redistribute it and/or modify
 >> + * it under the terms of the GNU General Public License version 2 as
 >> + * published by the Free Software Foundation.
 >> + */
 >> +
 >> +#include 
 >> +
 >> +/**
 >> + * u32 rx51_ppa_smc(u32 id, u32 flag, u32 pargs)
 >> + * Low level common routine for secure HAL and PPA APIs.
 >> + * @id: Secure Service ID
 >> + * @flag: Flag to indicate the criticality of operation
 >> + * @pargs: Physical address of parameter list starting
 >> + *          with number of parametrs
 >> + */
 >> +ENTRY(rx51_ppa_smc)
 >> +	.arch_extension sec
 >> +	stmfd	sp!, {r4-r12, lr}
 >> +	mov	r12, r0		@ Copy the secure service ID
 >> +	mov	r3, r2		@ Copy the pointer to va_list in R3
 >> +	mov	r2, r1		@ Copy the flags in R2
 >> +	mov	r1, #0x0	@ Process ID - 0
 >> +	mov	r6, #0xff	@ Indicate new Task call
 >> +	dsb
 >> +	dmb
 >> +	smc	#1		@ call PPA service
 >> +	ldmfd	sp!, {r4-r12, pc}
 >> +ENDPROC(rx51_ppa_smc)
 >> diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
 >> index 92117a13..fd85081 100644
 >> --- a/arch/arm/mach-omap2/board-rx51.c
 >> +++ b/arch/arm/mach-omap2/board-rx51.c
 >> @@ -31,6 +31,7 @@
 >>  #include &quot;gpmc.h&quot;
 >>  #include &quot;pm.h&quot;
 >>  #include &quot;sdram-nokia.h&quot;
 >> +#include &quot;board-rx51-secure.h&quot;
 >>  
 >>  #define RX51_GPIO_SLEEP_IND 162
 >>  
 >> @@ -103,6 +104,12 @@ static void __init rx51_init(void)
 >>  	rx51_peripherals_init();
 >>  	rx51_camera_init();
 >>  
 >> +#ifdef CONFIG_ARM_ERRATA_430973
 >> +	printk(KERN_INFO &quot;Enabling ARM errata 430973 workaround.&#92;n&quot;);
 >> +	/* set IBE to 1 */
 >> +	rx51_secure_update_aux_cr(1 << 6, 0);
 >> +#endif
 >> +
 >>  	/* Ensure SDRC pins are mux'd for self-refresh */
 >>  	omap_mux_init_signal(&quot;sdrc_cke0&quot;, OMAP_PIN_OUTPUT);
 >>  	omap_mux_init_signal(&quot;sdrc_cke1&quot;, OMAP_PIN_OUTPUT);
 >> -- 
 >> 1.7.10.4
 >> 
 >> 
 >> _______________________________________________
 >> linux-arm-kernel mailing list
 >> linux-arm-kernel@lists.infradead.org
 >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
 >
 >-- 
 >Regards,
 >Nishanth Menon
 >
