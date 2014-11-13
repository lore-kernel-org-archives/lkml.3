Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288AbaKMNiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:38:52 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:52918 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaKMNiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:38:50 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <530def2f21456f1ec822366583c6c794>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5464B452.5020700@rock-chips.com>
Date: Thu, 13 Nov 2014 21:38:26 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, djkurtz@google.com,
        ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        jay.xu@rock-chips.com, Pawel Moll <pawel.moll@arm.com>,
        mark.yao@rock-chips.com, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v9 9/9] drm: bridge/dw_hdmi: add rockchip rk3288 support
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com> <1415883434-3754-1-git-send-email-andy.yan@rock-chips.com> <5464AD7A.6050700@imgtec.com>
In-Reply-To: <5464AD7A.6050700@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ZubairLK:
   thanks for your review.
On 2014年11月13日 21:09, Zubair Lutfullah Kakakhel wrote:
>
> On 13/11/14 12:57, Andy Yan wrote:
>> rk3288 hdmi is compatible with Designware hdmi
>>
>> this patch is depend on patch by Mark Yao Add drm
>> driver for Rockchip Socs
>>
>> see https://lkml.org/lkml/2014/10/8/201
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> Signed-off-by: Yakir Yang <ykk@rock-chips.com>
>>
>> ---
>>
>> Changes in v9:
>> - move some phy configuration to platform driver
>>
>> Changes in v8:
>> - add support for rockchip rk3288 hdmi
>>
>> Changes in v7: None
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
>>
>>   drivers/gpu/drm/bridge/dw_hdmi.c            |  45 +++-
> This patch looks like it does alot to the dw_hdmi.c as well and not
> just adds support for rk3288..
>
>>   drivers/gpu/drm/bridge/dw_hdmi.h            |   3 +-
>>   drivers/gpu/drm/rockchip/Kconfig            |  10 +
>>   drivers/gpu/drm/rockchip/Makefile           |   2 +-
>>   drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 328 ++++++++++++++++++++++++++++
>>   drivers/staging/imx-drm/dw_hdmi-imx.c       |   8 +
>>   include/drm/bridge/dw_hdmi.h                |   8 +
>>   7 files changed, 399 insertions(+), 5 deletions(-)
>>   create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
>>
>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>> index ed75147..1dd1f0b 100644
>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>> @@ -668,11 +668,15 @@ static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
>>   
>>   static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
>>   {
>> -	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
>> +	u32 val;
>> +
>> +	while ((val = hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
>>   		if (msec-- == 0)
>>   			return false;
>>   		udelay(1000);
>>   	}
>> +	hdmi_writeb(hdmi, val, HDMI_IH_I2CMPHY_STAT0);
>> +
>>   	return true;
>>   }
>>   
> Is this a bug fix?
     It seems like a bug fix, I don't know why it works well on imx and 
jz4780
     without this fix.
      HDMI_IN_I2CMPHY_STAT0 is a clear on write (1 to corresponding bit) 
status register
      to indicate i2c operation of the hdmi phy(i2c transfer done or 
err). After one register
      of the phy is configured by the i2cm, we should wait for the 
i2cmphydone bit set to 1,
      than configure the next register, than wait for the i2cmphydone 
bit set to 1....But we should
      clear the indicate bit by write 1 to the corresponding bit after 
the the set to 1, otherwise the bit
      will hold on forever, this will give us a wrong signal in the next 
wait, and as a result , the phy register can't  be configured as we want.
>
>> @@ -711,6 +715,13 @@ static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
>>   			 HDMI_PHY_CONF0_ENTMDS_MASK);
>>   }
>>   
>> +static void dw_hdmi_phy_enable_spare(struct dw_hdmi *hdmi, u8 enable)
>> +{
>> +	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
>> +			 HDMI_PHY_CONF0_SPARECTRL_OFFSET,
>> +			 HDMI_PHY_CONF0_SPARECTRL_MASK);
>> +}
>> +
>>   static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
>>   {
>>   	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
>> @@ -746,6 +757,7 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
>>   	u8 val, msec;
>>   	const struct mpll_config *mpll_cfg = hdmi->plat_data->mpll_cfg;
>>   	const struct curr_ctrl   *curr_ctr = hdmi->plat_data->cur_ctr;
>> +	const struct sym_term *sym_term =  hdmi->plat_data->sym_term;
>>   
>>   	if (prep)
>>   		return -EINVAL;
>> @@ -815,10 +827,17 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
>>   
>>   	hdmi_phy_i2c_write(hdmi, 0x0000, 0x13);  /* PLLPHBYCTRL */
>>   	hdmi_phy_i2c_write(hdmi, 0x0006, 0x17);
>> +
>> +	for (i = 0; sym_term[i].mpixelclock != (~0UL); i++)
>> +		if (hdmi->hdmi_data.video_mode.mpixelclock <=
>> +		    sym_term[i].mpixelclock)
>> +			break;
>> +
>>   	/* RESISTANCE TERM 133Ohm Cfg */
>> -	hdmi_phy_i2c_write(hdmi, 0x0005, 0x19);  /* TXTERM */
>> +	hdmi_phy_i2c_write(hdmi, sym_term[i].term, 0x19);  /* TXTERM */
>>   	/* PREEMP Cgf 0.00 */
>> -	hdmi_phy_i2c_write(hdmi, 0x800d, 0x09);  /* CKSYMTXCTRL */
>> +	hdmi_phy_i2c_write(hdmi, sym_term[i].sym_ctr, 0x09);  /* CKSYMTXCTRL */
>> +
> All these seem generic improvements and not rk3288 specific?
    Yes ,  different board needs different termination vale to get best SI.
    Do you mean we should put these in a separate patch?
>
>>   	/* TX/CK LVL 10 */
>>   	hdmi_phy_i2c_write(hdmi, 0x01ad, 0x0E);  /* VLEVCTRL */
>>   	/* REMOVE CLK TERM */
>> @@ -834,6 +853,9 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
>>   	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
>>   	dw_hdmi_phy_gen2_pddq(hdmi, 0);
>>   
>> +	if (hdmi->dev_type == RK3288_HDMI)
>> +		dw_hdmi_phy_enable_spare(hdmi, 1);
>> +
>>   	/*Wait for PHY PLL lock */
>>   	msec = 5;
>>   	do {
>> @@ -1398,6 +1420,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
>>   	return 0;
>>   }
>>   
>> +static enum drm_mode_status
>> +dw_hdmi_connector_mode_valid(struct drm_connector *connector,
>> +			     struct drm_display_mode *mode)
>> +{
>> +	struct dw_hdmi *hdmi = container_of(connector,
>> +					    struct dw_hdmi, connector);
>> +	enum drm_mode_status mode_status = MODE_OK;
>> +
>> +	if (hdmi->plat_data->mode_valid)
>> +		mode_status = hdmi->plat_data->mode_valid(connector, mode);
>> +
>> +	return mode_status;
>> +}
>> +
> This too is disjoint from rk3288 support.
   RK3288 can't support all the display mode for it can't give
   all the precise clock some display mode needs.
>
>>   static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
>>   							   *connector)
>>   {
>> @@ -1422,6 +1458,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
>>   
>>   static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
>>   	.get_modes = dw_hdmi_connector_get_modes,
>> +	.mode_valid = dw_hdmi_connector_mode_valid,
>>   	.best_encoder = dw_hdmi_connector_best_encoder,
>>   };
>>   
>> @@ -1514,6 +1551,8 @@ static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
>>   
>>   	drm_mode_connector_attach_encoder(&hdmi->connector, encoder);
>>   
>> +	drm_connector_register(&hdmi->connector);
>> +
>>   	return 0;
>>   }
>>   
> ...
>
> Please separate generic dw_hdmi.c improvements from the add rk3288 support.
>
> Regards
> ZubairLK
>
>
>

