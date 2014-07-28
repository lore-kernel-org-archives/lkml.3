Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaG1RDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:03:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49071 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaG1RDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:03:09 -0400
Message-ID: <53D68CC4.1010704@ti.com>
Date: Mon, 28 Jul 2014 20:47:48 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, geert+renesas@glider.be
CC: laurent.pinchart@ideasonboard.com, ulf.hansson@linaro.org,
        khilman@linaro.org, mturquette@linaro.org, tomasz.figa@gmail.com,
        ben.dooks@codethink.co.uk, horms@verge.net.au, magnus.damm@gmail.com,
        rjw@rjwysocki.net, linux-sh@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks
 handled by clock_ops domain
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>	<1402592023-13416-1-git-send-email-grygorii.strashko@ti.com>	<1402592023-13416-3-git-send-email-grygorii.strashko@ti.com> <20140728140533.6E916C4116F@trevor.secretlab.ca>
In-Reply-To: <20140728140533.6E916C4116F@trevor.secretlab.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant.

On 07/28/2014 05:05 PM, Grant Likely wrote:
> On Thu, 12 Jun 2014 19:53:43 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>> Use "clkops-clocks" property to specify clocks handled by
>> clock_ops domain PM domain. Only clocks defined in "clkops-clocks"
>> set of clocks will be handled by Runtime PM through clock_ops
>> Pm domain.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   drivers/of/of_clk.c |    7 ++-----
>>   1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/of/of_clk.c b/drivers/of/of_clk.c
>> index 35f5e9f..5f9b90e 100644
>> --- a/drivers/of/of_clk.c
>> +++ b/drivers/of/of_clk.c
>> @@ -86,11 +86,8 @@ int of_clk_register_runtime_pm_clocks(struct device_node *np,
>>   	struct clk *clk;
>>   	int error;
>>   
>> -	for (i = 0; (clk = of_clk_get(np, i)) && !IS_ERR(clk); i++) {
>> -		if (!clk_may_runtime_pm(clk)) {
>> -			clk_put(clk);
>> -			continue;
>> -		}
>> +	for (i = 0; (clk = of_clk_get_from_set(np, "clkops", i)) &&
>> +		     !IS_ERR(clk); i++) {
> 
> This really looks like an ABI break to me. What happens to all the
> existing platforms who don't have this new clkops-clocks in their device
> tree?

Agree. This patch as is will break such platforms.
As possible solution for above problem - the NULL can be used as clock's prefix
by default and platform code can configure new value of clock's prefix during
initialization.
In addition, to make this solution full the of_clk_get_by_name() will
need to be modified too.

But note pls, this is pure RFC patches which I did to find out the answer on questions:
- What is better: maintain Runtime PM clocks configuration in DT or in code?

- Where and when to call of_clk_register_runtime_pm_clocks()?
  Bus notifier/ platform core/ device drivers

Also, May be platform dependent solution [1] can be acceptable for now?

[1] https://lkml.org/lkml/2014/7/25/630

Best regards,
-grygorii

