Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaACOuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:50:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:62900 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaACOuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:50:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="89550944"
Date: Fri, 3 Jan 2014 14:49:54 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mark Salter <msalter@redhat.com>, <catalin.marinas@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Chen Baozi <baozich@gmail.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
In-Reply-To: <20140103143104.GN7383@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1401031444550.8667@kaball.uk.xensource.com>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <1388431259.2564.15.camel@deneb.redhat.com> <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com> <20140103143104.GN7383@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Russell King - ARM Linux wrote:
> On Fri, Jan 03, 2014 at 01:13:57PM +0000, Stefano Stabellini wrote:
> > On Mon, 30 Dec 2013, Mark Salter wrote:
> > > On Mon, 2013-12-30 at 14:55 +0800, Chen Baozi wrote:
> > > > xen_remap used to be defined as ioremap_cached on arm64. In commit
> > > > c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> > > > was deleted, while xen_remap stays the same. This would lead to
> > > > the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> > > > on arm64 as ioremap_cache on arm64 to fix it.
> > > > 
> > > 
> > > I missed that include of arm header by arm64 when looking for users
> > > of arm64's ioremap_cached() when working on commit c04e8e2fe. Anyway,
> > > grepping the kernel tree, I see:
> > > 
> > >   ioremap_cached()
> > >     defined by: arm, metag, unicore32
> > >     used by: arch/arm/include/asm/xen/page.h
> > >              drivers/mtd/maps/pxa2xx-flash.c
> > > 
> > >   ioremap_cache()
> > >     defined by: arm64, sh, xtensa, ia64, x86
> > >     used by: drivers/video/vesafb.c
> > >              drivers/char/toshiba.c
> > >              drivers/acpi/apei
> > >              drivers/lguest/lguest_device.c
> > >              drivers/sfi/sfi_core.c
> > >              include/linux/acpi_io.h
> > > 
> > > I think it would be better to just avoid the confusion and the ifdef in
> > > asm/xen/page.h by globally changing ioremap_cached to ioremap_cache.
> > 
> > While I welcome the suggestion, this is a critical fix for a regression
> > that I think should go in as soon as possible, maybe 3.13-rc7, while I
> > don't think that a global s/ioremap_cached/ioremap_cache would be
> > acceptable at this stage.
> 
> Since it's just one driver, just make the change for ARM (provided the
> grep is accurate.)  pxa2xx-flash is only used on ARM and not the other
> two listed there, so looks like metag and unicore just decided to copy
> ARM.
> 
> My grep concurs with yours.
> 
> So... just change ioremap_cached -> ioremap_cache in
> arch/arm/include/asm/io.h
> arch/arm/include/asm/xen/page.h
> drivers/mtd/maps/pxa2xx-flash.c
> 
> to fix the problem.

OK. That would be Rob's patch below.
Are you going to take care of sending it to Linus?

Thanks for the quick reply.


>From robherring2@gmail.com Fri Nov  8 21:26:03 2013
Date: Fri, 8 Nov 2013 15:25:56 -0600
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>, Russell King <linux@arm.linux.org.uk>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH] ARM: rename ioremap_cached to ioremap_cache

From: Rob Herring <rob.herring@calxeda.com>

ioremap_cache is more aligned with other architectures. There are only
2 users of this in the kernel: pxa2xx-flash and Xen.

This fixes Xen build failures on arm64:

drivers/tty/hvc/hvc_xen.c:233:2: error: implicit declaration of function 'ioremap_cached' [-Werror=implicit-function-declaration]
drivers/xen/grant-table.c:1174:3: error: implicit declaration of function 'ioremap_cached' [-Werror=implicit-function-declaration]
drivers/xen/xenbus/xenbus_probe.c:778:4: error: implicit declaration of function 'ioremap_cached' [-Werror=implicit-function-declaration]

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/io.h       | 2 +-
 arch/arm/include/asm/xen/page.h | 2 +-
 drivers/mtd/maps/pxa2xx-flash.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 3c597c2..fbeb39c 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -329,7 +329,7 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
  */
 #define ioremap(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE)
 #define ioremap_nocache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE)
-#define ioremap_cached(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE_CACHED)
+#define ioremap_cache(cookie,size)	__arm_ioremap((cookie), (size), MT_DEVICE_CACHED)
 #define ioremap_wc(cookie,size)		__arm_ioremap((cookie), (size), MT_DEVICE_WC)
 #define iounmap				__arm_iounmap
 
diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 5d0e4c5..a8591fb 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -123,6 +123,6 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	return __set_phys_to_machine(pfn, mfn);
 }
 
-#define xen_remap(cookie, size) ioremap_cached((cookie), (size));
+#define xen_remap(cookie, size) ioremap_cache((cookie), (size));
 
 #endif /* _ASM_ARM_XEN_PAGE_H */
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index d210d13..0f55589 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -73,7 +73,7 @@ static int pxa2xx_flash_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->map.cached =
-		ioremap_cached(info->map.phys, info->map.size);
+		ioremap_cache(info->map.phys, info->map.size);
 	if (!info->map.cached)
 		printk(KERN_WARNING "Failed to ioremap cached %s\n",
 		       info->map.name);
-- 
1.8.1.2
