Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaGABHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:07:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44518 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaGABHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:07:51 -0400
Message-ID: <53B209E5.1050701@codeaurora.org>
Date: Mon, 30 Jun 2014 18:07:49 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add tracepoints for hardware operations
References: <1404172599-10171-1-git-send-email-sboyd@codeaurora.org> <20140630205211.3d114169@gandalf.local.home>
In-Reply-To: <20140630205211.3d114169@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/14 17:52, Steven Rostedt wrote:
> On Mon, 30 Jun 2014 16:56:39 -0700
> Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> @@ -483,10 +486,12 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
>>  		return;
>>  
>>  	if (__clk_is_prepared(clk)) {
>> +		trace_clk_unprepare(clk);
> Does it make sense to do these when clk->ops->unprepared_unused or
> uprepare is not set?
>
> You can use DEFINE_EVENT_CONDITIONAL() and add as condition:
>
>    clk->ops->unprepared_unused || clk->ops->unprepare
>

Neat. I don't know if we actually want to do that though. If we always
record an event even when the hardware doesn't support the operation we
get information about events happening to the clock from a software
perspective. If that isn't important, then we can probably just put it
under the if conditions.

>
>>  		if (clk->ops->enable) {
>>  			ret = clk->ops->enable(clk->hw);
>>  			if (ret) {
>> @@ -945,6 +965,7 @@ static int __clk_enable(struct clk *clk)
>>  				return ret;
> It may make even more sense to add the tracepoints within the if
> statement. Especially if you have a return on error.
>
>

Right. I was thinking that no "clk*_complete" event would mean there was
some error. Detecting that case is not so easy though. It may be better
to always have the completion event so we know how long hardware
operations take and so that error handling is simpler.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

