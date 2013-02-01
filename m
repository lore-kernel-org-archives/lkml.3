Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3BAWeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:34:06 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55588 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757885Ab3BAWeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:34:02 -0500
Message-ID: <1359758038.17807.18.camel@joe-AO722>
Subject: Re: [PATCH] tile: revert pr_info to printk in <asm/io.h>
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, David Dillow <dillowda@ornl.gov>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Date: Fri, 01 Feb 2013 14:33:58 -0800
In-Reply-To: <201302012043.r11KhFXi024365@farm-0021.internal.tilera.com>
References: <201302012043.r11KhFXi024365@farm-0021.internal.tilera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 12:34 -0500, Chris Metcalf wrote:
> Using pr_info in a header exposes us to potential trouble from
> subsystems that define pr_fmt.  This change fixes:
>
>   In file included from include/linux/scatterlist.h:10,
>                    from include/scsi/scsi.h:12,
>                    from drivers/infiniband/ulp/srp/ib_srp.c:46:
>   arch/tile/include/asm/io.h: In function ‘ioport_map’:
>   arch/tile/include/asm/io.h:296: error: expected ‘)’ before ‘PFX’

Interesting.

> diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
[]
> @@ -292,7 +292,7 @@ static inline long ioport_panic(void)
>  
>  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
>  {
> -	pr_info("ioport_map: mapping IO resources is unsupported on tile.\n");
> +	printk("ioport_map: mapping IO resources is unsupported on tile.\n");

It'd be nicer to add an appropriate KERN_<LEVEL> here.

My preference would be to change ib_srp.c (and ib_srpt) like:
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d5088ce..59bf409 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -30,7 +30,7 @@
  * SOFTWARE.
  */
 
-#define pr_fmt(fmt) PFX fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/init.h>



