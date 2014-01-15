Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAOAi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:38:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaAOAi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:38:56 -0500
Message-ID: <52D5D883.802@zytor.com>
Date: Tue, 14 Jan 2014 16:38:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kim Naru <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Sherry Hurwitz <sherry.hurwitz@amd.com>
Subject: Re: [PATCH -v1.1] x86, CPU, AMD: Add workaround for family 16h, erratum
 793
References: <20140114114133.GA31473@khazad-dum.debian.net> <20140114115547.GA29887@pd.tnic> <52D55468.6000000@zytor.com> <20140114153534.GE29865@pd.tnic> <20140114162722.GF29865@pd.tnic> <52D56627.9060802@zytor.com> <20140114164208.GK29865@pd.tnic> <52D5780E.4070700@zytor.com> <20140114230711.GS29865@pd.tnic>
In-Reply-To: <20140114230711.GS29865@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:07 PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> This adds the workaround for erratum 793 as a precaution in case not
> every BIOS implements it. This addresses CVE-2013-6885.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
> ---
>  arch/x86/include/uapi/asm/msr-index.h |  1 +
>  arch/x86/kernel/cpu/amd.c             | 10 ++++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 37813b5ddc37..59cea185ad1d 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -184,6 +184,7 @@
>  #define MSR_AMD64_PATCH_LOADER		0xc0010020
>  #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
>  #define MSR_AMD64_OSVW_STATUS		0xc0010141
> +#define MSR_AMD64_LS_CFG		0xc0011020
>  #define MSR_AMD64_DC_CFG		0xc0011022
>  #define MSR_AMD64_BU_CFG2		0xc001102a
>  #define MSR_AMD64_IBSFETCHCTL		0xc0011030
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 4a48e8bbd857..a4bec9cd293a 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -507,6 +507,16 @@ static void early_init_amd(struct cpuinfo_x86 *c)
>  			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
>  	}
>  #endif
> +
> +	/* F16h erratum 793, CVE-2013-6885 */
> +	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
> +		u64 val;
> +
> +		rdmsrl(MSR_AMD64_LS_CFG, val);
> +		if (!(val & BIT(15)))
> +			wrmsrl(MSR_AMD_LS_CFG, val | BIT(15));
> +	}
> +
>  }
>  
>  static const int amd_erratum_383[];
> 

In file included from
/home/hpa/kernel/distwork/arch/x86/include/asm/processor.h:20:0,
                 from
/home/hpa/kernel/distwork/arch/x86/include/asm/thread_info.h:22,
                 from
/home/hpa/kernel/distwork/include/linux/thread_info.h:54,
                 from
/home/hpa/kernel/distwork/arch/x86/include/asm/elf.h:7,
                 from /home/hpa/kernel/distwork/include/linux/elf.h:4,
                 from /home/hpa/kernel/distwork/arch/x86/kernel/cpu/amd.c:4:
/home/hpa/kernel/distwork/arch/x86/kernel/cpu/amd.c: In function
‘early_init_amd’:
/home/hpa/kernel/distwork/arch/x86/kernel/cpu/amd.c:518:11: error:
‘MSR_AMD_LS_CFG’ undeclared (first use in this function)
    wrmsrl(MSR_AMD_LS_CFG, val | BIT(15));
           ^
/home/hpa/kernel/distwork/arch/x86/include/asm/msr.h:156:20: note: in
definition of macro ‘wrmsrl’
  native_write_msr((msr), (u32)((u64)(val)), (u32)((u64)(val) >> 32))
                    ^
/home/hpa/kernel/distwork/arch/x86/kernel/cpu/amd.c:518:11: note: each
undeclared identifier is reported only once for each function it appear
s in
    wrmsrl(MSR_AMD_LS_CFG, val | BIT(15));
           ^
/home/hpa/kernel/distwork/arch/x86/include/asm/msr.h:156:20: note: in
definition of macro ‘wrmsrl’
  native_write_msr((msr), (u32)((u64)(val)), (u32)((u64)(val) >> 32))

	-hpa

