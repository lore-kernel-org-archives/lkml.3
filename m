Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3EILvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 07:51:10 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38583 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3EILvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 07:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org> <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 May 2013 12:50:46 +0100
X-Google-Sender-Auth: bJ23cYLhT8sY1hiiLZv_T7ZUKCE
Message-ID: <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
To: Ming Lei <tom.leiming@gmail.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 11:07 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Thu, May 9, 2013 at 1:18 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>>
>> The most obvious fallback of using late_initcall_sync() also doesn't work
>> since the deferred probing work initated during late_initcall() is done in
>> a workqueue. So, frameworks that want to wait for all devices to finish
>> probing during init will now have to wait for the deferred workqueue to
>> finish it's work. This patch adds a wait_for_init_deferred_probe_done() API
>
> flush_workqueue() has been added in deferred_probe_initcall(), so looks it
> should be OK for your problem, doesn't it?

It looks like Saravana is using a kernel that already does that based
on object bb5645e from the diff. So if he is still having problem,
then there is probably another deferred probe that is triggered after
the deferred probe lateinitcall is executed. It would be good to know
what driver is getting deferred past clearing the queue. Or has this
been rebased from an earlier kernel? It may no longer be necessary.

However, if a device that shuts down resources after init has
completed and then cannot turn those resources back on when another
driver requests them then it sounds like there is a bigger design
problem. We're in a hotplug world and most of the time a driver cannot
assume that a resource will never get requested after initcalls have
completed. It sounds like a design bug in the driver if it cannot
handle that use case.

g.
