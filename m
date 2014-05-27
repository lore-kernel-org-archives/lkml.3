Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaE0Tdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:33:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38885 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaE0Tdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:33:40 -0400
Message-ID: <5384E892.90808@codeaurora.org>
Date: Tue, 27 May 2014 12:33:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Corey Minyard <cminyard@mvista.com>,
        linux-rt-users@vger.kernel.org, minyard@acm.org,
        linux-kernel@vger.kernel.org, Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4475199.26Fs5MKAfh@wuerfel> <5384DF47.2070904@codeaurora.org> <6082113.tHepRBe99K@wuerfel>
In-Reply-To: <6082113.tHepRBe99K@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/14 12:27, Arnd Bergmann wrote:
> On Tuesday 27 May 2014 11:53:59 Stephen Boyd wrote:
>> On 05/27/14 11:49, Arnd Bergmann wrote:
>>> You also commented in that thread about stop_critical_timings()/
>>> start_critical_timings(). Corey, can you look at that, too? I
>>> think it's designed to avoid the issue you are seeing but
>>> for some reason doesn't.
>> I sent a patch last week to "solve" this problem. I'm not sure if it's
>> right but it works for me.
>>
>> https://lkml.org/lkml/2014/5/19/607
> I think that one was also wrong, as the intention of the existing
> stop_critical_timings() function is already to do the same that
> Corey's patch does, i.e. stop the trace before we go to idle as
> if we were turning IRQs on.

stop_critical_timings() is called in the generic idle loop. It looks
like stop_critical_timings() just isn't written correctly. All it does
is turn off the tracer, but it doesn't prevent future calls to
spinlocks, etc. from causing the tracer to turn on again between calls
to stop/start_critical_timings(). It seems better to prevent any more
tracing from happening between a call to stop_critical_timings() and
start_critical_timings() so we don't have to litter calls to that
function throughout the idle path.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

