Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3HDO4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:56:55 -0400
Received: from smtp.citrix.com ([66.165.176.89]:20536 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab3HDO4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:56:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,812,1367971200"; 
   d="scan'208";a="41260153"
Date: Sun, 4 Aug 2013 15:56:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v1] p2m: use GNTTABOP_unmap_and_duplicate if available
In-Reply-To: <1375357597-6186-1-git-send-email-roger.pau@citrix.com>
Message-ID: <alpine.DEB.2.02.1308041552360.4893@kaball.uk.xensource.com>
References: <1375357597-6186-1-git-send-email-roger.pau@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="1342847746-706804235-1375628197=:4893"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1342847746-706804235-1375628197=:4893
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 1 Aug 2013, Roger Pau Monne wrote:
> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
> code without requiring the use of a multicall.
>=20
> Signed-off-by: Roger Pau Monn=C3=A9 <roger.pau@citrix.com>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>

It looks pretty good overall.


> Changes since RFC:
>  * Move shared code between _single and _batch to helper
>    functions.
> ---
> I don't currently have a NFS server (the one I had is currently not
> working due to SD card corruption) and I cannot set up one right now,
> so I've only tested this with a raw image stored in a local disk.
> ---
>  arch/x86/include/asm/xen/page.h     |    4 +-
>  arch/x86/xen/p2m.c                  |  154 +++++++++++++++++++++++++++++=
++----
>  drivers/xen/grant-table.c           |   24 ++----
>  include/xen/interface/grant_table.h |   22 +++++
>  4 files changed, 169 insertions(+), 35 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/p=
age.h
> index 6aef9fb..ea1dce6 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -51,8 +51,8 @@ extern unsigned long set_phys_range_identity(unsigned l=
ong pfn_s,
> =20
>  extern int m2p_add_override(unsigned long mfn, struct page *page,
>  =09=09=09    struct gnttab_map_grant_ref *kmap_op);
> -extern int m2p_remove_override(struct page *page,
> -=09=09=09=09struct gnttab_map_grant_ref *kmap_op);
> +extern int m2p_remove_override(struct page **pages,
> +=09=09=09=09struct gnttab_map_grant_ref *kmap_ops, int count);
>  extern struct page *m2p_find_override(unsigned long mfn);
>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned l=
ong pfn);
> =20
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 0d4ec35..e92636c 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -154,6 +154,8 @@
>  #include <linux/hash.h>
>  #include <linux/sched.h>
>  #include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/hardirq.h>
> =20
>  #include <asm/cache.h>
>  #include <asm/setup.h>
> @@ -853,6 +855,7 @@ bool set_phys_to_machine(unsigned long pfn, unsigned =
long mfn)
> =20
>  static RESERVE_BRK_ARRAY(struct list_head, m2p_overrides, M2P_OVERRIDE_H=
ASH);
>  static DEFINE_SPINLOCK(m2p_override_lock);
> +extern bool gnttab_supports_duplicate;

If you only use gnttab_supports_duplicate in the m2p, you might as well
make the variable static and initialize it from m2p_override_init.


>  static void __init m2p_override_init(void)
>  {
> @@ -933,8 +936,8 @@ int m2p_add_override(unsigned long mfn, struct page *=
page,
>  =09return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_add_override);
> -int m2p_remove_override(struct page *page,
> -=09=09struct gnttab_map_grant_ref *kmap_op)
> +
> +static inline int remove_page_override(struct page *page)
>  {
>  =09unsigned long flags;
>  =09unsigned long mfn;
> @@ -965,6 +968,49 @@ int m2p_remove_override(struct page *page,
>  =09ClearPagePrivate(page);
> =20
>  =09set_phys_to_machine(pfn, page->index);
> +
> +=09return 0;
> +}
> +
> +static inline int check_duplicate_mfn(struct page *page, unsigned long m=
fn)
> +{
> +=09unsigned long pfn;
> +=09int ret =3D 0;
> +
> +=09/*
> +=09 * p2m(m2p(mfn)) =3D=3D FOREIGN_FRAME(mfn): the mfn is already presen=
t
> +=09 * somewhere in this domain, even before being added to the
> +=09 * m2p_override (see comment above in m2p_add_override).
> +=09 * If there are no other entries in the m2p_override corresponding
> +=09 * to this mfn, then remove the FOREIGN_FRAME_BIT from the p2m for
> +=09 * the original pfn (the one shared by the frontend): the backend
> +=09 * cannot do any IO on this page anymore because it has been
> +=09 * unshared. Removing the FOREIGN_FRAME_BIT from the p2m entry of
> +=09 * the original pfn causes mfn_to_pfn(mfn) to return the frontend
> +=09 * pfn again.
> +=09 */
> +=09mfn &=3D ~FOREIGN_FRAME_BIT;
> +=09ret =3D __get_user(pfn, &machine_to_phys_mapping[mfn]);
> +=09if (ret =3D=3D 0 && get_phys_to_machine(pfn) =3D=3D FOREIGN_FRAME(mfn=
) &&
> +=09=09=09m2p_find_override(mfn) =3D=3D NULL)
> +=09=09set_phys_to_machine(pfn, mfn);
> +
> +=09return ret;
> +}

There is no need to keep check_duplicate_mfn separate from
remove_page_override, you can just "append" this code at the end of
remove_page_override.
--1342847746-706804235-1375628197=:4893--
