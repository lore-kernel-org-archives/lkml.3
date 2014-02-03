Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaBCIrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:47:32 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:44858 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaBCIra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:47:30 -0500
Date: Mon, 3 Feb 2014 09:47:25 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        SH-Linux <linux-sh@vger.kernel.org>, devicetree@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: rspi: fix build error when CONFIG_OF is not set
In-Reply-To: <52EEF452.4060205@renesas.com>
Message-ID: <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
References: <52EEF452.4060205@renesas.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Shimoda-san,

On Mon, 3 Feb 2014, Shimoda, Yoshihiro wrote:
> This patch fixes an issue that the following build error happens when
> the CONFIG_OF is not set:
> 
> drivers/spi/spi-rspi.c: In function 'rspi_probe':
> drivers/spi/spi-rspi.c:1203:26: error: 'rspi_of_match' undeclared (first use in this function)
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  This patch is based on the latest origin/topic/rspi branch in the spi.git.
> 
>  drivers/spi/spi-rspi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
> index 34ad4bc..e5cfc3d 100644
> --- a/drivers/spi/spi-rspi.c
> +++ b/drivers/spi/spi-rspi.c
> @@ -1164,6 +1164,7 @@ static int rspi_parse_dt(struct device *dev, struct spi_master *master)
>  	return 0;
>  }
>  #else
> +#define rspi_of_match	NULL
>  static inline int rspi_parse_dt(struct device *dev, struct spi_master *master)
>  {
>  	return -EINVAL;
> -- 
> 1.7.1

Thanks, obviously I missed that of_match_device() still uses the ID table
parameter if CONFIG_OF=n :-(

Below I have two alternative solutions:
  1. Uses rspi_of_match() to nullify the ID table pointer, like is done in
     the platform_driver structure,
  2. Fixes it at the OF subsystem level, by nullifying the ID table pointer
     inside of_match_device().

If 2 is accepted, drivers don't have to care about this anymore.

What do you think?

>From 060b8577e95441ee3b29e966a9fdd19b2a870bdf Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date: Mon, 3 Feb 2014 09:22:06 +0100
Subject: [PATCH 1/2] spi: rspi: fix build error when CONFIG_OF is not set

If CONFIG_OF=n:

drivers/spi/spi-rspi.c: In function 'rspi_probe':
drivers/spi/spi-rspi.c:1203:26: error: 'rspi_of_match' undeclared (first use in this function)
drivers/spi/spi-rspi.c:1203:26: note: each undeclared identifier is reported only once for each function it appears in

Use of_match_ptr() to fix this.

Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi-rspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 1c3aed63a2e0..df637184f6f0 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1200,7 +1200,7 @@ static int rspi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	of_id = of_match_device(rspi_of_match, &pdev->dev);
+	of_id = of_match_device(of_match_ptr(rspi_of_match), &pdev->dev);
 	if (of_id) {
 		ops = of_id->data;
 		ret = rspi_parse_dt(&pdev->dev, master);
-- 
1.7.9.5


>From 477ab825d43524959d68c3974e6e9536bd83bcde Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date: Mon, 3 Feb 2014 09:27:40 +0100
Subject: [PATCH 2/2] [RFC] of/device: Nullify match table in
 of_match_device() for CONFIG_OF=n

If the of_device_id table inside a device driver is protected by #ifdef
CONFIG_OF, the driver still has to provide a dummy declaration of the
table, or wrap it inside of_match_ptr(), when calling of_match_device()
in the CONFIG_OF=n case, else the driver fails to compile with e.g.

drivers/spi/spi-rspi.c: In function 'rspi_probe':
drivers/spi/spi-rspi.c:1203:26: error: 'rspi_of_match' undeclared (first use in this function)
drivers/spi/spi-rspi.c:1203:26: note: each undeclared identifier is reported only once for each function it appears in

Make of_match_device() nullify the table pointer if CONFIG_OF=n to fix
this.

Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 include/linux/of_device.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 82ce324fdce7..dac8bd2890ca 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -72,11 +72,13 @@ static inline int of_device_uevent_modalias(struct device *dev,
 
 static inline void of_device_node_put(struct device *dev) { }
 
-static inline const struct of_device_id *of_match_device(
+static inline const struct of_device_id *__of_match_device(
 		const struct of_device_id *matches, const struct device *dev)
 {
 	return NULL;
 }
+#define of_match_device(matches, dev)	\
+	__of_match_device(of_match_ptr(matches), (dev))
 
 static inline struct device_node *of_cpu_device_node_get(int cpu)
 {
-- 
1.7.9.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
