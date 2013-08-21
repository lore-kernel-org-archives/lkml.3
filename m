Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3HUH3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:29:45 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:61410 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3HUH3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:29:44 -0400
Date: Wed, 21 Aug 2013 09:29:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li Fei <fei.li@intel.com>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        chuansheng.liu@intel.com, x86@kernel.org, akpm@linux-foundation.org,
        holt@sgi.com, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Message-ID: <20130821072940.GB27495@gmail.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Fei <fei.li@intel.com> wrote:

> In current implementation for reboot type CF9 and CF9_COND,
> warm and cold reset are not differentiated, and both are
> performed by writing 0x06 to port 0xCF9 as warm reset. It's not
> correct.
> 
> This commit will differentiate warm and cold reset, and perform
> them correctly as below:
> For warm reset, write 0x06 to port 0xCF9;
> For cold reset, write 0x0E to port 0xCF9.
> 
> From: Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>
> ---
>  arch/x86/kernel/reboot.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 563ed91..6e06299 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -511,10 +511,15 @@ static void native_machine_emergency_restart(void)
>  
>  		case BOOT_CF9_COND:
>  			if (port_cf9_safe) {
> -				u8 cf9 = inb(0xcf9) & ~6;
> +				u8 cf9 = inb(0xcf9) &
> +						~(reboot_mode == REBOOT_WARM ?
> +						0x06 : 0x0E);
>  				outb(cf9|2, 0xcf9); /* Request hard reset */
>  				udelay(50);
> -				outb(cf9|6, 0xcf9); /* Actually do the reset */
> +				/* Actually do the reset */
> +				outb(cf9|(reboot_mode == REBOOT_WARM ?
> +					0x06 : 0x0E),
> +					0xcf9);
>  				udelay(50);

Looks good, but please introduce a reboot_val intermediate 
variable instead of duplicating that ugly line-broken 
construct twice.

Thanks,

	Ingo
