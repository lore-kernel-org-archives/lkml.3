Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaK1Jnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:43:50 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:36575 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaK1Jns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:43:48 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <78039072c1c0e2c457b22e0bcfc51de2>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547843B9.6000806@rock-chips.com>
Date: Fri, 28 Nov 2014 17:43:21 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v13 07/12] drm: bridge/dw_hdmi: add support for multi-byte
 register width access
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com>	 <1417008759-32257-1-git-send-email-andy.yan@rock-chips.com> <1417019657.3177.10.camel@pengutronix.de>
In-Reply-To: <1417019657.3177.10.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zabel:
On 2014年11月27日 00:34, Philipp Zabel wrote:
> Am Mittwoch, den 26.11.2014, 21:32 +0800 schrieb Andy Yan:
>> On rockchip rk3288, only word(32-bit) accesses are
>> permitted for hdmi registers.  Byte width accesses (writeb,
>> readb) generate an imprecise external abort.
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>
>> ---
>>
>> Changes in v13: None
>> Changes in v12: None
>> Changes in v11: None
>> Changes in v10: None
>> Changes in v9: None
>> Changes in v8: None
>> Changes in v7: None
>> Changes in v6:
>> - refactor register access without reg_shift
>>
>> Changes in v5:
>> - refactor reg-io-width
>>
>> Changes in v4: None
>> Changes in v3:
>> - split multi-register access to one indepent patch
>>
>>   drivers/gpu/drm/bridge/dw_hdmi.c | 57 +++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 51 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>> index a53bf63..5e88c8d 100644
>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>> @@ -100,6 +100,11 @@ struct hdmi_data_info {
>>   	struct hdmi_vmode video_mode;
>>   };
>>   
>> +union dw_reg_ptr {
>> +	u32 __iomem *p32;
>> +	u8 __iomem *p8;
>> +};
> I see no need to introduce this. Just explicitly multiply the offset in
> dw_hdmi_writel.
>
     Is there any disadvantage to do like this?
     The compiler can help us do the explicitly multiply by this way.
>>   struct dw_hdmi {
>>   	struct drm_connector connector;
>>   	struct drm_encoder *encoder;
>> @@ -121,20 +126,43 @@ struct dw_hdmi {
>>   
>>   	struct regmap *regmap;
>>   	struct i2c_adapter *ddc;
>> -	void __iomem *regs;
>> +	union dw_reg_ptr regs;
> Keep this as void __iomem *
>
>>   	unsigned int sample_rate;
>>   	int ratio;
>> +
>> +	void (*write)(struct dw_hdmi *hdmi, u8 val, int offset);
>> +	u8 (*read)(struct dw_hdmi *hdmi, int offset);
>>   };
>>   
>> +static void dw_hdmi_writel(struct dw_hdmi *hdmi, u8 val, int offset)
>> +{
>> +	writel(val, hdmi->regs.p32 + offset);
> hdmi->regs + 4 * offset
>
>> +}
>> +
>> +static u8 dw_hdmi_readl(struct dw_hdmi *hdmi, int offset)
>> +{
>> +	return readl(hdmi->regs.p32 + offset);
> same here
>
>> +}
>> +
>> +static void dw_hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
>> +{
>> +	writeb(val, hdmi->regs.p8 + offset);
>> +}
>> +
>> +static u8 dw_hdmi_readb(struct dw_hdmi *hdmi, int offset)
>> +{
>> +	return readb(hdmi->regs.p8 + offset);
>> +}
>> +
>>   static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
>>   {
>> -	writeb(val, hdmi->regs + offset);
>> +	hdmi->write(hdmi, val, offset);
>>   }
>>   
>>   static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
>>   {
>> -	return readb(hdmi->regs + offset);
>> +	return hdmi->read(hdmi, offset);
>>   }
>>
>>   static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
>> @@ -1508,6 +1536,7 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
>>   	struct dw_hdmi *hdmi;
>>   	struct resource *iores;
>>   	int ret, irq;
>> +	u32 val = 1;
>>   
>>   	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
>>   	if (!hdmi)
>> @@ -1520,6 +1549,22 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
>>   	hdmi->ratio = 100;
>>   	hdmi->encoder = encoder;
>>   
>> +	of_property_read_u32(np, "reg-io-width", &val);
>> +
>> +	switch (val) {
>> +	case 4:
>> +		hdmi->write = dw_hdmi_writel;
>> +		hdmi->read = dw_hdmi_readl;
>> +		break;
>> +	case 1:
>> +		hdmi->write = dw_hdmi_writeb;
>> +		hdmi->read = dw_hdmi_readb;
>> +		break;
>> +	default:
>> +		dev_err(dev, "reg-io-width must be 1 or 4\n");
>> +		return -EINVAL;
>> +	}
>> +
>>   	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
>>   	if (ddc_node) {
>>   		hdmi->ddc = of_find_i2c_adapter_by_node(ddc_node);
>> @@ -1544,9 +1589,9 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
>>   		return ret;
>>   
>>   	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -	hdmi->regs = devm_ioremap_resource(dev, iores);
>> -	if (IS_ERR(hdmi->regs))
>> -		return PTR_ERR(hdmi->regs);
>> +	hdmi->regs.p32 = devm_ioremap_resource(dev, iores);
>> +	if (IS_ERR(hdmi->regs.p32))
>> +		return PTR_ERR(hdmi->regs.p32);
>>   
>>   	/* Product and revision IDs */
>>   	dev_info(dev,
> regards
> Philipp
>
>
>
>

