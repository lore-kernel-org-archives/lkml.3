Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617Ab3FSKsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:48:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62735 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab3FSKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:48:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        gregkh@linuxfoundation.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] FMC: add needed headers
Date: Wed, 19 Jun 2013 12:49:30 +0200
Message-ID: <2530586.aQgWYlUvJa@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
References: <cover.1371018406.git.rubini@gnudd.com> <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+2I/Ia72Zvv2SNzOrwWCh06VcGvV/v7Zi1hjm9Vv220
 R91vzkrzI7QmamsBkhsKhYSaz1ijXMQvuhJgwvZR4KCTWmqxyq
 AV0cY4onzJjnz8Q0ZH5/R9xxHDHXallQHv4TJ6W8PT19aCPNam
 y/Xv+zlUBHGsk8X9woLDt0x3at1J4Sv00hdbpliyxhnHG6sUKs
 s8Gv2UgA6+4ufy73eHVA6nzbWmgAEDSI2hKBRLAvtW3MSPPT9s
 W+Fh0CLUQEwQ7ry6GDM86Wm0+hHDV7hRjPkAaF+jZpbQzTqugf
 4kaQe+V2HhgCWI6DSO1JK1DQZXAd6tby515Hx/7lyyzv+XvdfC
 hPJcQ2xvo0jBpRhdKY04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 June 2013 09:13:36 Alessandro Rubini wrote:
> + */
> +struct fmc_operations {
> +       uint32_t (*readl)(struct fmc_device *fmc, int offset);
> +       void (*writel)(struct fmc_device *fmc, uint32_t value, int offset);
> +       int (*validate)(struct fmc_device *fmc, struct fmc_driver *drv);
> +       int (*reprogram)(struct fmc_device *f, struct fmc_driver *d, char *gw);
> +       int (*irq_request)(struct fmc_device *fmc, irq_handler_t h,
> +                          char *name, int flags);

8<----
Subject: fmc: avoid readl/writel namespace conflict

The use of the 'readl' and 'writel' identifiers here causes build errors on
architectures where those are macros. This renames the fields to read32/write32
to avoid the problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/fmc/fmc-fakedev.c b/drivers/fmc/fmc-fakedev.c
index bec94ac..941d093 100644
--- a/drivers/fmc/fmc-fakedev.c
+++ b/drivers/fmc/fmc-fakedev.c
@@ -232,8 +232,8 @@ static int ff_validate(struct fmc_device *fmc, struct fmc_driver *drv)
 
 
 static struct fmc_operations ff_fmc_operations = {
-	.readl =		ff_readl,
-	.writel =		ff_writel,
+	.read32 =		ff_readl,
+	.write32 =		ff_writel,
 	.reprogram =		ff_reprogram,
 	.irq_request =		ff_irq_request,
 	.read_ee =		ff_read_ee,
diff --git a/include/linux/fmc.h b/include/linux/fmc.h
index a3c4985..a5f0aa5 100644
--- a/include/linux/fmc.h
+++ b/include/linux/fmc.h
@@ -129,8 +129,8 @@ struct fmc_gpio {
  * the exception.
  */
 struct fmc_operations {
-	uint32_t (*readl)(struct fmc_device *fmc, int offset);
-	void (*writel)(struct fmc_device *fmc, uint32_t value, int offset);
+	uint32_t (*read32)(struct fmc_device *fmc, int offset);
+	void (*write32)(struct fmc_device *fmc, uint32_t value, int offset);
 	int (*validate)(struct fmc_device *fmc, struct fmc_driver *drv);
 	int (*reprogram)(struct fmc_device *f, struct fmc_driver *d, char *gw);
 	int (*irq_request)(struct fmc_device *fmc, irq_handler_t h,
@@ -194,14 +194,14 @@ struct fmc_device {
  */
 static inline uint32_t fmc_readl(struct fmc_device *fmc, int offset)
 {
-	if (unlikely(fmc->op->readl))
-		return fmc->op->readl(fmc, offset);
+	if (unlikely(fmc->op->read32))
+		return fmc->op->read32(fmc, offset);
 	return readl(fmc->fpga_base + offset);
 }
 static inline void fmc_writel(struct fmc_device *fmc, uint32_t val, int off)
 {
-	if (unlikely(fmc->op->writel))
-		fmc->op->writel(fmc, val, off);
+	if (unlikely(fmc->op->write32))
+		fmc->op->write32(fmc, val, off);
 	else
 		writel(val, fmc->fpga_base + off);
 }

