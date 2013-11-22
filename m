Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3KVQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:42:33 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56052 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3KVQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:42:32 -0500
Message-ID: <528F8959.7080207@ti.com>
Date: Fri, 22 Nov 2013 10:42:01 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <benoit.cousson@linaro.org>
Subject: Re: [PATCH 5/8] ARM: OMAP2+: timer: Introduce OF-friendly clocksource/clockevent
 system timers
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-6-git-send-email-joelf@ti.com> <CAL_JsqKS=cGeAhj+K04SOtA8nJRR3MXxS3ry-kzjQOkZx3yK4g@mail.gmail.com>
In-Reply-To: <CAL_JsqKS=cGeAhj+K04SOtA8nJRR3MXxS3ry-kzjQOkZx3yK4g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 09:58 AM, Rob Herring wrote:
> On Thu, Nov 21, 2013 at 7:56 PM, Joel Fernandes <joelf@ti.com> wrote:
>> This work is a migration effort of OMAP system timers to the
>> clocksource/clockevent framework. Consider this as a first-pass in this effort.
>> There are few cleanups that need to be done first. The HWMOD code is
>> intertwined with the timer code. HWMOD code cleanups in the future will
>> hopefully make most of this code go away, so till then we separate out the
>> power/clocks portion of the code from the actual timer bits.  This will
>> facilitate near-future work of adapting the system timer as a clocksource.
>>
>> New functions for OF-only boot are introduced, and we can soon delete the old
>> versions once we migrate all platforms. Currently only AM335x is migrated and
>> testedA new omap_generic_timer_init function is introduced for DT platforms.
>> Code required earlier for non-DT platforms such as setup of timer IDs and timer
>> parent clock is not required.  parent clocks are automatically setup by the mux
>> clock driver through DT so they no longer need to be hardcoded.
>>
>> The init code will try to pick the best timer for clocksource and clockevent
>> however bindings are added to force a particular timer as clocksource or
>> clockevent through DT.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  .../devicetree/bindings/arm/omap/timer.txt         |  12 ++
>>  arch/arm/mach-omap2/common.h                       |   1 +
>>  arch/arm/mach-omap2/timer.c                        | 235 +++++++++++++++++++++
>>  3 files changed, 248 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
>> index d02e27c..6cf7a75 100644
>> --- a/Documentation/devicetree/bindings/arm/omap/timer.txt
>> +++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
>> @@ -32,6 +32,18 @@ Optional properties:
>>  - ti,timer-secure:     Indicates the timer is reserved on a secure OMAP device
>>                         and therefore cannot be used by the kernel.
>>
>> +- ti,timer-clockevent,
>> +  ti,timer-clocksource These properties force the system timer code to choose
>> +                       the particular timer as a clockevent or clocksource.
>> +                       If these properties are not specified, the timer code
>> +                       picks up a "ti,timer-alwon" as the clocksource and a
>> +                       timer containing one of the following properties as
>> +                       the clockevent in the following order:
>> +                               ti,timer-alwon
>> +                               ti,timer-dsp
>> +                               ti,timer-pwm
>> +                               ti,timer-secure
> 
> These properties were added specifically for the reason of avoiding
> linux specific properties like these. When is this not sufficient?

Some platforms cannot use certain timers as clockevents and clocksource, to keep
this code functionally equivalent and working, I added these properties so that
its possible to select specific timers as clockevents/sources as was being done
in the non-DT case. I'm open to suggestions for doing this in a better way for DT.

> 
> And I agree with the comment to use OF_CLKSRC.
> 

There are difficulties I mentioned in a previous post [1] stating why it may not
be possible to use OF_CLKSRC macros, and still keep the code functionally
equivalent to when it was non-DT.

thanks,

-Joel

[1] http://marc.info/?l=linux-arm-kernel&m=138513299917850&w=2


