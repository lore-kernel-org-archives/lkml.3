Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3BDQ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:59:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3BDQ7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:59:11 -0500
Date: Mon, 4 Feb 2013 10:59:00 -0600
From: Clark Williams <williams@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt26
Message-ID: <20130204105900.63bd5fae@riff.lan>
In-Reply-To: <20130204095438.41376edb@riff.lan>
References: <alpine.LFD.2.02.1302041537230.11905@ionos>
	<20130204095438.41376edb@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cq0ZRXcIpeT5GqH6d+g0XAr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cq0ZRXcIpeT5GqH6d+g0XAr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Feb 2013 09:54:38 -0600
Clark Williams <williams@redhat.com> wrote:

> On Mon, 4 Feb 2013 15:58:26 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> > Dear RT Folks,
> >=20
> > I'm pleased to announce the 3.6.11-rt26 release.
> >=20
> > Changes since 3.6.11-rt25:
> >=20
> >    1) Fix the RT highmem implementation on x86
> >=20
> >    2) Support highmem + RT on ARM
> >=20
> >    3) Fix an one off error in the generic highmem code (upstream fix
> >       did not make it into 3.6.stable)
> >=20
> >    4) Upstream SLUB fixes (Christoph Lameter)
> >=20
> >    5) Fix a few RT issues in mmc and amba drivers
> >=20
> >    6) Initialize local locks in mm/swap.c early
> >=20
> >    7) Use simple wait queues for completions. This is a performance
> >       improvement.
> >=20
> >       Completions do not have complex callbacks and the wakeup path is
> >       disabling interrupts anyway. So using simple wait locks with the
> >       raw spinlock is not a latency problem, but the "sleeping lock"
> >       in the normal waitqueue is a source for lock bouncing:
> >=20
> >       T1  	 	   T2
> >       lock(WQ)
> >       wakeup(T2)
> >       ---> preemption
> > 			   lock(WQ)
> > 			   pi_boost(T1)
> > 			   wait_for_lock(WQ)
> >       unlock(WQ)
> >       deboost(T1)
> >       ---> preemption
> > 			   ....
> >=20
> >       The simple waitqueue reduces this to:
> > 		  =20
> >       T1  	 	   T2
> >       raw_lock(WQ)
> >       wakeup(T2)
> >       raw_unlock(WQ)
> >       ---> preemption
> > 			   raw_lock(WQ)=09
> > 			   ....
> >=20
> > @Steven: Sorry, I forgot the stable tags on:
> > 	 drivers-tty-pl011-irq-disable-madness.patch
> > 	 mmci-remove-bogus-irq-save.patch
> > 	 idle-state.patch
> > 	 might-sleep-check-for-idle.patch
> > 	 mm-swap-fix-initialization.patch
> >=20
> > I'm still digging through my mail backlog, so I have not yet decided
> > whether this is the last RT release for 3.6.
> >=20
> >=20
> > The delta patch against 3.6.11-rt25 is appended below and can be found
> > here:
> >=20
> >   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6=
.11-rt25-rt26.patch.xz
> >=20
> > The RT patch against 3.6.11 can be found here:
> >=20
> >   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-r=
t26.patch.xz
> >=20
> > The split quilt queue is available at:
> >=20
> >   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11=
-rt26.tar.xz
> >=20
> > Enjoy,
> >=20
> > 	tglx
> >=20
>=20
>=20
> Thomas,
>=20
> I needed this change to build:
>=20
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index efe4b33..3d5231f 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -26,6 +26,7 @@
> =20
>  #include <linux/errno.h>
>  #include <linux/rbtree.h>
> +#include <linux/wait.h>
> =20
>  struct vm_area_struct;
>  struct mm_struct;
>=20
>=20
> Clark


More changes; I was running into a collision with the name kmap_prot.

This is not stacked on the above patch, it supercedes it.

Clark

diff --git a/arch/x86/include/asm/highmem.h b/arch/x86/include/asm/highmem.h
index dc7b47e..1004f7d 100644
--- a/arch/x86/include/asm/highmem.h
+++ b/arch/x86/include/asm/highmem.h
@@ -69,7 +69,7 @@ void *kmap_atomic_pfn(unsigned long pfn);
 void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot);
 struct page *kmap_atomic_to_page(void *ptr);
 #else
-void *kmap_prot(struct page *page, pgprot_t prot);
+void *__kmap_prot(struct page *page, pgprot_t prot);
 # define kmap_atomic(page)                     \
        ({ pagefault_disable(); kmap(page); })
=20
@@ -80,10 +80,10 @@ void *kmap_prot(struct page *page, pgprot_t prot);
        do { kunmap(kmap_to_page(kvaddr)); pagefault_enable(); } while(0)
=20
 # define kmap_atomic_prot(page, prot)          \
-       ({ pagefault_disable(); kmap_prot(page, prot); })
+       ({ pagefault_disable(); __kmap_prot(page, prot); })
=20
 # define kmap_atomic_prot_pfn(pfn, prot)       \
-       ({ pagefault_disable(); kmap_prot(pfn_to_page(pfn), prot); })
+       ({ pagefault_disable(); __kmap_prot(pfn_to_page(pfn), prot); })
=20
 # define kmap_atomic_to_page(kvaddr)           \
        kmap_to_page(kvaddr)
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 98f84e2..9a85340 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -59,7 +59,7 @@ static inline void *kmap(struct page *page)
        return page_address(page);
 }
=20
-#define kmap_prot(page, prot)  kmap(page)
+#define __kmap_prot(page, prot)        kmap(page)
=20
 static inline void kunmap(struct page *page)
 {
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index efe4b33..3d5231f 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,6 +26,7 @@
=20
 #include <linux/errno.h>
 #include <linux/rbtree.h>
+#include <linux/wait.h>
=20
 struct vm_area_struct;
 struct mm_struct;

--Sig_/cq0ZRXcIpeT5GqH6d+g0XAr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEP6NQACgkQHyuj/+TTEp3PeACdH4pds5Yvx4RpHVU8Bd0GZCit
hxQAoJMkFQ9jkWmWSXoLFLt7SjBO7T0D
=qYYN
-----END PGP SIGNATURE-----

--Sig_/cq0ZRXcIpeT5GqH6d+g0XAr--
