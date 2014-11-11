Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaKKOrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:47:05 -0500
Received: from regular1.263xmail.com ([211.150.99.138]:35678 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:47:03 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <e724f3b59f4ba14a418398a441c82cbb>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5462214F.4010504@rock-chips.com>
Date: Tue, 11 Nov 2014 22:46:39 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        djkurtz@google.com, Philipp Zabel <p.zabel@pengutronix.de>,
        ykk@rock-chips.com, Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        jay.xu@rock-chips.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v7 5/7] drm: bridge/dw-hdmi: add support for multi byte
 register width access
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710432-12167-1-git-send-email-andy.yan@rock-chips.com> <54621B23.1020602@imgtec.com>
In-Reply-To: <54621B23.1020602@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月11日 22:20, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> This patch adds the reg-io-width binding.
>
> Hence the binding patch should come before it.
>
    do you mean that I should put dts binding patch
    before this patch?
> On 11/11/14 12:53, Andy Yan wrote:
>> On rockchip rk3288, only word(32-bit) accesses are
>> permitted for hdmi registers.  Byte width accesses (writeb,
>> readb) generate an imprecise external abort.
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>
>> ---
>>
>>   }
>>   
>>   static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
>> @@ -1499,6 +1527,23 @@ static int dw_hdmi_bind(struct device *dev, struct device *master, void *data)
>>   	struct device_node *ddc_node;
>>   	struct resource *iores;
>>   	int ret, irq;
>> +	u32 val = 1;
>> +
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
> The binding patch says this is an optional property.
> But here if undefined it returns -EINVAL.
>
> I would keep it optional and default it to byte access.
   if the dts undefined it, the val will be 1.
   if the dts defined other value except 4 and 1, return -EINVAL
>
> Regards,
> ZubairLK
>    
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


