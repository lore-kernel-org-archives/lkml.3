Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaKKOh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:37:59 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:22295 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaKKOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:37:58 -0500
Message-ID: <54621F3B.8050103@imgtec.com>
Date: Tue, 11 Nov 2014 14:37:47 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lucas Stach <l.stach@pengutronix.de>
CC: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        <djkurtz@google.com>, <ykk@rock-chips.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <devel@driverdev.osuosl.org>, <devicetree@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>, <jay.xu@rock-chips.com>
Subject: Re: [PATCH v7 5/7] drm: bridge/dw-hdmi: add support for multi byte
 register width access
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com>	 <1415710432-12167-1-git-send-email-andy.yan@rock-chips.com>	 <54621B23.1020602@imgtec.com> <1415715820.2815.9.camel@pengutronix.de>
In-Reply-To: <1415715820.2815.9.camel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/11/14 14:23, Lucas Stach wrote:
> Am Dienstag, den 11.11.2014, 14:20 +0000 schrieb Zubair Lutfullah
> Kakakhel:
>> Hi Andy,
>>
>> This patch adds the reg-io-width binding.
>>
>> Hence the binding patch should come before it.
>>
>>
>> On 11/11/14 12:53, Andy Yan wrote:
>>> On rockchip rk3288, only word(32-bit) accesses are
>>> permitted for hdmi registers.  Byte width accesses (writeb,
>>> readb) generate an imprecise external abort.
>>>
>>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>>
>>> ---
>>>
>>>  }
>>>  
>>>  static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
>>> @@ -1499,6 +1527,23 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
>>>  	struct device_node *ddc_node;
>>>  	struct resource *iores;
>>>  	int ret, irq;
>>> +	u32 val = 1;
>>> +
>>> +	of_property_read_u32(np, "reg-io-width", &val);
>>> +
>>> +	switch (val) {
>>> +	case 4:
>>> +		hdmi->write = dw_hdmi_writel;
>>> +		hdmi->read = dw_hdmi_readl;
>>> +		break;
>>> +	case 1:
>>> +		hdmi->write = dw_hdmi_writeb;
>>> +		hdmi->read = dw_hdmi_readb;
>>> +		break;
>>> +	default:
>>> +		dev_err(dev, "reg-io-width must be 1 or 4\n");
>>> +		return -EINVAL;
>>> +	}
>>
>> The binding patch says this is an optional property.
>> But here if undefined it returns -EINVAL.
>>
>> I would keep it optional and default it to byte access.
> 
> That's exactly what the patch does. val is initialized to 1, which is
> not changed if the property could not be found in the DT. The default
> case will only be taken if the property is present in DT but has any
> other value than 1 or 4, which is an error.
> 

I missed the initialization. My bad.

Thanks
ZubairLK
