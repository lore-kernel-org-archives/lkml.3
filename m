Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbbADHWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:22:34 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:51962 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbADHWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:22:30 -0500
Date: Sun, 4 Jan 2015 18:21:42 +1100 (AEDT)
From: Finn Thain <fthain@telegraphics.com.au>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Joshua Thompson <funaho@jurai.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: m68k: mac: misc.c: Remove some unused functions
In-Reply-To: <1420131732-31039-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.LNX.2.00.1501041045020.15927@nippy.intranet>
References: <1420131732-31039-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 Jan 2015, Rickard Strandqvist wrote:

> Removes some functions that are not used anywhere:
> mac_pram_write() mac_pram_read()
> 

If you remove those functions, you'd then find that all of the called 
functions become unused:

maciisi_read_pram
maciisi_write_pram
pmu_read_pram
pmu_write_pram
cuda_read_pram
cuda_write_pram
via_read_pram
via_write_pram

I'd rather not remove all of this code. Better to finish the 
implementation.

If we provide access to the PRAM (i.e. NVRAM) from userspace then the 
EMILE bootloader would be able to assign the boot device, for example.

Within the kernel, the CUDA PRAM functions could be used by valkyriefb to 
determine the correct default video mode (see comment in that driver).

Would it be acceptable to utilize drivers/char/generic_nvram.c and 
CONFIG_GENERIC_NVRAM? This is the PowerMac PRAM driver but looks generic 
enough that it may not need any modification for 68k Macs.

-- 

> This was partially found by using a static code analysis program called 
> cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  arch/m68k/mac/misc.c |   46 ----------------------------------------------
>  1 file changed, 46 deletions(-)
> 
> diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
> index 707b61a..6fe7eb6 100644
> --- a/arch/m68k/mac/misc.c
> +++ b/arch/m68k/mac/misc.c
> @@ -453,52 +453,6 @@ void pmu_shutdown(void)
>   *-------------------------------------------------------------------
>   */
>  
> -void mac_pram_read(int offset, __u8 *buffer, int len)
> -{
> -	__u8 (*func)(int);
> -	int i;
> -
> -	switch(macintosh_config->adb_type) {
> -	case MAC_ADB_IISI:
> -		func = maciisi_read_pram; break;
> -	case MAC_ADB_PB1:
> -	case MAC_ADB_PB2:
> -		func = pmu_read_pram; break;
> -	case MAC_ADB_CUDA:
> -		func = cuda_read_pram; break;
> -	default:
> -		func = via_read_pram;
> -	}
> -	if (!func)
> -		return;
> -	for (i = 0 ; i < len ; i++) {
> -		buffer[i] = (*func)(offset++);
> -	}
> -}
> -
> -void mac_pram_write(int offset, __u8 *buffer, int len)
> -{
> -	void (*func)(int, __u8);
> -	int i;
> -
> -	switch(macintosh_config->adb_type) {
> -	case MAC_ADB_IISI:
> -		func = maciisi_write_pram; break;
> -	case MAC_ADB_PB1:
> -	case MAC_ADB_PB2:
> -		func = pmu_write_pram; break;
> -	case MAC_ADB_CUDA:
> -		func = cuda_write_pram; break;
> -	default:
> -		func = via_write_pram;
> -	}
> -	if (!func)
> -		return;
> -	for (i = 0 ; i < len ; i++) {
> -		(*func)(offset++, buffer[i]);
> -	}
> -}
> -
>  void mac_poweroff(void)
>  {
>  	/*
> 
