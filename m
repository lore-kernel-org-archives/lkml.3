Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaK1JrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:47:18 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:56904 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaK1JrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:47:16 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <2c53092dee6373ad6b64b5c5bf7167ae>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5478449A.40307@rock-chips.com>
Date: Fri, 28 Nov 2014 17:47:06 +0800
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
Subject: Re: [PATCH v13 08/12] drm: bridge/dw_hdmi: add mode_valid support
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com>	 <1417008811-32308-1-git-send-email-andy.yan@rock-chips.com> <1417018985.3177.8.camel@pengutronix.de>
In-Reply-To: <1417018985.3177.8.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:

On 2014年11月27日 00:23, Philipp Zabel wrote:
> Am Mittwoch, den 26.11.2014, 21:33 +0800 schrieb Andy Yan:
>> some platform may not support all the display mode,
>> add mode_valid interface check it
>>
>> also add drm_connector_register which add a debugfs
>> interface for dump display modes and edid information
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> ---
>>
>> Changes in v13: None
>> Changes in v12: None
>> Changes in v11: None
>> Changes in v10: None
>> Changes in v9: None
>> Changes in v8: None
>> Changes in v7: None
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>>
>>   drivers/gpu/drm/bridge/dw_hdmi.c | 17 +++++++++++++++++
>>   include/drm/bridge/dw_hdmi.h     |  2 ++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>> index 5e88c8d..b13e782 100644
>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>> @@ -1406,6 +1406,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
>>   	return 0;
>>   }
>>   
>> +static enum drm_mode_status
>> +dw_hdmi_connector_mode_valid(struct drm_connector *connector,
>> +			     struct drm_display_mode *mode)
>> +{
>> +	struct dw_hdmi *hdmi = container_of(connector,
>> +					   struct dw_hdmi, connector);
>> +	enum drm_mode_status mode_status = MODE_OK;
>> +
>> +	if (hdmi->plat_data->mode_valid)
>> +		mode_status = hdmi->plat_data->mode_valid(connector, mode);
>> +
>> +	return mode_status;
>> +}
>> +
>>   static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
>>   							   *connector)
>>   {
>> @@ -1430,6 +1444,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
>>   
>>   static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
>>   	.get_modes = dw_hdmi_connector_get_modes,
>> +	.mode_valid = dw_hdmi_connector_mode_valid,
>>   	.best_encoder = dw_hdmi_connector_best_encoder,
>>   };
>>   
>> @@ -1631,6 +1646,8 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
>>   
>>   	dev_set_drvdata(dev, hdmi);
>>   
>> +	drm_connector_register(&hdmi->connector);
>> +
> This is not right, the connector is registered by the imx-drm core in
> the drm_driver .load callback.
     Sorry, I didn't found imx-drm core has did that before.And I found many
connector drivers register it by itself.
    This will be removed in next patch.
> regards
> Philipp
>
>
>
>


