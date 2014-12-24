Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLXRJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:09:07 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65178 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaLXRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <549AEE52.9080607@ti.com>
References: <1418771379-24369-1-git-send-email-dtor@chromium.org>
	<1418771379-24369-4-git-send-email-dtor@chromium.org>
	<549AEE52.9080607@ti.com>
Date: Wed, 24 Dec 2014 09:09:02 -0800
Message-ID: <CAE_wzQ92VK6Jv+j-LDTupMJzJj_AZyAqUe2Vxo5YRhkFEFF=sw@mail.gmail.com>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
From: Dmitry Torokhov <dtor@chromium.org>
To: Nishanth Menon <nm@ti.com>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 8:48 AM, Nishanth Menon <nm@ti.com> wrote:
> On 12/16/2014 05:09 PM, Dmitry Torokhov wrote:
>> A lot of callers are missing the fact that dev_pm_opp_get_opp_count
>> needs to be called under RCU lock. Given that RCU locks can safely be
>> nested, instead of providing *_locked() API, let's take RCU lock inside
>> dev_pm_opp_get_opp_count() and leave callers as is.
>
> While it is true that we can safely do nested RCU locks, This also
> encourages wrong usage.
>
> count = dev_pm_opp_get_opp_count(dev)
> ^^ point A
> array   = kzalloc(count * sizeof (*array));
> rcu_read_lock();
> ^^ point B
> .. work down the list and add OPPs..
> ...
>
> Between A and B, we might have had list modification (dynamic OPP
> addition or deletion) - which implies that the count is no longer
> accurate between point A and B. instead, enforcing callers to have the
> responsibility of rcu_lock is exactly what we have to do since the OPP
> library has no clue how to enforce pointer or data accuracy.

No, you seem to have a misconception that rcu_lock protects you past
the point B, but that is also wrong. The only thing rcu "lock"
provides is safe traversing the list and guarantee that elements will
not disappear while you are referencing them, but list can both
contract and expand under you. In that regard code in
drivers/cpufreq/cpufreq_opp.c is utterly wrong. If you want to count
the list and use number of elements you should be taking a mutex.
Luckily all cpufreq drivers at the moment only want to see if OPP
table is empty or not, so as a stop-gap we can take rcu_lock
automatically as we are getting count. We won't get necessarily
accurate result, but at least we will be safe traversing the list.

Thanks.

-- 
Dmitry
