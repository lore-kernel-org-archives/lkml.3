Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaL3DHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:07:39 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:57696 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaL3DHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:07:37 -0500
X-263anti-spam: KSV:0;BIG:0;ABS:1;DNS:5;ATT:0;SPF:S;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ADDR-CHECKED: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 50.2.43.38
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <d4386df772a4feb503ba625bae6af634>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
Message-ID: <54A216E2.4090504@rock-chips.com>
Date: Tue, 30 Dec 2014 11:07:14 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: heiko@sntech.de, dianders@chromium.org, linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] regulator: rk808: add dvs support
References: <1418612879-16094-1-git-send-email-zyw@rock-chips.com> <1418612879-16094-3-git-send-email-zyw@rock-chips.com> <20141229172555.GE17800@sirena.org.uk>
In-Reply-To: <20141229172555.GE17800@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/30/2014 01:25 AM, Mark Brown wrote:
> On Mon, Dec 15, 2014 at 11:07:58AM +0800, Chris Zhong wrote:
>
>> +	sel <<= ffs(rdev->desc->vsel_mask) - 1;
>> +	sel |= old_sel & ~rdev->desc->vsel_mask;
>> +
>> +	ret = regmap_write(rdev->regmap, reg, sel);
>> +	if (ret)
>> +		return ret;
>> +
>> +	gpiod_set_value(gpio, !gpio_level);
> So, this seems a bit odd.  What we appear to be doing here is
> alternating between the two different voltage setting registers which is
> all well and good but makes me wonder why we're bothering - it's a bit
> more work than just sticking with one.  We do get...
you mean check the old_selector and selector? I think
_regulator_do_set_voltage have done it.
>
>> +	/*
>> +	 * dvsok pin would be pull down when dvs1/2 pin changed, and
>> +	 * it would be pull up once the voltage regulate complete.
>> +	 * No need to wait dvsok signal when voltage falling.
>> +	 */
> ...this but unless the voltage typically ramps much faster than spec
> it's never clear to me that we're actually winning by polling the pin
> instead of just dead reckoning the time, it's more work for the CPU to
> poll the GPIO than to sleep after all.
Actually, it's slower than spec, so I think getting this dvsok pin state
is safer than delay.
>
> One thing we can do with hardware like this is to program in a voltage
> we're likely to want to switch to quickly and then use the GPIO to get
> there.  That can be a bit hard to arrange with the regulator API as it
> currently stands since we don't exactly have an interface for it.
>
> We can just check to see what the two values are current set to before
> switching and skip the register write if it's the same (making things
> faster since we're typically avoiding an I2C or SPI transaction by doing
> that) but that's a bit meh.  We can also try to do things like keep the
> top voltage from the voltage ranges we're being given programmed which
> for DVS typically ends up doing a reasonable job since governors often
> like to jump straight to top speed when things get busy so that's one of
> the common cases where we most want to change voltages as quickly as
> possible.


