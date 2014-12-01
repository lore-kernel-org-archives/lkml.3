Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaLAMqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:46:48 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:58061 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaLAMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:46:46 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <6f55435382ce65c6d86fa34593eb244d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547C632C.7000309@rock-chips.com>
Date: Mon, 01 Dec 2014 20:46:36 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v13 07/12] drm: bridge/dw_hdmi: add support for multi-byte
 register width access
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com> <1417008759-32257-1-git-send-email-andy.yan@rock-chips.com> <1417019657.3177.10.camel@pengutronix.de> <547843B9.6000806@rock-chips.com> <1417435456.4624.12.camel@pengutronix.de>
In-Reply-To: <1417435456.4624.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:
On 2014年12月01日 20:04, Philipp Zabel wrote:
> Am Freitag, den 28.11.2014, 17:43 +0800 schrieb Andy Yan:
>> Hi Zabel:
>> On 2014年11月27日 00:34, Philipp Zabel wrote:
>>> Am Mittwoch, den 26.11.2014, 21:32 +0800 schrieb Andy Yan:
>>>> On rockchip rk3288, only word(32-bit) accesses are
>>>> permitted for hdmi registers.  Byte width accesses (writeb,
>>>> readb) generate an imprecise external abort.
>>>>
>>>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>>>
>>>> ---
>>>>
>>>> Changes in v13: None
>>>> Changes in v12: None
>>>> Changes in v11: None
>>>> Changes in v10: None
>>>> Changes in v9: None
>>>> Changes in v8: None
>>>> Changes in v7: None
>>>> Changes in v6:
>>>> - refactor register access without reg_shift
>>>>
>>>> Changes in v5:
>>>> - refactor reg-io-width
>>>>
>>>> Changes in v4: None
>>>> Changes in v3:
>>>> - split multi-register access to one indepent patch
>>>>
>>>>    drivers/gpu/drm/bridge/dw_hdmi.c | 57 +++++++++++++++++++++++++++++++++++-----
>>>>    1 file changed, 51 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>>>> index a53bf63..5e88c8d 100644
>>>> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
>>>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>>>> @@ -100,6 +100,11 @@ struct hdmi_data_info {
>>>>    	struct hdmi_vmode video_mode;
>>>>    };
>>>>    
>>>> +union dw_reg_ptr {
>>>> +	u32 __iomem *p32;
>>>> +	u8 __iomem *p8;
>>>> +};
>>> I see no need to introduce this. Just explicitly multiply the offset in
>>> dw_hdmi_writel.
>>>
>>       Is there any disadvantage to do like this?
>>       The compiler can help us do the explicitly multiply by this way.
> Four additional lines, a new defined type, a few more changes to struct
> dw_hdmi and dw_hdmi_bind necessary.
>
> Technically I see no problem to let the compiler do the multiplication,
> my issue is that it ever so slightly obfuscates the code. Instead of
> just writing "* 4" in two functions, we get a new union that you need to
> know about when looking at struct dw_hdmi and dw_hdmi_bind, regs.p8 is
> used but never assigned directly, it's just a tiny bit of additional
> effort needed to understand the code. But when the cost to avoid that is
> so small...
>
> regards
> Philipp
>

   What you said is right, I will change it in PATCH V15
    thanks .
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip


