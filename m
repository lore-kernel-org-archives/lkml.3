Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaEXRwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:52:00 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49244 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaEXRvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:51:42 -0400
X-Auth-Info: xr6pmiN/vBLpyH5cgAja1NcU3MHS8rAookWjaxq9Nug=
From: Marek Vasut <marex@denx.de>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Sat, 24 May 2014 14:00:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-4-git-send-email-clabbe.montjoie@gmail.com>
In-Reply-To: <1400771396-9686-4-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201405241400.03456.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2014 at 05:09:56 PM, LABBE Corentin wrote:

Do I have to repeat myself ? :)

> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/Kconfig    |   49 ++
>  drivers/crypto/Makefile   |    1 +
>  drivers/crypto/sunxi-ss.c | 1476
> +++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 1526
> insertions(+)
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
> +        tristate "Support for Allwinner Security System cryptographic
> accelerator" +        depends on ARCH_SUNXI
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

This is one IP block and it provides 5 algorithms. Put it under one config 
option please.

Also, just shorted this to CONFIG_CRYPTO_SUNXI_SS , the _DEV stuff in the name 
is useless.

[...]

> diff --git a/drivers/crypto/sunxi-ss.c b/drivers/crypto/sunxi-ss.c
> new file mode 100644
> index 0000000..bbf57bc
> --- /dev/null
> +++ b/drivers/crypto/sunxi-ss.c
> @@ -0,0 +1,1476 @@
> +/*
> + * sunxi-ss.c - hardware cryptographic accelerator for Allwinner A20 SoC

Why can this not be generic Allwinner-all-chips driver ? Does the IP block 
change that dramatically between the chips?

[...]

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

Please discard this mayhem when getting rid of all the configuration option.

> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
> +#include <crypto/internal/rng.h>
> +
> +struct prng_context {
> +	u8 seed[192/8];
> +	unsigned int slen;
> +};
> +#endif
> +
> +#define SUNXI_SS_CTL            0x00
> +#define SUNXI_SS_KEY0           0x04
> +#define SUNXI_SS_KEY1           0x08
> +#define SUNXI_SS_KEY2           0x0C
> +#define SUNXI_SS_KEY3           0x10
> +#define SUNXI_SS_KEY4           0x14
> +#define SUNXI_SS_KEY5           0x18
> +#define SUNXI_SS_KEY6           0x1C
> +#define SUNXI_SS_KEY7           0x20
> +
> +#define SUNXI_SS_IV0            0x24
> +#define SUNXI_SS_IV1            0x28
> +#define SUNXI_SS_IV2            0x2C
> +#define SUNXI_SS_IV3            0x30
> +
> +#define SUNXI_SS_CNT0           0x34
> +#define SUNXI_SS_CNT1           0x38
> +#define SUNXI_SS_CNT2           0x3C
> +#define SUNXI_SS_CNT3           0x40
> +
> +#define SUNXI_SS_FCSR           0x44
> +#define SUNXI_SS_ICSR           0x48
> +
> +#define SUNXI_SS_MD0            0x4C
> +#define SUNXI_SS_MD1            0x50
> +#define SUNXI_SS_MD2            0x54
> +#define SUNXI_SS_MD3            0x58
> +#define SUNXI_SS_MD4            0x5C
> +
> +#define SS_RXFIFO         0x200
> +#define SS_TXFIFO         0x204

You don't have much consistency in the register naming scheme, please fix this 
somehow. I suppose renaming the SS_[RT]XFIFO registers to SUNXI_SS_[RT]XFIFO is 
a good idea.

> +/* SUNXI_SS_CTL configuration values */
> +
> +/* AES/DES/3DES key select - bits 24-27 */
> +#define SUNXI_SS_KEYSELECT_KEYN		(0 << 24)

Uh oh , you ORR some values with this flag, which is always zero. This seems 
broken.

[...]

> +/* SS Method - bits 4-6 */
> +#define SUNXI_OP_AES                    (0 << 4)
> +#define SUNXI_OP_DES                    (1 << 4)
> +#define SUNXI_OP_3DES                   (2 << 4)
> +#define SUNXI_OP_SHA1                   (3 << 4)
> +#define SUNXI_OP_MD5                    (4 << 4)
> +#define SUNXI_OP_PRNG                   (5 << 4)
> +
> +/* Data end bit - bit 2 */
> +#define SUNXI_SS_DATA_END               BIT(2)

