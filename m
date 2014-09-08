Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbaIHKwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:52:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51728 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404AbaIHKws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:52:48 -0400
Date: Mon, 8 Sep 2014 11:53:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: "behanw@converseincode.com" <behanw@converseincode.com>
Cc: "anderson@redhat.com" <anderson@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "cl@linux.com" <cl@linux.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "jays.lee@samsung.com" <jays.lee@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@kernel.org" <acme@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Matthew Leach <Matthew.Leach@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "paulus@samba.org" <paulus@samba.org>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with
 clang
Message-ID: <20140908105307.GF26030@arm.com>
References: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 12:24:20AM +0100, behanw@converseincode.com wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> Fix variable types for 64-bit inline assembly.
> 
> This patch now works with both gcc and clang.

Really? This looks like something the clang needs to do better on, as I
really don't see people adding these casts to future code. They're ugly and
redundant (or GCC).

This hunk:

> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index c555672..6894ef3 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -94,7 +94,7 @@ static int __init early_cachepolicy(char *p)
>  	 */
>  	asm volatile(
>  	"	mrs	%0, mair_el1\n"
> -	"	bfi	%0, %1, #%2, #8\n"
> +	"	bfi	%0, %1, %2, #8\n"
>  	"	msr	mair_el1, %0\n"
>  	"	isb\n"
>  	: "=&r" (tmp)

also looks fishy. Does gas accept that without the '#' prefix?

Will
