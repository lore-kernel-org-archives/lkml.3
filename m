Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaG2Fw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 01:52:59 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:61739 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaG2Fwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 01:52:55 -0400
MIME-Version: 1.0
In-Reply-To: <53D68CC4.1010704@ti.com>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
 <1402592023-13416-1-git-send-email-grygorii.strashko@ti.com>
 <1402592023-13416-3-git-send-email-grygorii.strashko@ti.com>
 <20140728140533.6E916C4116F@trevor.secretlab.ca> <53D68CC4.1010704@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 28 Jul 2014 23:52:34 -0600
X-Google-Sender-Auth: LIF-0JjScGdbluHlevyNG7XpVGs
Message-ID: <CACxGe6uMke5vgzcNC9xUqjr2bHJ4QFHD6YjocSZWq8Ccx8Mm6A@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks
 handled by clock_ops domain
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ulf.hansson@linaro.org, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:47 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> Hi Grant.
>
> On 07/28/2014 05:05 PM, Grant Likely wrote:
>> On Thu, 12 Jun 2014 19:53:43 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>> Use "clkops-clocks" property to specify clocks handled by
>>> clock_ops domain PM domain. Only clocks defined in "clkops-clocks"
>>> set of clocks will be handled by Runtime PM through clock_ops
>>> Pm domain.
>>>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>> ---
>>>   drivers/of/of_clk.c |    7 ++-----
>>>   1 file changed, 2 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/of/of_clk.c b/drivers/of/of_clk.c
>>> index 35f5e9f..5f9b90e 100644
>>> --- a/drivers/of/of_clk.c
>>> +++ b/drivers/of/of_clk.c
>>> @@ -86,11 +86,8 @@ int of_clk_register_runtime_pm_clocks(struct device_node *np,
>>>      struct clk *clk;
>>>      int error;
>>>
>>> -    for (i = 0; (clk = of_clk_get(np, i)) && !IS_ERR(clk); i++) {
>>> -            if (!clk_may_runtime_pm(clk)) {
>>> -                    clk_put(clk);
>>> -                    continue;
>>> -            }
>>> +    for (i = 0; (clk = of_clk_get_from_set(np, "clkops", i)) &&
>>> +                 !IS_ERR(clk); i++) {
>>
>> This really looks like an ABI break to me. What happens to all the
>> existing platforms who don't have this new clkops-clocks in their device
>> tree?
>
> Agree. This patch as is will break such platforms.
> As possible solution for above problem - the NULL can be used as clock's prefix
> by default and platform code can configure new value of clock's prefix during
> initialization.
> In addition, to make this solution full the of_clk_get_by_name() will
> need to be modified too.
>
> But note pls, this is pure RFC patches which I did to find out the answer on questions:
> - What is better: maintain Runtime PM clocks configuration in DT or in code?

In code. I don't think it is workable to embed runtime PM behaviour
into the DT bindings. I think there will be too much variance in what
hardware requires. We can create helpers to make this simpler, but I
don't think it is a good idea to set it up automatically without any
control from the driver itself.

>
> - Where and when to call of_clk_register_runtime_pm_clocks()?
>   Bus notifier/ platform core/ device drivers

I would say in device drivers.

> Also, May be platform dependent solution [1] can be acceptable for now?
>
> [1] https://lkml.org/lkml/2014/7/25/630

I need to look at the series before I comment. I've flagged it and
will hopefully look at it tomorrow.

g.
