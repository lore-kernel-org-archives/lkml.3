Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaANGRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:17:06 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:43446 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaANGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:17:04 -0500
MIME-Version: 1.0
In-Reply-To: <52D45559.3090504@mleia.com>
References: <1389095509-14357-4-git-send-email-ch.naveen@samsung.com>
 <1389354171-31816-1-git-send-email-ch.naveen@samsung.com> <52D01572.5010509@samsung.com>
 <52D45559.3090504@mleia.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Tue, 14 Jan 2014 11:46:43 +0530
Message-ID: <CAHfPSqAH=+-iHpXEwwik5+mzpN7382FYAMeBPUrQUa7aOyr-1w@mail.gmail.com>
Subject: Re: [PATCH 3/8 v3] crypto:s5p-sss: Add support for SSS module on Exynos
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell Vladimir, Tomasz,

On 14 January 2014 02:36, Vladimir Zapolskiy <vz@mleia.com> wrote:
> Hi Naveen and Tomasz,
>
>
> On 01/10/14 17:44, Tomasz Figa wrote:
>>
>> Hi Naveen,
>>
>> Please see my comments inline.
>>
>> On 10.01.2014 12:42, Naveen Krishna Chatradhi wrote:
>>>
>>> This patch adds new compatible and variant struct to support the SSS
>>> module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
>>> for which
>>> 1. AES register are at an offset of 0x200 and
>>> 2. hash interrupt is not available
>>>
>>> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
>>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>>> CC: David S. Miller <davem@davemloft.net>
>>> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
>>> TO: <linux-crypto@vger.kernel.org>
>>> CC: <linux-samsung-soc@vger.kernel.org>
>>> ---
>>> Changes since v2:
>>> 1. Added variant struct to handle the differences in SSS modules
>>> 2. Changed the compatible strings to exynos4210-secss
>>> 3. Other changes suggested by Tomasz
>>>
>>> .../devicetree/bindings/crypto/samsung-sss.txt | 20 ++++
>>> drivers/crypto/s5p-sss.c | 110 +++++++++++++++-----
>>> 2 files changed, 106 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> index 2f9d7e4..fdc7d8b 100644
>>> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
>>> @@ -8,13 +8,33 @@ The SSS module in S5PV210 SoC supports the following:
>>> -- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
>>> -- PRNG: Pseudo Random Number Generator
>>>
>>> +The SSS module in Exynos4 (Exynos4210) and
>>> +Exynos5 (Exynos5420 and Exynos5250) SoCs
>>> +supports the following also:
>>> +-- ARCFOUR (ARC4)
>>> +-- True Random Number Generator (TRNG)
>>> +-- Secure Key Manager
>>> +
>>> Required properties:
>>>
>>> - compatible : Should contain entries for this and backward compatible
>>> SSS versions:
>>> - "samsung,s5pv210-secss" for S5PV210 SoC.
>>> + - "samsung,exynos4210-secss" for Exynos4210, Exynos5250 and
>>> Exynos5420 SoCs.
>>
>>
>> You can also add Exynos4212/4412 to the list.
>>
>>> - reg : Offset and length of the register set for the module
>>> - interrupts : the interrupt-specifier for the SSS module.
>>> Two interrupts "feed control and hash" in case of S5PV210
>>> + One interrupts "feed control" in case of Exynos4210,
>>> + Exynos5250 and Exynos5420 SoCs.
>>
>>
>> You can refer to compatible string here instead of listing all the SoCs.
>>
>>> - clocks : the required gating clock for the SSS module.
>>> - clock-names : the gating clock name to be requested in the SSS driver.
>>
>>
>> Again, please specify name of the clock in property description. The
>> proper description for both clock properties should be:
>>
>> - clock-names : list of device clock input names; should contain one
>> entry - "secss".
>> - clocks : list of clock phandle and specifier pairs for all clocks
>> listed in clock-names property.
>>
>>> +
>>> +Example:
>>> + /* SSS_VER_5 */
>>> + sss@10830000 {
>>> + compatible = "samsung,exynos4210-secss";
>>> + reg = <0x10830000 0x10000>;
>>> + interrupts = <0 112 0>;
>>> + clocks = <&clock 471>;
>>> + clock-names = "secss";
>>> + };
>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>> index 2da5617..f274f5f 100644
>>> --- a/drivers/crypto/s5p-sss.c
>>> +++ b/drivers/crypto/s5p-sss.c
>>> @@ -106,7 +106,7 @@
>>> #define SSS_REG_FCPKDMAO 0x005C
>>>
>>> /* AES registers */
>>> -#define SSS_REG_AES_CONTROL 0x4000
>>> +#define SSS_REG_AES_CONTROL 0x00
>>> #define SSS_AES_BYTESWAP_DI _BIT(11)
>>> #define SSS_AES_BYTESWAP_DO _BIT(10)
>>> #define SSS_AES_BYTESWAP_IV _BIT(9)
>>> @@ -122,21 +122,26 @@
>>> #define SSS_AES_CHAIN_MODE_CTR _SBF(1, 0x02)
>>> #define SSS_AES_MODE_DECRYPT _BIT(0)
>>>
>>> -#define SSS_REG_AES_STATUS 0x4004
>>> +#define SSS_REG_AES_STATUS 0x04
>>> #define SSS_AES_BUSY _BIT(2)
>>> #define SSS_AES_INPUT_READY _BIT(1)
>>> #define SSS_AES_OUTPUT_READY _BIT(0)
>>>
>>> -#define SSS_REG_AES_IN_DATA(s) (0x4010 + (s << 2))
>>> -#define SSS_REG_AES_OUT_DATA(s) (0x4020 + (s << 2))
>>> -#define SSS_REG_AES_IV_DATA(s) (0x4030 + (s << 2))
>>> -#define SSS_REG_AES_CNT_DATA(s) (0x4040 + (s << 2))
>>> -#define SSS_REG_AES_KEY_DATA(s) (0x4080 + (s << 2))
>>> +#define SSS_REG_AES_IN_DATA(off, s) ((off + 0x10) + (s << 2))
>>> +#define SSS_REG_AES_OUT_DATA(off, s) ((off + 0x20) + (s << 2))
>>> +#define SSS_REG_AES_IV_DATA(off, s) ((off + 0x30) + (s << 2))
>>> +#define SSS_REG_AES_CNT_DATA(off, s) ((off + 0x40) + (s << 2))
>>> +#define SSS_REG_AES_KEY_DATA(off, s) ((off + 0x80) + (s << 2))
>>
>>
>> I still somehow don't like this. Such macros are only hiding operations
>> performed by the driver. See my comment below, in the code that
>> references them, to see my proposal.
>>
>>>
>>> #define SSS_REG(dev, reg) ((dev)->ioaddr + (SSS_REG_##reg))
>>> #define SSS_READ(dev, reg) __raw_readl(SSS_REG(dev, reg))
>>> #define SSS_WRITE(dev, reg, val) __raw_writel((val), SSS_REG(dev, reg))
>>>
>>> +#define SSS_AES_REG(dev, reg) ((dev)->ioaddr + SSS_REG_##reg + \
>>> + dev->variant->aes_offset)
>>> +#define SSS_AES_WRITE(dev, reg, val) __raw_writel((val), \
>>> + SSS_AES_REG(dev, reg))
>>> +
>>> /* HW engine modes */
>>> #define FLAGS_AES_DECRYPT _BIT(0)
>>> #define FLAGS_AES_MODE_MASK _SBF(1, 0x03)
>>> @@ -146,6 +151,20 @@
>>> #define AES_KEY_LEN 16
>>> #define CRYPTO_QUEUE_LEN 1
>>>
>>> +/**
>>> + * struct samsung_aes_variant - platform specific SSS driver data
>>> + * @has_hash_irq: true if SSS module uses hash interrupt, false
>>> otherwise
>>> + * @aes_offset: AES register offset from SSS module's base.
>>> + *
>>> + * Specifies platform specific configuration of SSS module.
>>> + * Note: A structure for driver specific platform data is used for
>>> future
>>> + * expansion of its usage.
>>> + */
>>> +struct samsung_aes_variant {
>>> + bool has_hash_irq;
>>> + unsigned int aes_offset;
>>> +};
>>> +
>>> struct s5p_aes_reqctx {
>>> unsigned long mode;
>>> };
>>> @@ -174,16 +193,48 @@ struct s5p_aes_dev {
>>> struct crypto_queue queue;
>>> bool busy;
>>> spinlock_t lock;
>>> +
>>> + struct samsung_aes_variant *variant;
>>> };
>>>
>>> static struct s5p_aes_dev *s5p_dev;
>>>
>>> +static const struct samsung_aes_variant s5p_aes_data = {
>>> + .has_hash_irq = true,
>>> + .aes_offset = 0x4000,
>>> +};
>>> +
>>> +static const struct samsung_aes_variant exynos_aes_data = {
>>> + .has_hash_irq = false,
>>> + .aes_offset = 0x200,
>>> +};
>>> +
>>> static const struct of_device_id s5p_sss_dt_match[] = {
>>> - { .compatible = "samsung,s5pv210-secss", },
>>> + {
>>> + .compatible = "samsung,s5pv210-secss",
>>> + .data = &s5p_aes_data,
>>> + },
>>> + {
>>> + .compatible = "samsung,exynos4210-secss",
>>> + .data = &exynos_aes_data,
>>> + },
>>> { },
>>> };
>>> MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
>>>
>>> +static inline struct samsung_aes_variant *find_s5p_sss_version
>>> + (struct platform_device *pdev)
>>> +{
>>> + if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
>>> + const struct of_device_id *match;
>>> + match = of_match_node(s5p_sss_dt_match,
>>> + pdev->dev.of_node);
>>> + return (struct samsung_aes_variant *)match->data;
>>> + }
>>> + return (struct samsung_aes_variant *)
>>> + platform_get_device_id(pdev)->driver_data;
>>> +}
>>> +
>>> static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct
>>> scatterlist *sg)
>>> {
>>> SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
>>> @@ -327,16 +378,21 @@ static irqreturn_t s5p_aes_interrupt(int irq,
>>> void *dev_id)
>>> static void s5p_set_aes(struct s5p_aes_dev *dev,
>>> uint8_t *key, uint8_t *iv, unsigned int keylen)
>>> {
>>> + struct samsung_aes_variant *var = dev->variant;
>>> void __iomem *keystart;
>>>
>>> - memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
>>> + memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
>>> + (var->aes_offset, 0), iv, 0x10);
>>
>>
>> What about adding aes_ioaddr to s5p_aes_dev struct? Then you could
>> access the registers as follows:
>>
>> memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
>>
>> The registers would be defined as offsets of AES base, e.g:
>>
>> #define SSS_REG_AES_IV_DATA(s) (0x10 + (s << 2))
>
>
> I agree, this variant is more preferable.
Sure will implement it.
>
>
>>>
>>> if (keylen == AES_KEYSIZE_256)
>>> - keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(0);
>>> + keystart = dev->ioaddr +
>>> + SSS_REG_AES_KEY_DATA(var->aes_offset, 0);
>>> else if (keylen == AES_KEYSIZE_192)
>>> - keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(2);
>>> + keystart = dev->ioaddr +
>>> + SSS_REG_AES_KEY_DATA(var->aes_offset, 2);
>>> else
>>> - keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(4);
>>> + keystart = dev->ioaddr +
>>> + SSS_REG_AES_KEY_DATA(var->aes_offset, 4);
>>>
>>> memcpy(keystart, key, keylen);
>>> }
>>> @@ -386,7 +442,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev
>>> *dev, unsigned long mode)
>>> if (err)
>>> goto outdata_error;
>>>
>>> - SSS_WRITE(dev, AES_CONTROL, aes_control);
>>> + SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
>>
>>
>> SSS_AES_WRITE would be define using dev->aes_ioaddr instead of
>> dev->ioaddr.
>>
>> Otherwise the patch looks fine.
>>
>
> Same to me.
Thanks for the review, Will implement these changes tomorrow.
>
> With best wishes,
> Vladimir



-- 
Shine bright,
(: Nav :)
