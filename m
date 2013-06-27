Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3F0HCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:02:39 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53108 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3F0HCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130626175722.GA20226@jshin-Toonie>
References: <51C87ADC.4070409@canonical.com>
	<CAKohponCrC93D88Fgg_3LKsLG0KMeCVKsTEoy-N3jsdUQdgWvA@mail.gmail.com>
	<20130625161935.GA10208@jshin-Toonie>
	<CAKohpomSa0FRviZHkkJOeUUxubbzueVb3yyP5G8ASwpRB6wANQ@mail.gmail.com>
	<20130626142852.GA2326@jshin-Toonie>
	<CAKohpom_jHQeR2FKFS3-RkxpPrJvekw8pDb-qnApnzu-VqreBQ@mail.gmail.com>
	<20130626175722.GA20226@jshin-Toonie>
Date: Thu, 27 Jun 2013 12:32:36 +0530
Message-ID: <CAKohpo=UTmpLmyQs5+xLNnCLMCeZHNQT3USjmK1NTaFJLNQg-Q@mail.gmail.com>
Subject: Re: od_set_powersave_bias: NULL pointer dereference
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 23:27, Jacob Shin <jacob.shin@amd.com> wrote:
> On Wed, Jun 26, 2013 at 08:02:29PM +0530, Viresh Kumar wrote:
>> On 26 June 2013 19:58, Jacob Shin <jacob.shin@amd.com> wrote:
>> > On Wed, Jun 26, 2013 at 12:18:27PM +0530, Viresh Kumar wrote:
>>
>> >> I am not sure if this is enough. What if we had ondemand as the
>> >> governor initially, then we changed it to something else. Now also
>> >> cur_policy contains a address and isn't zero.
>
> I just tested this case with this patch applied, and did not have any
> problems.

Try this:
- you need a system with multiple policy groups to test it
- Suppose we have two groups of CPUs: 0 and 1
- Set ondemand as governor for both
- change governor of group 1 to something else (we still have valid policy
struct in Ondemand)
- offline all CPUs from group 1. this will free struct cpufreq_policy
- Online these CPUs back, this will reallocate policy
- Now run this function, the earlier policy struct is already freed and
you are accessing it here.

>> >> >                 cpumask_or(&done, &done, policy->cpus);
>> >> > +
>> >> > +               if (policy->governor != &cpufreq_gov_ondemand)
>> >> > +                       continue;
>> >
>> > This should catch that case no ?
>>
>> Policy might be freed and reallocated by then. And so doing
>> policy->governor is dangerous.
>
> Are you worried that after we have passed the above if check, and
> before we access ->tuner governor change might occur?
>
> Is there something synonymous to get/put_online_cpus() for cpufreq to
> prevent governor change while we update ->tuner values?
>
> Otherwise, should just spinlock?

No, i wasn't worrying about this but a sequence of events that I told to
you earlier.

Replying to your other mail:
> Hm . any hints on how to check for if ondemand is running on this CPU
> or not ? I'm not sure what the best way to handle this is ..

Make cur_policy zero in cpufreq_governor_dbs() for
CPUFREQ_GOV_STOP notification. This will make sure we use correct
policy pointer.
