Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaLXRQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:16:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51788 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaLXRQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:16:51 -0500
Message-ID: <549AF4F3.1090600@ti.com>
Date: Wed, 24 Dec 2014 11:16:35 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@chromium.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>	<1418771379-24369-4-git-send-email-dtor@chromium.org>	<549AEE52.9080607@ti.com> <CAE_wzQ92VK6Jv+j-LDTupMJzJj_AZyAqUe2Vxo5YRhkFEFF=sw@mail.gmail.com>
In-Reply-To: <CAE_wzQ92VK6Jv+j-LDTupMJzJj_AZyAqUe2Vxo5YRhkFEFF=sw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 11:09 AM, Dmitry Torokhov wrote:
> On Wed, Dec 24, 2014 at 8:48 AM, Nishanth Menon <nm@ti.com> wrote:
>> On 12/16/2014 05:09 PM, Dmitry Torokhov wrote:
>>> A lot of callers are missing the fact that dev_pm_opp_get_opp_count
>>> needs to be called under RCU lock. Given that RCU locks can safely be
>>> nested, instead of providing *_locked() API, let's take RCU lock inside
>>> dev_pm_opp_get_opp_count() and leave callers as is.
>>
>> While it is true that we can safely do nested RCU locks, This also
>> encourages wrong usage.
>>
>> count = dev_pm_opp_get_opp_count(dev)
>> ^^ point A
>> array   = kzalloc(count * sizeof (*array));
>> rcu_read_lock();
>> ^^ point B
>> .. work down the list and add OPPs..
>> ...
>>
>> Between A and B, we might have had list modification (dynamic OPP
>> addition or deletion) - which implies that the count is no longer
>> accurate between point A and B. instead, enforcing callers to have the
>> responsibility of rcu_lock is exactly what we have to do since the OPP
>> library has no clue how to enforce pointer or data accuracy.
> 
> No, you seem to have a misconception that rcu_lock protects you past
> the point B, but that is also wrong. The only thing rcu "lock"
> provides is safe traversing the list and guarantee that elements will
> not disappear while you are referencing them, but list can both
> contract and expand under you. In that regard code in
> drivers/cpufreq/cpufreq_opp.c is utterly wrong. If you want to count
> the list and use number of elements you should be taking a mutex.
> Luckily all cpufreq drivers at the moment only want to see if OPP
> table is empty or not, so as a stop-gap we can take rcu_lock
> automatically as we are getting count. We won't get necessarily
> accurate result, but at least we will be safe traversing the list.

So, instead of a half solution, lets consider this in the realm of
dynamic OPPs as well. agreed to the point that we only have safe
traversal and pointer validity. the real problem however is with
"dynamic OPPs" (one of the original reasons why i did not add dynamic
OPPs in the original version was to escape from it's complexity for
users - anyways.. we are beyond that now). if OPPs can be removed on
the fly, we need the following:
a) use OPP notifiers to adequately handle list modification
b) lock down list modification (and associated APIs) to ensure that
the original cpufreq /devfreq list is correct.

I still dont see the need to do this half solution.


-- 
Regards,
Nishanth Menon
