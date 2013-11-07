Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3KGISV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:18:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29994 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3KGISM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:18:12 -0500
Date: Thu, 7 Nov 2013 11:17:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Bill Pemberton <wfp5p@virginia.edu>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/2] resources: clean up pnp_irq() error return
Message-ID: <20131107081748.GU21844@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_irq() returns -1 on error but cast to an unsigned.  It is confusing
for callers who assume that it returns a negative value.  I have
introduced a new define IORESOURCE_INVALID which is the same value but
hopefully it looks less like a negative value.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 89b7c24..fdccfa5 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -55,6 +55,8 @@ struct resource {
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
 
+#define IORESOURCE_INVALID	((resource_size_t)-1)
+
 /* PnP IRQ specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_IRQ_HIGHEDGE		(1<<0)
 #define IORESOURCE_IRQ_LOWEDGE		(1<<1)
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 195aafc..818669c 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -151,7 +151,7 @@ static inline resource_size_t pnp_irq(struct pnp_dev *dev, unsigned int bar)
 
 	if (pnp_resource_valid(res))
 		return res->start;
-	return -1;
+	return IORESOURCE_INVALID;
 }
 
 static inline unsigned long pnp_irq_flags(struct pnp_dev *dev, unsigned int bar)
