Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaEUU1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:27:42 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46643 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEUU1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:27:41 -0400
Date: Wed, 21 May 2014 22:27:35 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
Message-ID: <20140521202735.GC23153@alberich>
References: <1400602574.4912.43.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400602574.4912.43.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:16:14PM +0200, Paul Bolle wrote:
> Three checks for CONFIG_CAVIUM_GDB were added in v2.6.29. But the
> Kconfig symbol CAVIUM_GDB was never added to the tree. Remove these
> checks.
> 
> Also remove the last reference to octeon_get_boot_debug_flag(). There is
> no definition of that function anyway.

Hmm, yes, this was added with commit
5b3b16880f404ca54126210ca86141cceeafc0cf (MIPS: Add Cavium OCTEON
processor support files to arch/mips/cavium-octeon.) and incomplete
ever since (in mainline kernel).
 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.

Removing this dead code shouldn't harm. I also did a quick test of a
kernel with your patch with an octeon system -- as expected no issues
observed. (So it's
Tested-by: Andreas Herrmann <andreas.herrmann@caviumnetworks.com>)

> A follow up might be to remove plat_smp_ops.cpus_done. All these
> callbacks are now (basically) nops.

I am not sure about completely removing cpus_done from
plat_smp_ops. Maybe some platform will really make use of this in the
future.


Thanks,
Andreas
 
>  arch/mips/cavium-octeon/setup.c       | 11 -----------
>  arch/mips/cavium-octeon/smp.c         | 17 -----------------
>  arch/mips/include/asm/octeon/octeon.h |  1 -
>  3 files changed, 29 deletions(-)
> 
> diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
> index 953ca85f84fa..989781fbae76 100644
> --- a/arch/mips/cavium-octeon/setup.c
> +++ b/arch/mips/cavium-octeon/setup.c
> @@ -729,17 +729,6 @@ void __init prom_init(void)
>  	octeon_write_lcd("Linux");
>  #endif
>  
> -#ifdef CONFIG_CAVIUM_GDB
> -	/*
> -	 * When debugging the linux kernel, force the cores to enter
> -	 * the debug exception handler to break in.
> -	 */
> -	if (octeon_get_boot_debug_flag()) {
> -		cvmx_write_csr(CVMX_CIU_DINT, 1 << cvmx_get_core_num());
> -		cvmx_read_csr(CVMX_CIU_DINT);
> -	}
> -#endif
> -
>  	octeon_setup_delays();
>  
>  	/*
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index 67a078ffc464..78e1abebc854 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -218,15 +218,6 @@ void octeon_prepare_cpus(unsigned int max_cpus)
>   */
>  static void octeon_smp_finish(void)
>  {
> -#ifdef CONFIG_CAVIUM_GDB
> -	unsigned long tmp;
> -	/* Pulse MCD0 signal on Ctrl-C to stop all the cores. Also set the MCD0
> -	   to be not masked by this core so we know the signal is received by
> -	   someone */
> -	asm volatile ("dmfc0 %0, $22\n"
> -		      "ori   %0, %0, 0x9100\n" "dmtc0 %0, $22\n" : "=r" (tmp));
> -#endif
> -
>  	octeon_user_io_init();
>  
>  	/* to generate the first CPU timer interrupt */
> @@ -239,14 +230,6 @@ static void octeon_smp_finish(void)
>   */
>  static void octeon_cpus_done(void)
>  {
> -#ifdef CONFIG_CAVIUM_GDB
> -	unsigned long tmp;
> -	/* Pulse MCD0 signal on Ctrl-C to stop all the cores. Also set the MCD0
> -	   to be not masked by this core so we know the signal is received by
> -	   someone */
> -	asm volatile ("dmfc0 %0, $22\n"
> -		      "ori   %0, %0, 0x9100\n" "dmtc0 %0, $22\n" : "=r" (tmp));
> -#endif
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
> index f5d77b91537f..d781f9e66884 100644
> --- a/arch/mips/include/asm/octeon/octeon.h
> +++ b/arch/mips/include/asm/octeon/octeon.h
> @@ -211,7 +211,6 @@ union octeon_cvmemctl {
>  
>  extern void octeon_write_lcd(const char *s);
>  extern void octeon_check_cpu_bist(void);
> -extern int octeon_get_boot_debug_flag(void);
>  extern int octeon_get_boot_uart(void);
>  
>  struct uart_port;
> -- 
> 1.9.0
> 
> 
