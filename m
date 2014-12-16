Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaLPTdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:33:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44794 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaLPTds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:33:48 -0500
Message-ID: <54908904.9060908@ti.com>
Date: Tue, 16 Dec 2014 13:33:24 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Lokesh Vutla <lokeshvutla@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca> <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca> <20141214044517.GD24110@csclub.uwaterloo.ca> <549018EC.8020207@ti.com> <20141216145856.GA23358@kahuna> <20141216163657.GL24110@csclub.uwaterloo.ca> <54908128.7040005@ti.com> <20141216192740.GN24110@csclub.uwaterloo.ca>
In-Reply-To: <20141216192740.GN24110@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 01:27 PM, Lennart Sorensen wrote:
>> I see why arch_timer_freq might skip the rounding error of 39, 15 and
>> 55 Vs existing logic which is possibly at a truncation error risk
>> (without errata for sysclk 13, 26 and 27MHz).
>>
>> all you'd probably need to do is cast rate, num and den to unsigned
>> long and have a common computation logic.
> 
> If that is acceptable, then sure I can do that.  I liked avoiding casts
> in general though.
> 
>> if you'd really want to handle truncation error, it must be a separate
>> patch of it's own - I would not mix it with the errata fix.
> 
> Well there is no error in the existing code because the rate / den
> is always a clean integer division.  The problem is introduced by the

key is "there is no error in existing code for existing value" :) ->
the same code for new values will fail. and introducing (rate * num) /
den without cast will fail for old values.

> SYSCLK1 / 610 used by the emulated clock which is not a clean division.
> 
> So for the existing logic, the calculation was perfect.  It is only for
> the errata case that it is a problem.
> 
> So I think leaving the existing calculation but moved up works well,
> and then having the alternate order calculation only in the errata case
> seemed cleaner and avoids casts and 64bit math which I thought was
> overall desirable.

In general using DIV_ROUND_UP and family of macros(in kernel.h) is the
right way of doing division in similar cases in Linux kernel. And for
the same functionality, we want a common equation - if it does not fit
well for all values (even if we introduce new values), then we must
come to a better equation that will work for all values. What we do
not do is to have two equations meant for doing the same thing.


-- 
Regards,
Nishanth Menon
