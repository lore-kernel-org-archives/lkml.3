Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaHRKTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaHRKTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:19:08 -0400
Message-ID: <53F1D313.5010108@redhat.com>
Date: Mon, 18 Aug 2014 12:18:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 11:50, Wanpeng Li ha scritto:
> EPT misconfig handler in kvm will check which reason lead to EPT 
> misconfiguration after vmexit. One of the reasons is that an EPT 
> paging-structure entry is configured with settings reserved for 
> future functionality. However, the handler can't identify if 
> paging-structure entry of reserved bits for 1-GByte page are 
> configured, since PDPTE which point to 1-GByte page will reserve 
> bits 29:12 instead of bits 7:3 which are reserved for PDPTE that 
> references an EPT Page Directory. This patch fix it by reserve 
> bits 29:12 for 1-GByte page. 
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
>  arch/x86/kvm/vmx.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index bfe11cf..71cbee5 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5521,9 +5521,14 @@ static u64 ept_rsvd_mask(u64 spte, int level)
>  	for (i = 51; i > boot_cpu_data.x86_phys_bits; i--)
>  		mask |= (1ULL << i);
>  
> -	if (level > 2)
> -		/* bits 7:3 reserved */
> -		mask |= 0xf8;
> +	if (level > 2) {

level can be 4 here.  You have to return 0xf8 for level == 4.

The same "if" statement then can cover both 2MB and 1GB pages, like

                if (spte & (1ULL << 7))
                        /* 1GB/2MB page, bits 29:12 or 20:12 reserved respectively */
                        mask |= (PAGE_SIZE << ((level - 1) * 9)) - PAGE_SIZE;
                else
                        /* bits 6:3 reserved */
                        mask |= 0x78;

> -		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
> +		if (level == 1 || ((level == 3 || level == 2)
> +				&& (spte & (1ULL << 7)))) {

This condition can be simplified by checking the return value of ept_rsvd_mask.
If it includes 0x38, this is a large page.  Otherwise it is a leaf page and
you can go down the "if".

Paolo

>  			u64 ept_mem_type = (spte & 0x38) >> 3;
>  
>  			if (ept_mem_type == 2 || ept_mem_type == 3 ||
> 

