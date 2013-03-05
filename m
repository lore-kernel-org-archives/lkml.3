Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3CEGrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:47:36 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47439 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3CEGrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:47:35 -0500
Message-ID: <513594FF.6040106@linaro.org>
Date: Tue, 05 Mar 2013 14:47:27 +0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [RFC PATCH v2 4/4] timekeeping: utilize the suspend-nonstop clocksource
 to count suspended time
References: <1362450426-4232-1-git-send-email-feng.tang@intel.com> <1362450426-4232-5-git-send-email-feng.tang@intel.com> <51359056.60506@linaro.org> <20130305063830.GB5340@feng-snb>
In-Reply-To: <20130305063830.GB5340@feng-snb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 02:38 PM, Feng Tang wrote:
> On Tue, Mar 05, 2013 at 02:27:34PM +0800, John Stultz wrote:
>
>>
>> So this might be ok for an initial implementation, as on the
>> non-stop-tsc hardware, the TSC is the best clocksource available.
>> One concern long term is that there may be cases where the non-stop
>> clocksource is not the most performant clocksource on a system. In
>> that case, we may want to use a non-stop clocksource that is not the
>> current timekeeping clocksource. So that may require some extra
>> clocksource core interfaces to access the non-stop clocksource
>> instead of using the timekeeper's clocksource, also we'll have to be
>> sure to use something other then cycle_last in that case, since
>> we'll need to read the nonstop clocksource at suspend, rather then
>> trusting that forward_now updates cycle_last as is done here.
> Yeah, I just realized this when Jason mentioned the counter_32k on
> OMAP.
>
> So for next step, we may add something in timekeeping.c like
> 	static struct clocksource *suspend_time_cs;
> read and save its counter righer before entering and after getting
> out of suspended state. And create a new struct which includes
> all time suspend related flags, counters, pointers, make it as a
> member of struct timekeeper. Comments?
I'd maybe add it to the clocksource code rather then the timekeeper. 
Have a clocksource_nonstop_clock() accessor which returns a pointer to 
the highest rated clocksource in the clocksource list that has the 
nonstop flag (updating the pointer at registration time, rather then 
scanning the list every time).

That way if we want, we can later define clocksource_nonstop_clock() as 
null, and let the complier optimize out the extra complexity in the 
resume path if the arch doesn't support nonstop clocksource.

thanks
-john
