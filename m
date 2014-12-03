Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaLCMcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:32:31 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:32772 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaLCMc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:32:28 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: galak@codeaurora.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <9ab3d8e6692d0251516df7d70c7beacd>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547F02CF.9010804@rock-chips.com>
Date: Wed, 03 Dec 2014 20:32:15 +0800
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
        Mark Rutland <mark.rutland@arm.com>, vladimir_zapolskiy@mentor.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v15 12/12] drm: bridge/dw_hdmi: add rockchip rk3288 support
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>		 <1417506327-18908-1-git-send-email-andy.yan@rock-chips.com>	 <1417515882.3411.8.camel@pengutronix.de> <547DB1ED.7000409@rock-chips.com> <1417525257.3411.12.camel@pengutronix.de>
In-Reply-To: <1417525257.3411.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:
On 2014年12月02日 21:00, Philipp Zabel wrote:
> Hi Andy,
>
> Am Dienstag, den 02.12.2014, 20:34 +0800 schrieb Andy Yan:
>> Hi Philipp:
>> On 2014年12月02日 18:24, Philipp Zabel wrote:
>>> Hi Andy,
>>>
>>> Am Dienstag, den 02.12.2014, 15:45 +0800 schrieb Andy Yan:
>>> [...]
>>>> +static int dw_hdmi_rockchip_bind(struct device *dev, struct device *master,
>>>> +				 void *data)
>>>> +{
>>>> +	struct platform_device *pdev = to_platform_device(dev);
>>>> +	const struct dw_hdmi_plat_data *plat_data;
>>>> +	const struct of_device_id *match;
>>>> +	struct drm_device *drm = data;
>>>> +	struct drm_encoder *encoder;
>>>> +	struct rockchip_hdmi *hdmi;
>>>> +	int ret;
>>>> +
>>>> +	if (!pdev->dev.of_node)
>>>> +		return -ENODEV;
>>>> +
>>>> +	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
>>>> +	if (!hdmi)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	match = of_match_node(dw_hdmi_rockchip_ids, pdev->dev.of_node);
>>>> +	plat_data = match->data;
>>>> +	hdmi->dev = &pdev->dev;
>>>> +	encoder = &hdmi->encoder;
>>>> +	platform_set_drvdata(pdev, hdmi);
>>>> +
>>>> +	ret = rockchip_hdmi_parse_dt(hdmi);
>>>> +	if (ret) {
>>>> +		dev_err(hdmi->dev, "Unable to parse OF data\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	ret = clk_prepare_enable(hdmi->clk);
>>>> +	if (ret) {
>>>> +		dev_err(hdmi->dev, "Cannot enable HDMI clock: %d\n", ret);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	ret = clk_prepare_enable(hdmi->hdcp_clk);
>>>> +	if (ret) {
>>>> +		dev_err(hdmi->dev, "Cannot enable HDMI hdcp clock: %d\n", ret);
>>>> +		return ret;
>>>> +	}
>>> Could we have a look at the clocks again? Basically the Rockchip clock
>>> handling is exactly the same, except the clocks are called by other
>>> names.
>>>
>>> On i.MX6, according to the reference manual, the HDMI TX module has four
>>> clock inputs: "iahbclk" (bus clock), "icecclk" (32 kHz CEC clock),
>>> "ihclk" (module clock), and "isfrclk" (27 MHz internal SFR clock).
>>> The "iahbclk" and "ihclk" are both sourced from the SoC AHB root clock,
>>> the 32 kHz reference input can't be gated, and the "isfrclk" has its own
>>> gate.
>>>
>>> Does the HDMI TX implementation on Rockchip still have the separate
>>> external sfr bus and module clock inputs? I assume that your "clk" input
>>> is a single gate bit for bus and module clocks at the same time?
>>> If possible, I'd prefer to find a common binding for the clocks with
>>> some of the clocks being optional, but for that we need to know the
>>> actual clock inputs to the HDMI TX module.
>>>
>>> regards
>>> Philipp
>>>
>>       There are three  individual clock inputs on Rockchip RK3288 HDMI:
>> "hdmi_ctrl_clk",
>>       "hdmi_cec_clk", "hdmi_hdcp_clk", the three clocks are responsible
>> for different
>>        functions as their name described, and have their own private gate
>> bit. That is
>>        to say, the cec_clk and hdcp_clk can all be disabled if we don't
>> need hdcp and cec
>>        function.
>>        So I think it's better to make the clk control platform independent.
> My question is not about the available gates at the SoC level, but about
> the actual clock inputs from point of view of the HDMI TX IP.
>
> It could be that the hdmi_ctrl_clk gates all inputs to the module and
> bus clocks together. If so, you could just reuse "isfr" and "iahb" and
> set it to the same clock. If not, we'd need to think of something else.
> Unfortunately I don't have any Synopsys documentation of the HDMI TX at
> that level.

    After confirming with the IC designer, we finally make clear that
    Rockchip RK3288 almost use the same clock design with imx:
    clk-----iahbclk, used for hdmi module and bus
    hdcp_clk-----isfrclk, used for hdcp and i2cm
    cecclk -----cecclk, but this clk can be gated on rockchip, this is 
different with imx,
    but we don't handle the cec stuff now. So i will try to reuse the 
imx clk binds. do you
   think that is ok?
> regards
> Philipp
>
>
>
>


