Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaKGC5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:57:13 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:49838 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKGC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:57:11 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: linux-rockchip@lists.infradead.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <1c7656c0e0f06c4a10f02cc9d109840e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545C34F1.5020206@rock-chips.com>
Date: Fri, 07 Nov 2014 10:56:49 +0800
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
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2 1/2] imx-drm: imx-hdmi: split imx soc specific code
 from imx-hdmi
References: <1415192385-6572-1-git-send-email-andy.yan@rock-chips.com> <545A2680.2@imgtec.com>
In-Reply-To: <545A2680.2@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月05日 21:30, Zubair Lutfullah Kakakhel wrote:
> This one patch does too much to be reviewed easily.
>
> One patch is supposed to modify/add one thing at a time in the kernel.
>
> Separating platform specific code from imx-drm/imx-hdmi is one thing.
>
> Adding support for multi-byte register access is something different.
>
> i.e. Something like.
> 1/3 split platform specific code out.
> 2/3 move/rename imx-hdmi outside the folder
> 3/3 add support for multi byte register width access.
>
> If there are other things that are not directly relevant to the patch,
> it goes in a different patch. Bug fixes are also separate.
>
> This should result in readable patches that can be reviewed easily.
I have split the patch in three parts in PATCH V3, tkanks for your 
suggestion
>
> Also, the approach with 4 byte access is ok. But you could use reg-shifts as well perhaps.
> Then you won't have to change so much of the code.
>
> static inline void hdmi_writeb(struct dwc_hdmi *hdmi, u8 val, int offset)
> +{
> + writeb(val, hdmi->regs + (offset << hdmi->reg_shift));
> +}
> +
> +static inline u8 hdmi_readb(struct dwc_hdmi *hdmi, int offset)
> +{
> + return readb(hdmi->regs + (offset << hdmi->reg_shift));
> +}
>
> And then in probe
>
> +hdmi->reg_shift = 0;
> +
> + if (of_property_read_u32(np, "reg-shift", &hdmi->reg_shift))
> + dev_warn(hdmi->dev, "No reg-shift\n");
>
> This way the reg-shift property can be defined using DT

rk3288 can only access the register by 32bits(readl/writel), byte access 
will causes an
imprecise external abort.
I have refactor the register access in PATCH V3, if you have any futher 
suggestion ,please
tell me.

>
> Cheers,
> ZubairLK
>
> On 05/11/14 12:59, Andy Yan wrote:
>> imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
>> use the interface compatible Designware HDMI IP, but they
>> also have some lightly difference, such as phy pll configuration,
>> register width(imx hdmi register is one byte, but rk3288 is 4
>> bytes width), 4K support(imx6 doesn't support 4k, but rk3288 does),
>> clk useage,and the crtc mux configuration is also platform specific.
>>
>> To reuse the imx hdmi driver, split the platform specific code out
>> to dw_hdmi-imx.c.
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> ---
>>   drivers/staging/imx-drm/Makefile      |   2 +-
>>   drivers/staging/imx-drm/dw_hdmi-imx.c | 214 ++++++++++
>>   drivers/staging/imx-drm/imx-hdmi.c    | 726 ++++++++++++++--------------------
>>   include/drm/bridge/dw_hdmi.h          | 114 ++++++
>>   4 files changed, 634 insertions(+), 422 deletions(-)
>>   create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
>>   create mode 100644 include/drm/bridge/dw_hdmi.h
>
>


