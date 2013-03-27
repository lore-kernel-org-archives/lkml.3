Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3C0KDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:03:23 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:59747 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3C0KDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomWZ_9a_RceQ419QAAXOR17yrtrRP0Gf4xoS3B=yzbRXg@mail.gmail.com>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
	<alpine.LFD.2.02.1303270941320.22263@ionos>
	<CAKohpomWZ_9a_RceQ419QAAXOR17yrtrRP0Gf4xoS3B=yzbRXg@mail.gmail.com>
Date: Wed, 27 Mar 2013 11:03:21 +0100
Message-ID: <CAPDyKFoHQK576H+zsW9ykzJT-gjc6=qeiRVi26THa_4dhNVRVw@mail.gmail.com>
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 10:55, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 27 March 2013 15:10, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Wed, 27 Mar 2013, Mike Turquette wrote:
>>
>>> Reentrancy into the clock framework from the clk.h api is necessary
>>> for clocks that are prepared and unprepared via i2c_transfer (which
>>> includes many PMICs and discrete audio chips) as well as for several
>>> other use cases.
>>
>> That explanation sucks.
>>
>> Why does an i2c clock need reentrancy? Just because it's i2c or what?
>
> I am noway connected to this development but was just going through
> your mail and i think i might know the answer why is this required.
>
> Consider an example where an external chip has clock controller and has
> bits which can be programmed to enable/disable clock. And this chip is
> connected via spi/i2c to SoC.
>
> clk_prepare(peripheral on external chip)
>   -> i2c_xfer(to write to external chips register)
>       -> clk_enable(i2c controller)
>           ->controller-xfer-routine.. and finally we enable clk here...
>
>
> Sorry if i am on the wrong side :)

I agree with you Viresh. I guess Mike should update the commit message.

I would also like add another reason to why this is needed. For some
clks you would like to do pinctrl operations from a clk hw. But since
a pinctrl driver likely requires a clk to be prepared|enabled, we run
into a clk reentrant issue.

Kind regards
Ulf Hansson

>
> --
> viresh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
