Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaIINmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:42:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52227 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbaIINmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:42:09 -0400
Message-ID: <540F0381.7010500@ti.com>
Date: Tue, 9 Sep 2014 16:41:21 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] PM / clock_ops: allow to specify custom pm_clk_notifier
 callback
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com> <7hr3zln692.fsf@linaro.org>
In-Reply-To: <7hr3zln692.fsf@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On 09/09/2014 12:37 AM, Kevin Hilman wrote:
> Grygorii Strashko <grygorii.strashko@ti.com> writes:
> 
>> The CLK PM domain (clock_ops.c) assumes that platform code should always provide
>> list of Connection IDs of the clock (con_id) in pm_clk_notifier_block structure.
>> Then CLK PM domain uses these con_ids to setup list of clocks per device.
>>
>> Such approach is inconvenient when devices can have different number
>> of clocks. For example, if maximum number of clocks used by
>> devices is 4 the pm_clk_notifier_block structure will look like:
>>
>> static struct pm_clk_notifier_block platform_domain_notifier = {
>> 	.pm_domain = &keystone_pm_domain,
>> 	.con_ids = { "fck", "opt1", "opt2", "opt3", NULL },
>> };
>>
>> More over, clocks in DT have to be named using only above con_ids:
>> 	clocks = <&paclk13>, <&clkcpgmac>, <&chipclk12>;
>> 	clock-names = "fck", "opt1", "opt2";
>>
>> It makes hard to enable/support Runtime PM in case when some HW modules are used
>> by different SoCs or there are few version of the same SoC, because clock trees
>> can be changed significantly in all such cases.
>>
>> This patch set allows to specify custom pm_clk_notifier callback from
>> platform code and in such way makes CLK PM domain initialization
>> more flexible.
> 
> Replacing the pm_clk notifier is essentially replacing the guts of the
> clock_ops code.
> 
> I think your platform may have left the realm of "simple" platforms that
> the clock_ops was intended for.
> 
> Since you're essentially gutting clock_ops, have you considered
> migrating to genpd and having your own pm_domain ops that manage your clocks?

Yes. I've thought about using genpd. But:
- PM domain is not merged in 3.17 and I don't know if it will be merged in 3.18 :(
http://www.spinics.net/lists/arm-kernel/msg357003.html

- To switch using PM domains I will need to create PM domain node PER EACH device,
(if I understand PM domain bindings right). For example:

+power_netcp: power-controller@0 {
+		compatible = "keystone,power-controller";
+		#power-domain-cells = <0>;
+		clocks = <&clkcpgmac>, <&clkpa>, <&chipclk12>;
+	};

netcp: netcp@2090000 {
		reg = <0x2620110 0x8>;
+		power-domains = <&power_netcp>;
...
}

- I'm not sure that such DT- definition will be accepted - 
It's not obviously a HW definitions.

Looks like, I'll have no choice as only switch to genpd even if it will 
introduce code & data over head.

> 
>> Also, It updates Keystone 2 platform code to provide custom
>> callback which fills list of clocks for Device with all clocks assigned to this
>> Device in DT.
>> More over, It's safe for Keystone 2 to perform CLK PM domain initialization
>> at device's binding time instead of device's creation time.
>>
>> I've posted these patches because I need fully enable Runtime PM on Keystone 2
>> where all HW modules are controlled using clocks only. That's why CLK PM domain
>> fits our needs perfectly.
> 
> Heh, doesn't seem like a perfect fit to me ;)
> 
>> Also, on Keystone 2 clocks are initialized early and
>> they are available at device creation time. The main problems from my side are:
>>   - every time when support for new HW modules is added the ".con_ids" array
>>     need to be checked and updated;
>>   - restriction for clock's names in DT - to be named using only above con_ids
>>     It's ugly.
>>
>> I hope, this approach to be accepted at least as temporal solution until
>> the generic solution is not found.
> 
> Sorry if I missed it, but is there ongoing discussion of a more generic
> solution other than this one:

Yep. :( But It's ongoing more than 2 months already and seems there is no
light at the end of tunnel.

> 
>> [1] Previously, same problem was discussed in, but no final solution was accepted:
>>   "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
>>   https://lkml.org/lkml/2014/4/24/1118
> 
> Personally, I still like Geert's approach better.
> 

Unfortunately, Geert is not going to continue working on it (as I know).

Thanks for your comments.
I agree. This solution isn't good - it's just fast attempt to solve problem
with minimal changes in common code.


Regards,
-grygorii


