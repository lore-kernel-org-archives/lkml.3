Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaHOHtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 03:49:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39994 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaHOHs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 03:48:58 -0400
Message-ID: <53EDBB5B.4000209@collabora.co.uk>
Date: Fri, 15 Aug 2014 09:48:43 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>	<CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>	<20140814151958.GY17528@sirena.org.uk> <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
In-Reply-To: <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tim,

On 08/15/2014 07:36 AM, Tim Kryger wrote:
> On Thu, Aug 14, 2014 at 8:19 AM, Mark Brown <broonie@kernel.org> wrote:
> 
>> Right, there's two things going on here.  One is that as you describe we
>> shouldn't be putting constraints in .dtsi files if we don't know they're
>> OK for a given board.  The other thing is that on this particular board
>> it turns out that there's no support for varying the voltages at all so
>> it doesn't make sense to have to specify a range, there's only one value
>> anyway so the software really should be able to figure out that fixed
>> value all by itself.
> 
> If constraints are truly irrelevant when the voltage supplied to
> consumers is fixed, why doesn't regulator_list_voltage honor this
> exemption and skip the voltage filtering that uses (potentially
> unspecified) constraints when output is entirely determined by a
> parent (or grandparent) supply that can't change its voltage?
>

I had a similar thought before and proposed the patch:

"[RFC 3/5] regulator: core: Only apply constraints if available on list
voltage" [0].

But then Mark explained to me that this is wrong since in that case
regulator_list_voltage() will list voltages that can't really be set [1].

But now I wonder why regulator_list_voltage() even list the voltage for
fixed regulators (desc->fixed_uV) since they don't have the ability to
vary voltage. The regulator_list_voltage() documentation says:

"Returns a voltage that can be passed to @regulator_set_voltage(), zero if
this selector code can't be used on this system, or a negative errno."

But in the case of fixed regulators, it is actually listing a voltage that
can't be selected. Although regulator_set_voltage() checks if the desired
voltage is equal to the regulator min_uV and max_uV and just exits in that
case, it feels wrong to list the voltage for a fixed regulators.

regulator_list_voltage() only works because of the way we define the
generic fixed voltage regulators and that is assuming that
"regulator-min-microvolt" and "regulator-max-microvolt" DT properties
being the same means that the regulator is fixed.

This is kind of unfortunate, maybe it would had been better to define it
explicitly using a "regulator-fixed-microvolt" or something. If we had
such a DT property, then constraints wouldn't had been set for fixed
regulators and regulator_list_voltage() wouldn't list its voltage neither.

> It seems odd to make callers be the ones to handle this subtlety.
> 

If regulator_list_voltage() didn't list the voltage for fixed regulators,
then this subtlety should had been handled by callers before but they
didn't because they rely on regulator_list_voltage() to always return a
voltage even for fixed regulators.

> Thanks,
> Tim Kryger
> 

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/7/29/418
[1]: https://lkml.org/lkml/2014/7/29/453
