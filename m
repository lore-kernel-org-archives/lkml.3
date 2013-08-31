Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3HaQpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:45:14 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:32907 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3HaQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:45:12 -0400
Date: Sat, 31 Aug 2013 09:45:09 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Joe Perches <joe@perches.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, John Ronciak <john.ronciak@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [E1000-devel] [PATCH] i40e: Fix 32 bit shift compilation
 warnings
Message-ID: <20130831094509.5211b0d1@nehalam.linuxnetplumber.net>
In-Reply-To: <1377913655.2070.45.camel@joe-AO722>
References: <cover.1377903831.git.joe@perches.com>
	<daa992875a6f542adc41069daeb81246e46b7f80.1377903831.git.joe@perches.com>
	<1377913655.2070.45.camel@joe-AO722>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Aug 2013 18:47:35 -0700
Joe Perches <joe@perches.com> wrote:

> When dma_addr_t is a 32 bit value, >> 32 emits compiler warnings
> Use ((addr>>16) >>16) to avoid this.
> 
> I presume the macro should actually use the kernel.h
> macro upper_32_bits() eventually.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_hmc.h  | 2 +-
>  drivers/net/ethernet/intel/i40e/i40e_type.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_hmc.h b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
> index 745fb355..2f1b72f 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_hmc.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_hmc.h
> @@ -123,7 +123,7 @@ struct i40e_hmc_info {
>  #define I40E_SET_PF_SD_ENTRY(hw, pa, sd_index, type)			\
>  {									\
>  	u32 val1, val2, val3;						\
> -	val1 = (u32)((pa) >> sizeof(u32) * 8);				\
> +	val1 = (u32)(I40E_HI_DWORD(pa));				\
>  	val2 = (u32)(pa) | (I40E_HMC_MAX_BP_COUNT <<			\
>  		 I40E_PFHMC_SDDATALOW_PMSDBPCOUNT_SHIFT) |		\
>  		((((type) == I40E_SD_TYPE_PAGED) ? 0 : 1) <<		\
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
> index 36e35cc..4263cf7 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_type.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
> @@ -78,8 +78,8 @@ typedef void (*I40E_ADMINQ_CALLBACK)(struct i40e_hw *, struct i40e_aq_desc *);
>  #define I40E_ETH_LENGTH_OF_ADDRESS	6
>  
>  /* Data type manipulation macros. */
> -#define I40E_HI_DWORD(x)	((u32)(((x)>>32)&0xFFFFFFFF))
> -#define I40E_LO_DWORD(x)	((u32)((x)&0xFFFFFFFF))
> +#define I40E_HI_DWORD(x)	((u32)((((x) >> 16) >> 16) & 0xFFFFFFFF))
> +#define I40E_LO_DWORD(x)	((u32)((x) & 0xFFFFFFFF))
>  
>  #define I40E_HI_WORD(x)		((u16)(((x)>>16)&0xFFFF))
>  #define I40E_DESC_UNUSED(R)	\

After seeing this before in other drivers, a standard set of macros
was added called upper_32bits and lower_32bits. These should be used instead
of masking.

