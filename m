Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaIHVhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:37:33 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40184 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaIHVhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:37:31 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] PM / clock_ops: allow to specify custom pm_clk_notifier callback
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 08 Sep 2014 14:37:29 -0700
In-Reply-To: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Fri, 25 Jul 2014 21:31:33 +0300")
Message-ID: <7hr3zln692.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> The CLK PM domain (clock_ops.c) assumes that platform code should always provide
> list of Connection IDs of the clock (con_id) in pm_clk_notifier_block structure.
> Then CLK PM domain uses these con_ids to setup list of clocks per device.
>
> Such approach is inconvenient when devices can have different number
> of clocks. For example, if maximum number of clocks used by
> devices is 4 the pm_clk_notifier_block structure will look like:
>
> static struct pm_clk_notifier_block platform_domain_notifier = {
> 	.pm_domain = &keystone_pm_domain,
> 	.con_ids = { "fck", "opt1", "opt2", "opt3", NULL },
> };
>
> More over, clocks in DT have to be named using only above con_ids:
> 	clocks = <&paclk13>, <&clkcpgmac>, <&chipclk12>;
> 	clock-names = "fck", "opt1", "opt2";
>
> It makes hard to enable/support Runtime PM in case when some HW modules are used
> by different SoCs or there are few version of the same SoC, because clock trees
> can be changed significantly in all such cases.
>
> This patch set allows to specify custom pm_clk_notifier callback from
> platform code and in such way makes CLK PM domain initialization
> more flexible. 

Replacing the pm_clk notifier is essentially replacing the guts of the
clock_ops code.

I think your platform may have left the realm of "simple" platforms that
the clock_ops was intended for.

Since you're essentially gutting clock_ops, have you considered
migrating to genpd and having your own pm_domain ops that manage your clocks?

> Also, It updates Keystone 2 platform code to provide custom
> callback which fills list of clocks for Device with all clocks assigned to this
> Device in DT.
> More over, It's safe for Keystone 2 to perform CLK PM domain initialization
> at device's binding time instead of device's creation time.
>
> I've posted these patches because I need fully enable Runtime PM on Keystone 2
> where all HW modules are controlled using clocks only. That's why CLK PM domain 
> fits our needs perfectly. 

Heh, doesn't seem like a perfect fit to me ;)

> Also, on Keystone 2 clocks are initialized early and
> they are available at device creation time. The main problems from my side are:
>  - every time when support for new HW modules is added the ".con_ids" array 
>    need to be checked and updated;
>  - restriction for clock's names in DT - to be named using only above con_ids
>    It's ugly.
>
> I hope, this approach to be accepted at least as temporal solution until 
> the generic solution is not found.

Sorry if I missed it, but is there ongoing discussion of a more generic
solution other than this one:

> [1] Previously, same problem was discussed in, but no final solution was accepted:
>  "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
>  https://lkml.org/lkml/2014/4/24/1118

Personally, I still like Geert's approach better.

Kevin