Please use the BIT() macros in consistent fashion. Either use it or don't use it 
(I'd much rather see it not used), but don't mix the stuff :-(

[...]

> +/* General notes:
> + * I cannot use a key/IV cache because each time one of these change ALL
> stuff + * need to be re-writed.
> + * And for example, with dm-crypt IV changes on each request.
> + *
> + * After each request the device must be disabled.

This really isn't quite clear, can you please expand the comment so it's more 
understandtable ?

> + * For performance reason, we use writel_relaxed/read_relaxed for all
> + * operations on RX and TX FIFO.
> + * For all other registers, we use writel.
> + * See http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117644
> + * and http://permalink.gmane.org/gmane.linux.ports.arm.kernel/117640
> + * */

I will not review the algos, they need to be AHASH/ABLKCIPHER algos. See the 
reasoning further down below.

[...]

> +/*========================================================================
> ====*/
> +/*=======================================================================
> =====*/ +static struct crypto_alg sunxi_des3_alg = {
> +	.cra_name = "cbc(des3_ede)",
> +	.cra_driver_name = "cbc-des3-sunxi-ss",
> +	.cra_priority = 300,
> +	.cra_blocksize = DES3_EDE_BLOCK_SIZE,
> +	.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER,

This must be rewritten to be ABLKCIPHER.

> +	.cra_ctxsize = sizeof(struct sunxi_req_ctx),
> +	.cra_module = THIS_MODULE,
> +	.cra_type = &crypto_blkcipher_type,
> +	.cra_init = sunxi_des_init,
> +	.cra_exit = sunxi_des_exit,
> +	.cra_alignmask = 3,
> +	.cra_u.blkcipher = {
> +		.min_keysize    = DES3_EDE_KEY_SIZE,
> +		.max_keysize    = DES3_EDE_KEY_SIZE,
> +		.ivsize         = 8,
> +		.setkey         = sunxi_des3_setkey,
> +		.encrypt        = sunxi_des3_cbc_encrypt,
> +		.decrypt        = sunxi_des3_cbc_decrypt,
> +	}
> +};
> +
> +#endif /* CONFIG_CRYPTO_DEV_SUNXI_SS_3DES */
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
> +/*========================================================================
> ====*/
> +/*=======================================================================
> =====*/ +static int sunxi_ss_rng_get_random(struct crypto_rng *tfm, u8
> *rdata, +		unsigned int dlen)
> +{
> +	struct prng_context *ctx = crypto_tfm_ctx((struct crypto_tfm *)tfm);

Use crypto_rng_ctx() here . The cast is plain wrong. I know it works due to how 
the structures are defined, but this is not right.

> +	unsigned int i;
> +	u32 mode = 0;
> +	u32 v;
> +
> +	dev_dbg(ss_ctx->dev, "DEBUG %s dlen=%u\n", __func__, dlen);
> +
> +	if (dlen == 0 || rdata == NULL)
> +		return 0;

Return -EINVAL or somesuch here, no?

> +	mode |= SUNXI_OP_PRNG;
> +	mode |= SUNXI_PRNG_ONESHOT;
> +	mode |= SUNXI_SS_ENABLED;
> +
> +	mutex_lock(&lock);
> +	writel(mode, ss_ctx->base + SUNXI_SS_CTL);
> +
> +	for (i = 0; i < ctx->slen; i += 4) {
> +		v = *(u32 *)(ctx->seed + i);

Define the .seed field as u32 if you actually want to access it as u32. You are 
very lucky you didn't trigger alignment faults with this yet.

> +		dev_dbg(ss_ctx->dev, "DEBUG Seed %d %x\n", i, v);
> +	}

But this debug instrumentation looks quite useless anyway.

> +	for (i = 0; i < ctx->slen && i < 192/8 && i < 16; i += 4) {
> +		v = *(u32 *)(ctx->seed + i);
> +		dev_dbg(ss_ctx->dev, "DEBUG Seed %d %x\n", i, v);
> +		writel(v, ss_ctx->base + SUNXI_SS_KEY0 + i);
> +	}
> +
> +	mode |= SUNXI_PRNG_START;
> +	writel(mode, ss_ctx->base + SUNXI_SS_CTL);
> +	for (i = 0; i < 4; i++) {
> +		v = readl(ss_ctx->base + SUNXI_SS_CTL);
> +		dev_dbg(ss_ctx->dev, "DEBUG CTL %x %x\n", mode, v);
> +	}
> +	for (i = 0; i < dlen && i < 160 / 8; i += 4) {
> +		v = readl(ss_ctx->base + SUNXI_SS_MD0 + i);
> +		*(u32 *)(rdata + i) = v;
> +		dev_dbg(ss_ctx->dev, "DEBUG MD%d %x\n", i, v);
> +	}

Drop the debug instrumentation and define the seed buffer as u32.

> +	writel(0, ss_ctx->base + SUNXI_SS_CTL);
> +	mutex_unlock(&lock);
> +	return dlen;
> +}
> +
> +/*========================================================================
> ====*/
> +/*=======================================================================
> =====*/ +static int sunxi_ss_rng_reset(struct crypto_rng *tfm, u8 *seed,
> +		unsigned int slen)
> +{
> +	struct prng_context *ctx = crypto_tfm_ctx((struct crypto_tfm *)tfm);

Use crypto_rng_ctx() here . The cast is plain wrong.

> +	dev_dbg(ss_ctx->dev, "DEBUG %s slen=%u\n", __func__, slen);
> +	memcpy(ctx->seed, seed, slen);
> +	ctx->slen = slen;
> +	return 0;
> +}

[...]

> +static int sunxi_ss_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	u32 v;
> +	int err;
> +	unsigned long cr;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	memset(ss_ctx, 0, sizeof(struct sunxi_ss_ctx));

Static data are always zeroed out by default, no ?

If you just so accidentally happen to probe() this driver twice, you will get 
some seriously ugly surprise here, since you zero the data out without checking 
if the device might have already been probed. A much better idea would be to
define a static struct sunxi_ss_ctx *ss_ctx; and then

 if (ss_ctx) {
  dev_err(&pdev->dev, "Only one instance allowed");
  return -ENODEV;
 }
 ss_ctx = devm_kzalloc(&pdev->dev, sizeof(*ss_ctx), GFP_KERNEL);

Also note the use of sizeof(*ss_ctx), this will allow for this line to not be 
changed in case the type of *ss_ctx ever changes in the future. So use it.

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "Cannot get the MMIO ressource\n");
> +		/* TODO PTR_ERR ? */

Fix the TODOs .

> +		return -ENXIO;
> +	}
> +	ss_ctx->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ss_ctx->base)) {
> +		dev_err(&pdev->dev, "Cannot request MMIO\n");
> +		return PTR_ERR(ss_ctx->base);
> +	}

