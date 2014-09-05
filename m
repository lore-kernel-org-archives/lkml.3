Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaIEUIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:08:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50971 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaIEUI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:08:29 -0400
Message-ID: <540A17A6.1000802@zytor.com>
Date: Fri, 05 Sep 2014 13:05:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org
CC: coreboot@coreboot.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>
Subject: Re: [PATCH] x86: add coreboot framebuffer support
References: <1409826307-23075-1-git-send-email-kraxel@redhat.com>
In-Reply-To: <1409826307-23075-1-git-send-email-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 03:25 AM, Gerd Hoffmann wrote:
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/Kconfig           |  12 +++
>  arch/x86/kernel/Makefile   |   1 +
>  arch/x86/kernel/coreboot.c | 232 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 245 insertions(+)
>  create mode 100644 arch/x86/kernel/coreboot.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 778178f..3aeb038 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2372,6 +2372,18 @@ config X86_SYSFB
>  
>  	  If unsure, say Y.
>  
> +config COREBOOT
> +	bool "coreboot"
> +	depends on X86_SYSFB
> +	depends on FB_SIMPLE
> +	help
> +	  Add coreboot framebuffer support to the linux kernel.	 Say Y here
> +	  if you want the linux kernel find and use the firmware framebuffer
> +	  initialized by coreboot.  Useful when using the linux kernel as
> +	  coreboot payload.
> +
> +	  If unsure, or if you don't know what coreboot is, say N.
> +
>  endmenu
>  

This should NOT be named CONFIG_COREBOOT.  CONFIG_FB_COREBOOT perhaps.

> +
> +struct cb_header {
> +	u32     signature;
> +	u32     header_bytes;
> +	u32     header_checksum;
> +	u32     table_bytes;
> +	u32     table_checksum;
> +	u32     table_entries;
> +};
> +
> +#define CB_TAG_MAINBOARD        0x0003
> +#define CB_TAG_VERSION          0x0004
> +#define CB_TAG_FORWARD          0x0011
> +#define CB_TAG_FRAMEBUFFER      0x0012
> +
> +struct cb_mainboard {
> +	u8      vendor_idx;
> +	u8      part_idx;
> +	char    strings[0];
> +};
> +
> +struct cb_framebuffer {
> +	u64     physical_address;
> +	u32     x_resolution;
> +	u32     y_resolution;
> +	u32     bytes_per_line;
> +	u8      bits_per_pixel;
> +	u8      red_mask_pos;
> +	u8      red_mask_size;
> +	u8      green_mask_pos;
> +	u8      green_mask_size;
> +	u8      blue_mask_pos;
> +	u8      blue_mask_size;
> +	u8      reserved_mask_pos;
> +	u8      reserved_mask_size;
> +};
> +
> +struct cb_entry {
> +	u32     tag;
> +	u32     size;
> +	union {
> +		char    string[0];
> +		u64     forward;
> +		struct cb_mainboard   mb;
> +		struct cb_framebuffer fb;
> +	} u;
> +};
> +
> +#define CB_SIGNATURE 0x4f49424C  /* "LBIO" */
> +

This stuff belongs in a header file.

I'm not a fan of Coreboot having invented its own nonstandard hacks, but
I guess it is pretty much unavoidable.

	-hpa


