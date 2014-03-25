Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaCYLTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:19:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37862 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaCYLTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:19:47 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-18-533166507dc2
Message-id: <5331664E.2050008@samsung.com>
Date: Tue, 25 Mar 2014 12:19:42 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mturquette@linaro.org
Cc: gregkh@linuxfoundation.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
 <1393870975-21020-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1393870975-21020-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xq7oBaYbBBj/3mljMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu8Wmx9dYLS7vmsNmcfsyr8XaI3fZLZZev8hk8XTCRTaL1r1H2C1m
	TH7JZrF+xmsWBz6PNfPWMHq0NPeweVzu62Xy2LSqk83jzrU9bB77565h99i8pN6jb8sqRo/P
	m+QCOKO4bFJSczLLUov07RK4Mv5tXcNeMEWp4t73XWwNjM8luhg5OSQETCR+NVxjhbDFJC7c
	W8/WxcjFISSwlFGi4/Q/ZgjnE6PEnIPNYFW8AloSk69vYwGxWQRUJdbevcsIYrMJGEr0Hu0D
	s0UFIiTmTtzMBlEvKPFj8j2wehGBWIkNz/YyggxlFpjCJPHl6USwImGBaIlvncvAioQEmoG2
	rS4AsTkF3CU+HG0FizML6Ejsb53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dTS5ILi
	pPRcI73ixNzi0rx0veT83E2MkJj6uoNx6TGrQ4wCHIxKPLwbTA2ChVgTy4orcw8xSnAwK4nw
	GoYZBgvxpiRWVqUW5ccXleakFh9iZOLglGpgvDPvgLp36zVV+TnO3OdWq6+ML3+4ojJwpd2X
	lZWVDKfZEw+6lF/b05Lx4Jn3H5UVSxkKHt9auzW+Opx58y9txblWVo/PsM5r+u06qdxB5lbi
	kgs2WXFRdR6T107Jmqy7RnPe2ZjuFPe80qQpPPG/5/ybm75ov3Dh9fiYuxLRBmIWZ3lbXqh6
	KbEUZyQaajEXFScCAIMn85WHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/14 19:22, Sylwester Nawrocki wrote:
> This function adds a notifier callback run before a driver is bound
> to a device. It will configure any parent clocks and clock frequencies
> according to values of 'clock-parents' and 'clock-rates' DT properties
> respectively.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v1:
>  - the helper function to parse and set assigned clock parents and
>    rates made public so it is available to clock providers to call
>    directly;
>  - dropped the platform bus notification and call of_clk_device_setup()
>    is is now called from the driver core, rather than from the
>    notification callback;
>  - s/of_clk_get_list_entry/of_clk_get_by_property.
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |   23 ++++++
>  drivers/base/dd.c                                  |    5 ++
>  drivers/clk/clk.c                                  |   77 ++++++++++++++++++++
>  include/linux/clk-provider.h                       |    6 ++
>  4 files changed, 111 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> index 7c52c29..eb8d547 100644
> --- a/Documentation/devicetree/bindings/clock/clock-bindings.txt
> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> @@ -115,3 +115,26 @@ clock signal, and a UART.
>    ("pll" and "pll-switched").
>  * The UART has its baud clock connected the external oscillator and its
>    register clock connected to the PLL clock (the "pll-switched" signal)
> +
> +==Assigned clock parents and rates==
> +
> +Some platforms require static configuration of (parts of) the clock controller
> +often determined by the board design. Such a configuration can be specified in
> +a clock consumer node through clock-parents and clock-rates DT properties.
> +The former should contain list of parent clocks in form of phandle and clock
> +specifier pairs, the latter the list of assigned clock frequency values
> +(one cell each).
> +
> +    uart@a000 {
> +        compatible = "fsl,imx-uart";
> +        reg = <0xa000 0x1000>;
> +        ...
> +        clocks = <&clkcon 0>, <&clkcon 3>;
> +        clock-names = "baud", "mux";
> +
> +        clock-parents = <0>, <&pll 1>;

I have some doubts here, i.e. the order in which clocks are being 
configured may be important in some cases. Should the binding then be
specifying that the clocks will be configured in a sequence exactly 
as listed in the clock-parents property ?

E.g. consider part of a clock controller where one of frequencies fed to
a consumer device cannot exceed given value:

                mux1
 200 MHz   0 .--------.
----->-------|--.     |
             |   \____|__                    f1 
 400 MHz   1 |        |  `-+------------------->--
----->-------|-       |    |
             '--------'	   |	  mux2
                           | 0 .---------.
                           `---|--.      |   f2
                               |   \_____|_,---->--
                 100 MHz     1 |         |   (max. 200 MHz)
                 ----->--------|         | 
                               '---------'		

In this case we want to set frequency f1 to 400 MHz and f2 to 100 MHz.
To ensure f2 doesn't exceed 200 MHz at any time, mux2 has to be switched 
to position '1' first and then mux 1 to position '1'.

> +        clock-rates = <460800>;

For clock-rates it's a bit more complicated, since it might require
setting up frequency of some clocks twice - first to a low and then 
to a higher value. Such details could likely be handled by bindings 
of individual devices. Also we could assume the clock tree 
(re)configuration is being done when any consumer clocks are masked 
at the consumer clock gates.

I'm no sure if we should sort the clocks to ensure any parents are set
before the child clocks, or should we rely on the sequence specified 
in devicetree ? I'd assume sorting it wouldn't hurt, there should not 
be relatively many clocks in a single dt node.

> +    };
> +
> +In this example the pll is set as parent of "mux" clock and frequency of "baud"
> +clock is specified as 460800 Hz.

--
Thanks,
Sylwester
