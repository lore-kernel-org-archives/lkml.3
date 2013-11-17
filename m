Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3KQQS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:18:58 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30393 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab3KQQSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:18:53 -0500
X-IronPort-AV: E=Sophos;i="4.93,718,1378857600"; 
   d="scan'208";a="75329173"
Date: Sun, 17 Nov 2013 16:18:29 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        <xen-devel@lists.xenproject.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: xen drivers fail to link on ARM with v3.12-9888-gf63c482
In-Reply-To: <CA+5PVA63LyUB7o0+Z-YS91AUUwvRokHeYq_GJ1i6VE3bj2qQLA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311171616470.4714@kaball.uk.xensource.com>
References: <CA+5PVA7YMMRmFE=T7MOdGNeUiv_4Eu_u2-SrDfSTE052MpAnag@mail.gmail.com> <CA+5PVA63LyUB7o0+Z-YS91AUUwvRokHeYq_GJ1i6VE3bj2qQLA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Nov 2013, Josh Boyer wrote:
> On Sat, Nov 16, 2013 at 9:56 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > Hi All,
> >
> > The xen-gntalloc, xen-netfront, xen-blkfront, and xen-netback drivers
> > fail to link on ARM today with the following error:
> >
> > ERROR: "phys_to_mach" [drivers/xen/xen-gntalloc.ko] undefined!
> > ERROR: "phys_to_mach" [drivers/net/xen-netfront.ko] undefined!
> > ERROR: "phys_to_mach" [drivers/net/xen-netback/xen-netback.ko] undefined!
> > ERROR: "phys_to_mach" [drivers/block/xen-blkfront.ko] undefined!
> >
> > This is with Linus' tree as of this morning.
> >
> > I'm guessing this is because the mfn_to_pfn and pfn_to_mfn functions
> > are inlined and reference phys_to_mach directly, and that isn't
> > exported to modules.  Thoughts?
> 
> The patch below seems to fix this, but I'm not sure it's the desired
> approach.  I added the export for mach_to_phys just in case.
> 

Thank you for letting me know of the problem and thank you for the
patch!


> diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
> index 23732cd..7772fa8 100644
> --- a/arch/arm/xen/p2m.c
> +++ b/arch/arm/xen/p2m.c
> @@ -27,7 +27,9 @@ struct xen_p2m_entry {
> 
>  rwlock_t p2m_lock;
>  struct rb_root phys_to_mach = RB_ROOT;
> +EXPORT_SYMBOL_GPL(phys_to_mach);
>  static struct rb_root mach_to_phys = RB_ROOT;
> +EXPORT_SYMBOL_GPL(mach_to_phys);
> 

The approach is OK but mach_to_phys should not be exported.
Can you please resent the patch only exporting phys_to_mach and with
your signed-off-by line so that I can send it to Linus as soon as
possible?