Actually, this is the pattern. You don't need to check for IS_ERR(res) before 
calling devm_ioremap_resource().

res = platform_get_resource();
base = devm_ioremap_resource(&pdev->dev, res)
if (IS_ERR(base))
 return PTR_ERR(base);

> +	/* TODO Does this information could be usefull ? */
> +	writel(SUNXI_SS_ENABLED, ss_ctx->base + SUNXI_SS_CTL);
> +	v = readl(ss_ctx->base + SUNXI_SS_CTL);
> +	v >>= 16;
> +	v &= 0x07;
> +	dev_info(&pdev->dev, "Die ID %d\n", v);
> +	writel(0, ss_ctx->base + SUNXI_SS_CTL);

You are configuring hardware before enabling clock for that hardware. That does 
not seem right.

> +	ss_ctx->ssclk = devm_clk_get(&pdev->dev, "mod");
> +	if (IS_ERR(ss_ctx->ssclk)) {
> +		err = PTR_ERR(ss_ctx->ssclk);
> +		dev_err(&pdev->dev, "Cannot get SS clock err=%d\n", err);
> +		return err;
> +	}
> +	dev_dbg(&pdev->dev, "clock ss acquired\n");
> +
> +	ss_ctx->busclk = devm_clk_get(&pdev->dev, "ahb");
> +	if (IS_ERR(ss_ctx->busclk)) {
> +		err = PTR_ERR(ss_ctx->busclk);
> +		dev_err(&pdev->dev, "Cannot get AHB SS clock err=%d\n", err);
> +		return err;
> +	}
> +	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");

These dev_dbg() aren't really useful.

