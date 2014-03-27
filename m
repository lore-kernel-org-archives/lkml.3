Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaC0LOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:14:09 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33508 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaC0LOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:14:07 -0400
Message-ID: <533407F9.7060509@gmail.com>
Date: Thu, 27 Mar 2014 12:14:01 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Fabio Estevam <festevam@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, t.figa@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property
 is present
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com> <CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com> <53333145.4080903@gmail.com> <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com> <5333DA13.2080505@gmail.com> <5333F704.7020504@samsung.com>
In-Reply-To: <5333F704.7020504@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Le 27/03/2014 11:01, Sylwester Nawrocki a écrit :
> Hi Boris,
>
> On 27/03/14 08:58, Boris BREZILLON wrote:
>> This solution solve the problem for this specific case because clks are
>> declared in the correct order in imx DTs.
>> But, even with your patch I think we could see similar issues by
>> reordering DT nodes...
>>
>> The real problem here is that imx platform does not declare the CCM clocks
>> dependencies upon ckil, ckih1 and osc fixed clocks within the DT [1], and
>> retrieve these clocks when initializing the CCM clocks ([2] and [3]).
>>
>> We should try to a add these dependencies in the DT and see if it works.
> While presumably all of us agree the dependencies should be correctly
> specified in dts I think we should minimize possible regressions by
> keeping the clocks registration order as before, i.e. as parsed by the
> kernel from DT. Rather than explicitly reversing it, which does not gain
> us anything AFAICS. Instead we are seeing regressions where new kernels
> stop working with old dtbs.

I totally agree with you on this point: my patch is not a replacement of 
yours.
I just wanted to point out that we need to fix DT definitions to avoid these
kind of issues in the future.

>
> I'm going to resend the patch replacing list_add() with list_add_tail(),
> with this the mvebu platform would work and there should be no regression
> on imx and exynos.
>
> Please note that specifying dependencies between CCM on imx and the fixed
> clocks might not be enough. If the fixed clocks get matched on "fixed-clock"
> compatible some clock specifiers (i.e. those using phandle to the CCM) could
> get invalid, since the clocks won't get registered by the ccm driver, but by
> the regular fixed clock driver. That means a phandle to different node would
> need to be used to reference the fixed clock. I'm not sure if this is the case
> for imx, but changes may be needed all over various dts files.
> In addition, we should make sure the kernel works with current and modified
> dtbs.
>
>> [1] http://lxr.free-electrons.com/source/arch/arm/boot/dts/imx6sl.dtsi#L379
>> [2] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk-imx6q.c#L151
>> [3] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk.c#L30

