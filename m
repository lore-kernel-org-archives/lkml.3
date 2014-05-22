Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaEVP2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:28:25 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55625 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaEVP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:28:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Thu, 22 May 2014 17:28 +0200
Message-ID: <7774492.yVryDeoI4M@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400771396-9686-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-4-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BdYqjquNmnCtXHy7i8TlFxhV4VmS+McySSso5cgMMkJ
 81qG5Fd5JKs6BPS5LFT7njDctVrrZte5kjQSIAwornTZ911rBe
 EMphy/pc0kj0MVFhGL2npas2XnXhNbK9BR0+11+RKpAgAxqiCo
 y2OCm+iXMANLuXVnLUg8T0do+BHhcWYcDCAmy7M1felpth9+5b
 lFyBZ2hzytPp6KBPTVIdJJO7Oi7uTLi1Qo16NyNyPH5QhCn6Ih
 6kVIhpCXGyDwXDx6qNoJApaEnmoTJet/5uCHiyb/urjaCMDUmV
 +OJs+BvqIGkF4uWiHjDdsZ0Bb3YHAeZi9S0DV7wD13OQscVLBN
 vqWZpMptDf1CWE1Mfh24=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014 17:09:56 LABBE Corentin wrote:
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig    |   49 ++
>  drivers/crypto/Makefile   |    1 +
>  drivers/crypto/sunxi-ss.c | 1476 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1526 insertions(+)
>  create mode 100644 drivers/crypto/sunxi-ss.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 03ccdb0..5ea0922 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -418,4 +418,53 @@ config CRYPTO_DEV_MXS_DCP
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called mxs-dcp.
>  
> +config CRYPTO_DEV_SUNXI_SS
> +        tristate "Support for Allwinner Security System cryptographic accelerator"
> +        depends on ARCH_SUNXI
> +        help
> +          Some Allwinner processors have a crypto accelerator named
> +          Security System. Select this if you want to use it.
> +
> +          To compile this driver as a module, choose M here: the module
> +          will be called sunxi-ss.
> +
> +if CRYPTO_DEV_SUNXI_SS
> +config CRYPTO_DEV_SUNXI_SS_PRNG
> +	bool "Security System PRNG"
> +	select CRYPTO_RNG2
> +	help
> +	  If you enable this option, the SS will provide a pseudo random
> +	  number generator.
> +config CRYPTO_DEV_SUNXI_SS_MD5
> +	bool "Security System MD5"
> +	select CRYPTO_MD5
> +	help
> +	  If you enable this option, the SS will provide MD5 hardware
> +	  acceleration.

My feeling is that this should either be one driver that provides
all five algorithms unconditionally, or five drivers that are each
separate loadable modules and based on top of a common module
that only exports functions but has no active logic itself

> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
> +#include <crypto/md5.h>
> +#define SUNXI_SS_HASH_COMMON
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1
> +#include <crypto/sha.h>
> +#define SUNXI_SS_HASH_COMMON
> +#endif
> +#ifdef SUNXI_SS_HASH_COMMON
> +#include <crypto/hash.h>
> +#include <crypto/internal/hash.h>
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_AES
> +#include <crypto/aes.h>
> +#endif
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_3DES
> +#define SUNXI_SS_DES
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_DES
> +#define SUNXI_SS_DES
> +#endif
> +#ifdef SUNXI_SS_DES
> +#include <crypto/des.h>
> +#endif
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
> +#include <crypto/internal/rng.h>

That would cleanup this #ifdef chain either way.

> +/* General notes:
> + * I cannot use a key/IV cache because each time one of these change ALL stuff
> + * need to be re-writed.
> + * And for example, with dm-crypt IV changes on each request.
> + *
> + * After each request the device must be disabled.
> + *
> + * For performance reason, we use writel_relaxed/read_relaxed for all
> + * operations on RX and TX FIFO.
> + * For all other registers, we use writel.
> + * See http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117644
> + * and http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117640
> + * */
> +
> +static struct sunxi_ss_ctx {
> +	void *base;

__iomem ?

> +	int irq;
> +	struct clk *busclk;
> +	struct clk *ssclk;
> +	struct device *dev;
> +	struct resource *res;
> +	void *buf_in; /* pointer to data to be uploaded to the device */
> +	size_t buf_in_size; /* size of buf_in */
> +	void *buf_out;
> +	size_t buf_out_size;
> +} _ss_ctx, *ss_ctx = &_ss_ctx;
> +
> +static DEFINE_MUTEX(lock);
> +static DEFINE_MUTEX(bufout_lock);
> +static DEFINE_MUTEX(bufin_lock);

I guess the mutexes should be part of sunxi_ss_ctx.

Are you sure you need the global _ss_ctx structure?
Normally you should get a pointer from whoever calls you.

> +struct sunxi_req_ctx {
> +	u8 key[AES_MAX_KEY_SIZE * 8];
> +	u32 keylen;
> +	u32 mode;
> +	u64 byte_count; /* number of bytes "uploaded" to the device */
> +	u32 waitbuf; /* a partial word waiting to be completed and
> +			uploaded to the device */
> +	/* number of bytes to be uploaded in the waitbuf word */
> +	unsigned int nbwait;
> +};
> +
> +#ifdef SUNXI_SS_HASH_COMMON
> +/*============================================================================*/
> +/*============================================================================*/

Please remove all the ======== lines.

> +	/* If we have more than one SG, we cannot use kmap_atomic since
> +	 * we hold the mapping too long*/
> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> +	if (src_addr == NULL) {
> +		dev_err(ss_ctx->dev, "KMAP error for src SG\n");
> +		return -1;
> +	}
> +	dst_addr = kmap(sg_page(out_sg)) + out_sg->offset;
> +	if (dst_addr == NULL) {
> +		kunmap(src_addr);
> +		dev_err(ss_ctx->dev, "KMAP error for dst SG\n");
> +		return -1;
> +	}
> +	src32 = (u32 *)src_addr;
> +	dst32 = (u32 *)dst_addr;
> +	ileft = nbytes / 4;
> +	oleft = nbytes / 4;
> +	sgileft = in_sg->length / 4;
> +	sgoleft = out_sg->length / 4;
> +	do {
> +		tmp = readl_relaxed(ss_ctx->base + SUNXI_SS_FCSR);
> +		rx_cnt = SS_RXFIFO_SPACES(tmp);
> +		tx_cnt = SS_TXFIFO_SPACES(tmp);
> +		todo = min3(rx_cnt, ileft, sgileft);
> +		if (todo > 0) {
> +			ileft -= todo;
> +			sgileft -= todo;
> +		}
> +		while (todo > 0) {
> +			writel_relaxed(*src32++, ss_ctx->base + SS_RXFIFO);
> +			todo--;
> +		}

I wonder if this is meant to be used in combination with a dma engine
rather than accessed with writel/readl.

How does the original driver do it?

	Arnd