> +	/* Enable the clocks */
> +	err = clk_prepare_enable(ss_ctx->busclk);
> +	if (err != 0) {
> +		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
> +		return err;
> +	}
> +	err = clk_prepare_enable(ss_ctx->ssclk);
> +	if (err != 0) {
> +		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
> +		clk_disable_unprepare(ss_ctx->busclk);
> +		return err;
> +	}
> +
> +#define	SUNXI_SS_CLOCK_RATE_BUS (24 * 1000 * 1000)
> +#define	SUNXI_SS_CLOCK_RATE_SS (150 * 1000 * 1000)

Make this const unsigned long or somesuch, the define is horrid and not 
typesafe.

> +	/* Check that clock have the correct rates gived in the datasheet */
> +	cr = clk_get_rate(ss_ctx->busclk);
> +	if (cr >= SUNXI_SS_CLOCK_RATE_BUS)
> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %u)\n",
> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
> +	else
> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= 
%u)\n",
> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
> +	cr = clk_get_rate(ss_ctx->ssclk);
> +	if (cr == SUNXI_SS_CLOCK_RATE_SS)
> +		dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %u)\n",
> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_SS);
> +	else {
> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= 
%u)\n",
> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_SS);
> +		/* Try to set the clock to the maximum allowed */
> +		err = clk_set_rate(ss_ctx->ssclk, SUNXI_SS_CLOCK_RATE_SS);
> +		if (err != 0) {
> +			dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
> +			goto label_error_clock;
> +		}
> +		cr = clk_get_rate(ss_ctx->ssclk);
> +		dev_info(&pdev->dev, "Clock ss set to %lu (%lu MHz) (must be >= 
%u)\n",
> +				cr, cr / 1000000, SUNXI_SS_CLOCK_RATE_BUS);
> +	}

Just run clk_set_rate() for both and be done with it.

> +	ss_ctx->buf_in = NULL;
> +	ss_ctx->buf_in_size = 0;
> +	ss_ctx->buf_out = NULL;
> +	ss_ctx->buf_out_size = 0;

This is useless, you already did that with devm_kzalloc() above.

> +	ss_ctx->dev = &pdev->dev;
> +
> +	mutex_init(&lock);
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_PRNG
> +	err = crypto_register_alg(&sunxi_ss_prng);

Use crypto_register_algs() when you get rid of those useless #defines for each 
algo.

> +	if (err) {
> +		dev_err(&pdev->dev, "crypto_register_alg error\n");
> +		goto label_error_prng;
> +	} else {
> +		dev_info(&pdev->dev, "Registred PRNG\n");

This is useless, you can always check that the thing was probed via /proc/crypto 
. Please remove this dev_into().

> +	}
> +#endif
> +
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_MD5
> +	err = crypto_register_shash(&sunxi_md5_alg);

Do not use shash for such device. This is clearly and ahash (and async in 
general) device. The rule of a thumb here is that you use sync algos only for 
devices which have dedicated instructions for computing the transformation. For 
devices which are attached to some kind of bus, you use async algos (ahash etc).

> +	if (err) {
> +		dev_err(&pdev->dev, "Fail to register MD5\n");
> +		goto label_error_md5;
> +	} else {
> +		dev_info(&pdev->dev, "Registred MD5\n");
> +	}
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_SUNXI_SS_SHA1
> +	err = crypto_register_shash(&sunxi_sha1_alg);

DTTO.

I am preparing a document for the crypto API, drop me a PM if you want the 
preliminary version. I don't want to release it until it's more complete as it 
will only produce more confusion throughout the crypto API than there already 
is.

[...]

> +static const struct of_device_id a20ss_crypto_of_match_table[] = {
> +	{ .compatible = "allwinner,sun7i-a20-crypto" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);

If possible, scrub the a20 nonsense.

> +static struct platform_driver sunxi_ss_driver = {
> +	.probe          = sunxi_ss_probe,
> +	.remove         = sunxi_ss_remove,
> +	.driver         = {
> +		.owner          = THIS_MODULE,
> +		.name           = "sunxi-ss",
> +		.of_match_table	= a20ss_crypto_of_match_table,
> +	},
> +};
> +
> +module_platform_driver(sunxi_ss_driver);
> +
> +MODULE_DESCRIPTION("Allwinner Security System crypto accelerator");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");

MODULE_ALIAS is missing I think.

