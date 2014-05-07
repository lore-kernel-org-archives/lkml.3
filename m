Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752AbaEGLmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:42:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4468 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbaEGLmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:42:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,1002,1389744000"; 
   d="scan'208";a="127656094"
Date: Wed, 7 May 2014 12:41:56 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Ian Campbell <ian.campbell@citrix.com>, <konrad.wilk@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm/xen: Remove definiition of virt_to_pfn in
 asm/xen/page.h
In-Reply-To: <alpine.DEB.2.02.1404251801060.8072@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1405071234010.14596@kaball.uk.xensource.com>
References: <1397836474-10478-1-git-send-email-julien.grall@linaro.org> <535901F0.3010908@citrix.com> <53590845.1090405@linaro.org> <53591B8F.8070300@citrix.com> <alpine.DEB.2.02.1404251801060.8072@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-500734660-1399462803=:14596"
Content-ID: <alpine.DEB.2.02.1405071240330.14596@kaball.uk.xensource.com>
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-500734660-1399462803=:14596
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.02.1405071240331.14596@kaball.uk.xensource.com>

On Fri, 25 Apr 2014, Stefano Stabellini wrote:
> On Thu, 24 Apr 2014, David Vrabel wrote:
> > On 24/04/14 13:49, Julien Grall wrote:
> > > Hi David,
> > >=20
> > > On 04/24/2014 01:22 PM, David Vrabel wrote:
> > >> On 18/04/14 16:54, Julien Grall wrote:
> > >>> virt_to_pfn has been defined in asm/memory.h by the commit e26a9e0 =
"ARM: Better
> > >>> virt_to_page() handling"
> > >>>
> > >>> This will result of a compilation warning when CONFIG_XEN is enable=
d.
> > >>>
> > >>> arch/arm/include/asm/xen/page.h:80:0: warning: "virt_to_pfn" redefi=
ned [enabled by default]
> > >>>  #define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
> > >>>  ^
> > >>> In file included from arch/arm/include/asm/page.h:163:0,
> > >>>                  from arch/arm/include/asm/xen/page.h:4,
> > >>>                  from include/xen/page.h:4,
> > >>>                  from arch/arm/xen/grant-table.c:33:
> > >>>
> > >>> The definition in memory.h is nearly the same (it directly expand P=
FN_DOWN),
> > >>> so we can safely drop virt_to_pfn in xen include.
> > >>
> > >>
> > >> This breaks the arm build for me.
> > >>
> > >> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c: In funct=
ion
> > >> =E2=80=98setup_blkring=E2=80=99:
> > >> /local/davidvr/work/k.org/tip/drivers/block/xen-blkfront.c:1236:2:
> > >> error: implicit declaration of function =E2=80=98virt_to_pfn=E2=80=
=99
> > >> [-Werror=3Dimplicit-function-declaration]
> > >>   err =3D xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
> > >>   ^
> > >=20
> > > I don't have any issue to build the following branch with this patch =
on:
> > > =09- v3.15-rc2
> > > =09- xentip master
> > > =09- xentip for-linus-3.16
> >=20
> > Applied to devel/for-linus-3.16.
> >=20
> > If something else turns up for 3.15 (and I remember) I'll take it for
> > 3.15 instead.
>=20
> David,
> thank you very much for taking the patch in my absence.
>=20
> Considering that the problem is affecting everybody enabling CONFIG_XEN
> on ARM on v3.15, I don't think we can wait for the next merge window to
> send this fix upstream.
> Too many warnings for too many people.

Unfortunately this commit breaks arm64 compilation, as virt_to_pfn has
not been introduced to arm64/include/asm/memory.h.
Has the patch been sent upstream yet?

We need this additional change for arm64:


diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memor=
y.h
index e94f945..993bce5 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -138,6 +138,7 @@ static inline void *phys_to_virt(phys_addr_t x)
 #define __pa(x)=09=09=09__virt_to_phys((unsigned long)(x))
 #define __va(x)=09=09=09((void *)__phys_to_virt((phys_addr_t)(x)))
 #define pfn_to_kaddr(pfn)=09__va((pfn) << PAGE_SHIFT)
+#define virt_to_pfn(x)      __phys_to_pfn(__virt_to_phys(x))
=20
 /*
  *  virt_to_page(k)=09convert a _valid_ virtual address to struct page *
--1342847746-500734660-1399462803=:14596--
