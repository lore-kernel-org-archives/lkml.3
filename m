Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3LBDPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:15:42 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:43562 "EHLO cstnet.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752773Ab3LBDPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:15:40 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2013 22:15:39 EST
Date: Mon, 2 Dec 2013 11:07:04 +0800 (GMT+08:00)
From: "Zhouyi Zhou" <yizhouzhou@ict.ac.cn>
To: "Zhouyi Zhou" <zhouzhouyi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Message-ID: <e9c283.a967.142b14600da.Coremail.yizhouzhou@ict.ac.cn>
In-Reply-To: <1385549465-15945-1-git-send-email-yizhouzhou@ict.ac.cn>
References: <1385549465-15945-1-git-send-email-yizhouzhou@ict.ac.cn>
Subject: ping: re: [PATCH 1/1] kernel code that do not handle NULL return of
 kmem_cache_zalloc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [159.226.43.61]
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT2.1.10 dev build
 20130508(22118.5358.5168) Copyright (c) 2002-2013 www.mailtech.cn cstnet
X-SendMailWithSms: false
X-CM-CTRLDATA: jf6zwWZvb3Rlcl90eHQ9MjI4MTo2
X-CM-TRANSID: SwCowJD7P+1Y+ZtSVsgHAA--.25170W
X-CM-SenderInfo: x1l2x05x2k03g6lf3hldfou0/1tbiBAQBAFEVMghC9gAAsL
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping
> I do a grep for kmem_cache_zalloc and kmem_cache_alloc
> in kernel tree, and find some code do not handle NULL
> return of kmem_cache_zalloc correctly
> 
> 
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  arch/powerpc/kvm/book3s_32_mmu_host.c |    5 +++++
>  drivers/iommu/omap-iommu.c            |    3 ++-
>  fs/jffs2/malloc.c                     |    4 ++++
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
> index 3a0abd2..5fac89d 100644
> --- a/arch/powerpc/kvm/book3s_32_mmu_host.c
> +++ b/arch/powerpc/kvm/book3s_32_mmu_host.c
> @@ -243,6 +243,11 @@ next_pteg:
>  	/* Now tell our Shadow PTE code about the new page */
>  
>  	pte = kvmppc_mmu_hpte_cache_next(vcpu);
> +	if (!pte) {
> +		kvm_release_pfn_clean(hpaddr >> PAGE_SHIFT);
> +		r = -EAGAIN;
> +		goto out;
> +	}
>  
>  	dprintk_mmu("KVM: %c%c Map 0x%llx: [%lx] 0x%llx (0x%llx) -> %lx\n",
>  		    orig_pte->may_write ? 'w' : '-',
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index bcd78a7..5155714 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -551,7 +551,8 @@ static u32 *iopte_alloc(struct omap_iommu *obj, u32 *iopgd, u32 da)
>  		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
>  	} else {
>  		/* We raced, free the reduniovant table */
> -		iopte_free(iopte);
> +		if (iopte)
> +			iopte_free(iopte);
>  	}
>  
>  pte_ready:
> diff --git a/fs/jffs2/malloc.c b/fs/jffs2/malloc.c
> index 4f47aa2..58e2336 100644
> --- a/fs/jffs2/malloc.c
> +++ b/fs/jffs2/malloc.c
> @@ -287,6 +287,8 @@ struct jffs2_xattr_datum *jffs2_alloc_xattr_datum(void)
>  {
>  	struct jffs2_xattr_datum *xd;
>  	xd = kmem_cache_zalloc(xattr_datum_cache, GFP_KERNEL);
> +	if (!xd)
> +		return NULL;
>  	dbg_memalloc("%p\n", xd);
>  
>  	xd->class = RAWNODE_CLASS_XATTR_DATUM;
> @@ -305,6 +307,8 @@ struct jffs2_xattr_ref *jffs2_alloc_xattr_ref(void)
>  {
>  	struct jffs2_xattr_ref *ref;
>  	ref = kmem_cache_zalloc(xattr_ref_cache, GFP_KERNEL);
> +	if (!ref)
> +		return NULL;
>  	dbg_memalloc("%p\n", ref);
>  
>  	ref->class = RAWNODE_CLASS_XATTR_REF;
> -- 
> 1.7.10.4
> 




