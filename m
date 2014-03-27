Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaC0KBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:01:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13177 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaC0KBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:01:48 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-92-5333f709ea08
Message-id: <5333F704.7020504@samsung.com>
Date: Thu, 27 Mar 2014 11:01:40 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
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
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property is
 present
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
 <CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com>
 <53333145.4080903@gmail.com>
 <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
 <5333DA13.2080505@gmail.com>
In-reply-to: <5333DA13.2080505@gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xy7qc342DDfrb5Cz+TjrGbjFzYpLF
	/CPnWC0eXvW32NT2ltFi1dSdLBZfD69gtNj0+BqrxeVdc9gsbl/mtXg64SKbxbfLzewWp65/
	ZrNY9/AFk8XhN+2sFk/XLWG2WD/jNYuDoEdLcw+bx+9fkxg9FvzayuLxZNNFRo+ds+6ye7y6
	cIfF4861PWwem5fUe1w50cTq0f/XwKNvyypGj8+b5AJ4orhsUlJzMstSi/TtErgy3s5sYS14
	wl8x4+8X5gbGLzxdjJwcEgImEl+/f2KDsMUkLtxbD2RzcQgJLGWUeLB7OQuE84lR4sKiJ8wg
	VbwCWhJHnzwC62ARUJU4sGcOK4jNJmAo0Xu0jxHEFhWIkJg7cTMbRL2gxI/J91hAbBGBUIkl
	3T/ZQYYyCyxmlWhYcgFsqLBApMTBBTuhtk1ikni0dRtYglNAU6Lx0UywDcwC6hKT5i1ihrDl
	JTavecs8gVFgFpIls5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSCx+3cG4
	9JjVIUYBDkYlHt4d942ChVgTy4orcw8xSnAwK4nwqi03DhbiTUmsrEotyo8vKs1JLT7EyMTB
	KdXAuLYthvl2RCCvw5KI15nhdX494r367T62+pF3lMKy/7GtDYhb5JPF21X3c1OwWW3Ze3db
	qX0qUlMuLE6Z+1Qiba+17r1T8hfMSvjWC4r6XT3GsTfz3qqE91u6ujwf7L08tytgVZpKR+GO
	loqqM8v8LLY/u2S67NktG9muCofbunfYXCztnsspsRRnJBpqMRcVJwIAASIzRaMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 27/03/14 08:58, Boris BREZILLON wrote:
> This solution solve the problem for this specific case because clks are
> declared in the correct order in imx DTs.
> But, even with your patch I think we could see similar issues by 
> reordering DT nodes...
> 
> The real problem here is that imx platform does not declare the CCM clocks
> dependencies upon ckil, ckih1 and osc fixed clocks within the DT [1], and
> retrieve these clocks when initializing the CCM clocks ([2] and [3]).
> 
> We should try to a add these dependencies in the DT and see if it works.

While presumably all of us agree the dependencies should be correctly
specified in dts I think we should minimize possible regressions by
keeping the clocks registration order as before, i.e. as parsed by the
kernel from DT. Rather than explicitly reversing it, which does not gain
us anything AFAICS. Instead we are seeing regressions where new kernels
stop working with old dtbs.

I'm going to resend the patch replacing list_add() with list_add_tail(),
with this the mvebu platform would work and there should be no regression
on imx and exynos.

Please note that specifying dependencies between CCM on imx and the fixed
clocks might not be enough. If the fixed clocks get matched on "fixed-clock"
compatible some clock specifiers (i.e. those using phandle to the CCM) could
get invalid, since the clocks won't get registered by the ccm driver, but by
the regular fixed clock driver. That means a phandle to different node would
need to be used to reference the fixed clock. I'm not sure if this is the case
for imx, but changes may be needed all over various dts files.
In addition, we should make sure the kernel works with current and modified
dtbs.

> [1] http://lxr.free-electrons.com/source/arch/arm/boot/dts/imx6sl.dtsi#L379
> [2] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk-imx6q.c#L151
> [3] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk.c#L30

-- 
Thanks,
Sylwester
