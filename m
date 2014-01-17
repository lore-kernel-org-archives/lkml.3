Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaAQW2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:28:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43482 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaAQW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:28:08 -0500
Date: Fri, 17 Jan 2014 23:28:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
Message-ID: <20140117222806.GB13930@amd.pavel.ucw.cz>
References: <20140114114133.GA31473@khazad-dum.debian.net>
 <20140114115547.GA29887@pd.tnic>
 <52D55468.6000000@zytor.com>
 <20140114153534.GE29865@pd.tnic>
 <20140114162722.GF29865@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114162722.GF29865@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-01-14 17:27:23, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This adds the workaround for erratum 793 as a precaution in case not
> every BIOS implements it. This addresses CVE-2013-6885.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/kernel/cpu/amd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 4a48e8bbd857..e4d6f8c91f51 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -507,6 +507,17 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>  			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
>  	}
>  #endif
> +
> +#define MSR_AMD_LS_CFG	0xc0011020
> +	/* F16h, models 00h-0fh, erratum 793 */
> +	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
> +		u64 val;
> +
> +		rdmsrl(MSR_AMD_LS_CFG, val);
> +		if (!(val & BIT(15)))
> +			wrmsrl(MSR_AMD_LS_CFG, val | BIT(15));

Would it make sense to printk() a warning?

BIOS is clearly buggy in this case, and it may cause problems with
another operating system, earlier kernel, or maybe early in boot
before MSR is written...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
