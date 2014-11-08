Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaKHDT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 22:19:58 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:59243 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaKHDT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 22:19:56 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: jay.xu@rock-chips.com
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <770c6e398cdaf048c9b6504cea7698fe>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545D8BCE.1030202@rock-chips.com>
Date: Sat, 08 Nov 2014 11:19:42 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: Re: [PATCH V4 5/6] dw-hdmi: add support for multi byte register width
 access
References: <1415360068-8606-1-git-send-email-andy.yan@rock-chips.com>	 <1415360125-8655-1-git-send-email-andy.yan@rock-chips.com> <1415360707.2776.1.camel@pengutronix.de>
In-Reply-To: <1415360707.2776.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月07日 19:45, Lucas Stach wrote:
> Am Freitag, den 07.11.2014, 19:35 +0800 schrieb Andy Yan:
>> On rockchip rk3288, only word(32-bit) accesses are
>> permitted for hdmi registers.  Byte width access (writeb,
>> readb) generates an imprecise external abort.
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> ---
>>   drivers/gpu/drm/bridge/dw_hdmi.c | 49 +++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>> index df76a8c..9867642 100644
>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>> @@ -126,19 +126,42 @@ struct dw_hdmi {
> [...]
>> +	u32 val;
>> +
>> +	if (!of_property_read_u32(np, "reg-io-width", &val)) {
>> +		switch (val) {
>> +		case 4:
>> +			hdmi->write = dw_hdmi_writel;
>> +			hdmi->read = dw_hdmi_readl;
>> +			hdmi->reg_shift = 2;
>> +			break;
>> +		default:
>> +			hdmi->write = dw_hdmi_writeb;
>> +			hdmi->read = dw_hdmi_readb;
>> +			hdmi->reg_shift = 0;
>> +			break;
>> +		}
>> +	} else {
>> +		hdmi->write = dw_hdmi_writeb;
>> +		hdmi->read = dw_hdmi_readb;
>> +		hdmi->reg_shift = 0;
>> +	}
>>   
>>   	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
>>   	if (ddc_node) {
> This should throw an error if the property value in devicetree is not
> recognized. This could be simplified like this:
>
> 	u32 val = 1;
>
> 	// this won't touch val if it can't find the property
> 	of_property_read_u32(np, "reg-io-width", &val)
>
>
> 	switch (val) {
> 	case 4:
> 		hdmi->write = dw_hdmi_writel;
> 		hdmi->read = dw_hdmi_readl;
> 		hdmi->reg_shift = 2;
> 		break;
> 	case 1:
> 		hdmi->write = dw_hdmi_writeb;
> 		hdmi->read = dw_hdmi_readb;
> 		hdmi->reg_shift = 0;
> 		break;
> 	default:
> 		dev_err(dev, "unrecognized value for reg-io-width");
> 		// error handling
> 	}
>
> Also the DT binding doc for this property is missing.
>
> Regards,
> Lucas
thanks for your suggestion, I will take it.
this properity is optional, I will add it to DT binding doc

