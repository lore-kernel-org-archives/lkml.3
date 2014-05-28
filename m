Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaE1A2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:28:13 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60212 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaE1A2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:28:10 -0400
Message-ID: <53852D96.60006@acm.org>
Date: Tue, 27 May 2014 19:28:06 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Stephen Boyd <sboyd@codeaurora.org>, Corey Minyard <cminyard@mvista.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4475199.26Fs5MKAfh@wuerfel> <5384DF47.2070904@codeaurora.org> <6082113.tHepRBe99K@wuerfel>
In-Reply-To: <6082113.tHepRBe99K@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 02:27 PM, Arnd Bergmann wrote:
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
>
> Corey, does it work for you if you replace the new trace_hardirqs_on()
> you added with time_hardirqs_on() or stop_critical_timing()?

Well, more information on this.  It turns out that the generic idle loop
calls stop_critical_timing() and start_critical timing(), so the
arch_cpu_idle() shouldn't have to.

However, the idle loop calls rcu_idle_enter() after it calls
stop_critical_timing(), and that is resetting the critical timing, it
appears.  It's disabling/enabling interrupts in rcu_idle_enter().  If I
switch the order of the rcu_idle and critical timing calls, the issue
goes away.

Stephen's patch does not seem to be necessary for my issue. I tried with
the patch applied, too.  It doesn't seem to hurt, at least.  It did not
fix the problem by itself, though.

-corey
