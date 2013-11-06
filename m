Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3KFMlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:41:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13019 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab3KFMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:41:22 -0500
X-IronPort-AV: E=Sophos;i="4.93,647,1378857600"; 
   d="scan'208";a="68571941"
Date: Wed, 6 Nov 2013 12:40:04 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Olof Johansson <olof@lixom.net>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v9 16/18] arm,arm64: do not always merge biovec if we
 are running on Xen
In-Reply-To: <CAOesGMjdfGoEp+yCRa1WhQi=c_LHBCjrU3H9WUqf0Fn_cqkz_Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311061222290.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com> <1382698313-13161-16-git-send-email-stefano.stabellini@eu.citrix.com> <CAOesGMjdfGoEp+yCRa1WhQi=c_LHBCjrU3H9WUqf0Fn_cqkz_Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Olof Johansson wrote:
> Hi,
> 
> On Fri, Oct 25, 2013 at 3:51 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > This is similar to what it is done on X86: biovecs are prevented from merging
> > otherwise every dma requests would be forced to bounce on the swiotlb buffer.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> 
> This is spewing 800+ warnings on ape6evm_defconfig on ARM that doesn't
> have CONFIG_BLOCK enabled, since struct bio_vec is protected by that
> in include/linux/blk_types.h. I guess it could be argued that those
> ifdefs could be removed, but still:
> 
> ../../arch/arm/include/asm/io.h:378:24: warning: its scope is only
> this definition or declaration, which is probably not what you want
> [enabled by default]
> In file included from ../../include/linux/scatterlist.h:10:0,
>                  from ../../include/linux/dmaengine.h:27,
>                  from ../../include/linux/skbuff.h:31,
>                  from ../../include/crypto/algapi.h:18,
>                  from ../../crypto/internal.h:16,
>                  from ../../crypto/cipher.c:21:
> ../../arch/arm/include/asm/io.h:378:24: warning: 'struct bio_vec'
> declared inside parameter list [enabled by default]
>            const struct bio_vec *vec2);

Thanks for letting me know.
What about the following?


commit 06fc174ce8da30f81b59c9d1d7680a2490525884
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Wed Nov 6 12:38:28 2013 +0000

    arm,arm64/include/asm/io.h: define struct bio_vec
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index c45effc..3c597c2 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -374,6 +374,7 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 #define BIOVEC_MERGEABLE(vec1, vec2)	\
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
 
+struct bio_vec;
 extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 				      const struct bio_vec *vec2);
 #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index c163287b..757c87a 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -266,6 +266,7 @@ extern int devmem_is_allowed(unsigned long pfn);
  */
 #define xlate_dev_kmem_ptr(p)	p
 
+struct bio_vec;
 extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
 				      const struct bio_vec *vec2);
 #define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
