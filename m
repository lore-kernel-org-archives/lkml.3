Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaFPNjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:39:39 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51131 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaFPNjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:39:37 -0400
Date: Mon, 16 Jun 2014 14:38:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liu hua <sdu.liu@huawei.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "mika.westerberg@iki.fi" <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alonid@stratoscale.com" <alonid@stratoscale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH] ARM: kdump: Add vmcore_elf64_check_arch
Message-ID: <20140616133849.GG16758@arm.com>
References: <1399124686-63299-1-git-send-email-sdu.liu@huawei.com>
 <20140506121558.GB30234@arm.com>
 <5395B4D0.6040302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5395B4D0.6040302@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:21:20PM +0100, Liu hua wrote:
> 于 2014/5/6 20:15, Will Deacon 写道:
> > On Sat, May 03, 2014 at 02:44:46PM +0100, Liu Hua wrote:
> Sorry to reply you so late. These days I am working on kdump feature for LPAE enabled
> kernel. And now I think this patch is not good.
> 
> > This function looks identical to elf_check_arch. Why do we need to duplicate
> > that code? You could use some pre-processor magic to make the core part of
> > the functions agnostic to header type.
> 
> At the begging I think I should add elf_check_arch_64 just as elf_check_arch to
> do complicated check.
> 
> But for ARM32, elf_check_arch_64 would not be used except for kdump. No programs
> with elf64 header can be loaded into 32bit ARM kernel. So I think I can just check
> the "e_machine", just as what other platform does. I think other checks is useless
> for kdump.
> 
> > In fact, if elf_check_arch could handle both header types then the generic
> > definition of vmcore_elf64_check_arch in include/linux/crash_dump.h would
> > work out of the box.
> 
> As I mentioned, I afraid this will make the code hard to understand.( Sorry
> for my former incorrect patch).
> 
> How about this patch?
> 
> diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
> index f4b46d3..9424542 100644
> --- a/arch/arm/include/asm/elf.h
> +++ b/arch/arm/include/asm/elf.h
> @@ -97,7 +97,7 @@ struct elf32_hdr;
>  extern int elf_check_arch(const struct elf32_hdr *);
>  #define elf_check_arch elf_check_arch
> 
> -#define vmcore_elf64_check_arch(x) (0)
> +#define vmcore_elf64_check_arch(x) ((x)->e_machine == EM_ARM)

Is there no way we can get away with using the generic version here? What
goes wrong if you let vmcore_elf64_check_arch fallback to elf_check_arch?

Will
