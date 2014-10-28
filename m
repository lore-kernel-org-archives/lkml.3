Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaJ1INx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:13:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43002 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbaJ1INt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:13:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Ian Munsie <imunsie@au1.ibm.com>, mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2 3/4] powerpc/copro: Use appropriate ESID mask in copro_calculate_slb
In-Reply-To: <1414466730-15591-4-git-send-email-imunsie@au.ibm.com>
References: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com> <1414466730-15591-4-git-send-email-imunsie@au.ibm.com>
User-Agent: Notmuch/0.18.2+145~g9619379 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Oct 2014 13:43:28 +0530
Message-ID: <877fzky5lj.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102808-0009-0000-0000-000001D4E2BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Munsie <imunsie@au1.ibm.com> writes:

> From: Ian Munsie <imunsie@au1.ibm.com>
>
> This patch makes copro_calculate_slb mask the ESID by the correct mask
> for 1T vs 256M segments.
>
> This has no effect by itself as the extra bits were ignored, but it
> makes debugging the segment table entries easier and means that we can
> directly compare the ESID values for duplicates without needing to worry
> about masking in the comparison.
>
> This will be used to simplify a comparison in the following patch.
>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  arch/powerpc/mm/copro_fault.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
> index 0f9939e..5a236f0 100644
> --- a/arch/powerpc/mm/copro_fault.c
> +++ b/arch/powerpc/mm/copro_fault.c
> @@ -99,8 +99,6 @@ int copro_calculate_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb)
>  	u64 vsid;
>  	int psize, ssize;
>  
> -	slb->esid = (ea & ESID_MASK) | SLB_ESID_V;
> -
>  	switch (REGION_ID(ea)) {
>  	case USER_REGION_ID:
>  		pr_devel("%s: 0x%llx -- USER_REGION_ID\n", __func__, ea);
> @@ -133,6 +131,7 @@ int copro_calculate_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb)
>  	vsid |= mmu_psize_defs[psize].sllp |
>  		((ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0);
>  
> +	slb->esid = (ea & (ssize == MMU_SEGSIZE_1T ? ESID_MASK_1T : ESID_MASK)) | SLB_ESID_V;
>  	slb->vsid = vsid;
>  
>  	return 0;
> -- 
> 2.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

