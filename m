Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaKYMTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:19:12 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26182 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaKYMTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:19:09 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b7-547473baf81f
Message-id: <1416917945.29431.6.camel@AMDC1943>
Subject: Re: [RFC 2/2] clk: samsung: Fix clock disable failure because domain
 being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Date: Tue, 25 Nov 2014 13:19:05 +0100
In-reply-to: <CA+Ln22FTJ8AwNOq+jrA6dK=4ziGFwFT+Ofjr2zE4z=8B4f3QJw@mail.gmail.com>
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
 <1416842312-4405-3-git-send-email-k.kozlowski@samsung.com>
 <CA+Ln22FTJ8AwNOq+jrA6dK=4ziGFwFT+Ofjr2zE4z=8B4f3QJw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xK7q7iktCDFafs7Rou3KQ3eLo7wKL
	/sevmS2ebn7MZLHp8TVWi8u75rBZzDi/j8ni6YSLbBaH37SzWqza9YfRgcvj7/PrLB47Z91l
	99i0qpPN4861PWwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG066PzAVH+CtWfJ/A
	3MD4kruLkZNDQsBEonXiKWYIW0ziwr31bF2MXBxCAksZJc7tP8EM4XxmlNi79iIbSBWvgL5E
	093jLCC2sEC0xK+vD9hBbDYBY4nNy5eA1YgIqEt8m9LPDtLMLLCTWWLWkVawIhYBVYk/bx6B
	2ZwCwRIr+w9BbTjFKHHi/UxWkAQzUPekeYuAEhxANylLNPa7QSwWlPgx+R4LRIm8xOY1b5kn
	MArMQtIxC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKExMXXHYxLj1kdYhTg
	YFTi4b0RVxIixJpYVlyZe4hRgoNZSYT3STJQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2PaXL+V
	J3wXhB2VyFM+ebh4RrGUwnIB1wj5xJ6KMLcHVy/lNvUw9pux3G7V/Lr2SNsnm2Nv7z+atX23
	v8b6aibNtpuav6857kldxLUzY36b30zJFV+jp2y7+uHEYjbnJV2JNzwzYwK75tcu6AzyvX/i
	1EzXC9ONC1WYqqYFzVGd6ZLrybxdxEyJpTgj0VCLuag4EQBnjEj/aQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-25 at 20:35 +0900, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> Please see my comments inline.
> 
> 2014-11-25 0:18 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> > +static int audss_clk_gate_enable(struct clk_hw *hw)
> > +{
> > +       int ret;
> > +
> > +       if (!IS_ERR(pll_in))
> > +               clk_prepare_enable(pll_in);
> 
> Calling clk_prepare_enable() from enable() callback doesn't look like
> a good idea, because enabling is not supposed to sleep, while
> preparing might do so.

Right.

> I guess you have to pre-prepare this clock in probe and then only call
> enable here.

Yes, the prepare won't have any negative effect on energy usage anyway.

> 
> > +       ret = clk_gate_ops.enable(hw);
> > +       if (!IS_ERR(pll_in))
> > +               clk_disable_unprepare(pll_in);
> > +
> > +       return ret;
> > +}
> 
> [snip]
> 
> > +/* TODO: Also mux and div */
> > +const struct clk_ops audss_clk_gate_ops = {
> 
> nit: static const probably?

Yes.

> 
> > +       .enable = audss_clk_gate_enable,
> > +       .disable = audss_clk_gate_disable,
> > +       .is_enabled = audss_clk_gate_is_enabled,
> > +};
> 
> As for the approach itself, maybe you should simply register fully
> custom clocks with clk_register(), without altering
> clk_register_gate() at all and simply calling gate ops whenever
> necessary? I don't know, just a loose idea.

Initially that seemed to me the simplest way to encapsulate gate_ops
calls. However in that approach I should also change clk_register_mux
and clk_register_divider... which complicates this patch and maybe your
idea will be simpler overall.

> By the way, this issue could be probably solved by integrating generic
> clocks with regmap API, since regmap-mmio can automatically control a
> clock.

Indeed but this looks like much bigger task.

Anyway thanks for feedback. I'll prepare another version.

Best regards,
Krzysztof


