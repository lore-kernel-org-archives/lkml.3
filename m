Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3KPQgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:36:35 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63818 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3KPQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7YMMRmFE=T7MOdGNeUiv_4Eu_u2-SrDfSTE052MpAnag@mail.gmail.com>
References: <CA+5PVA7YMMRmFE=T7MOdGNeUiv_4Eu_u2-SrDfSTE052MpAnag@mail.gmail.com>
Date: Sat, 16 Nov 2013 11:36:25 -0500
X-Google-Sender-Auth: w9PipDO3MZvP_zXJWLHa2DvUU_E
Message-ID: <CA+5PVA63LyUB7o0+Z-YS91AUUwvRokHeYq_GJ1i6VE3bj2qQLA@mail.gmail.com>
Subject: Re: xen drivers fail to link on ARM with v3.12-9888-gf63c482
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>, xen-devel@lists.xenproject.org,
        linux-arm-kernel@lists.infradead.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 9:56 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> Hi All,
>
> The xen-gntalloc, xen-netfront, xen-blkfront, and xen-netback drivers
> fail to link on ARM today with the following error:
>
> ERROR: "phys_to_mach" [drivers/xen/xen-gntalloc.ko] undefined!
> ERROR: "phys_to_mach" [drivers/net/xen-netfront.ko] undefined!
> ERROR: "phys_to_mach" [drivers/net/xen-netback/xen-netback.ko] undefined!
> ERROR: "phys_to_mach" [drivers/block/xen-blkfront.ko] undefined!
>
> This is with Linus' tree as of this morning.
>
> I'm guessing this is because the mfn_to_pfn and pfn_to_mfn functions
> are inlined and reference phys_to_mach directly, and that isn't
> exported to modules.  Thoughts?

The patch below seems to fix this, but I'm not sure it's the desired
approach.  I added the export for mach_to_phys just in case.

josh

diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
index 23732cd..7772fa8 100644
--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -27,7 +27,9 @@ struct xen_p2m_entry {

 rwlock_t p2m_lock;
 struct rb_root phys_to_mach = RB_ROOT;
+EXPORT_SYMBOL_GPL(phys_to_mach);
 static struct rb_root mach_to_phys = RB_ROOT;
+EXPORT_SYMBOL_GPL(mach_to_phys);

 static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
 {
