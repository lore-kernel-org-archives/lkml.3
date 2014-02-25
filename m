Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbaBYAaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:30:25 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:45831 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBYAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:30:21 -0500
Message-ID: <530BE40D.8080506@elopez.com.ar>
Date: Mon, 24 Feb 2014 21:30:05 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, rjw@sisk.pl
Subject: Re: [PATCH 1/5] clk: sun6i: Protect CPU clock
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com> <1393258967-4843-2-git-send-email-maxime.ripard@free-electrons.com> <20140224163034.GN21483@n2100.arm.linux.org.uk> <530BD804.5090806@elopez.com.ar> <20140225000154.GR21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140225000154.GR21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

El 24/02/14 21:01, Russell King - ARM Linux escribió:
> Hi Emilio.
>
> On Mon, Feb 24, 2014 at 08:38:44PM -0300, Emilio López wrote:
>> Why is this so? Can't a clock be left enabled while nobody has a
>> reference to it? I have looked around in Documentation/ (rather quickly
>> I must say) and have not found any explicit mention that it is required
>> to keep a reference to the clock while it's enabled. I'd appreciate it
>> if you could explain this a bit more verbosely or point me to the
>> relevant documents.
>
> First up, if you have a requirement that a clock be enabled, then is it
> not unreasonable to ensure that the clock is referenced?

I was under the impression that the reference count was orthogonal to 
the clock status, but after getting that clarified, I can see your point.

> Secondly, what if we have code which scans the clocks in the system,
> shutting down those leaf clocks which appear to be unreferenced?

Indeed, that would break things.

> Thirdly, the API (as I designed it) says so:
>
> /**
>   * clk_put      - "free" the clock source
>   * @clk: clock source
>   *
>   * Note: drivers must ensure that all clk_enable calls made on this
>   * clock source are balanced by clk_disable calls prior to calling
>   * this function.
>   *
>   * clk_put should not be called from within interrupt context.
>   */
> void clk_put(struct clk *clk);
>
> which has been there since the API was first created - it's part of the
> contract between drivers using the API and implementers creating something
> which conforms to the API - which today means CCF.

That's enough of a reason on its own :) I should have checked clk.h

> The intention here is that while there are any users holding a clk_get()
> reference on a clock, the clock is assumed to be required for some
> device, and the struct clk may not be kfree'd, nor may its state be
> changed in an unpredictable way to those drivers holding a reference
> to it.

I understand now, thanks for the insight. I'll talk with Maxime and get 
this sorted out.

As a side note, should drivers/base/power/clock_ops.c be fixed too? I 
have added Rafael to Cc.

Cheers,

Emilio
