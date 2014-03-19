Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaCSFjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:39:04 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49316 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaCSFjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <5240506.FBRh89S9Lg@vostro.rjw.lan>
References: <1394831037-15553-1-git-send-email-dirk.j.brandewie@intel.com>
	<532899B2.2060106@linux.vnet.ibm.com>
	<53289D9A.8070805@gmail.com>
	<5240506.FBRh89S9Lg@vostro.rjw.lan>
Date: Wed, 19 Mar 2014 11:03:56 +0530
Message-ID: <CAKohpomc9YrBrG2SJFUuixDTNY6qVhq6X39Qv+=j73dFGxQTdQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Add stop callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 06:23, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, March 18, 2014 12:25:14 PM Dirk Brandewie wrote:
>> On 03/18/2014 12:08 PM, Srivatsa S. Bhat wrote:
>> > On 03/18/2014 10:52 PM, dirk.brandewie@gmail.com wrote:
>> >> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>> >>
>> >
>> > I don't mean to nitpick, but generally its easier to deal with
>> > patchsets if you post the subsequent versions in fresh email threads.
>> > Otherwise it can get a bit muddled along with too many other email
>> > discussions in the same thread :-(
>> >
>> >> Changes:
>> >> v2->v3
>> >> Changed the calling of the ->stop() callback to be conditional on the
>> >> core being the last core controlled by a given policy.
>> >>
>> >
>> > Wait, why? I'm sorry if I am not catching up with the discussions on
>> > this issue quickly enough, but I don't see why we should make it
>> > conditional on _that_. I thought we agreed that we should make it
>> > conditional in the sense that ->stop() should be invoked only for
>> > ->setpolicy drivers, right?
>>
>> This was done at Viresh's suggestion since thought there might be value
>> for ->target drivers.
>>
>> Any of the options work for me
>>     called only for set_policy scaling drivers
>
> And that's what we should do *today* in my opinion, unless we want to add
> it to any ->target() drivers *right* now.  Do we want that?

We don't have a platform right now that might want to use it, but people
are doing this during suspend and so there is a high possibility that they
will use it while normal cpu offline as well..

This is what I think:
- We are adding a new callback to struct cpufreq_driver..
- We have a classic case here because a driver (set-policy ones) is both a
driver and governor. And that's why its special..
- All we want here is to give drivers a chance to do something useful on the
CPUs that are going down..
- There is nothing like GOV_STOP for setpolicy drivers as we never needed
it and if we really want that, probably we better register setpolicy drivers as
governors as well (only to a level where they would get GOV_START|STOP|etc)
callbacks and nothing else.
- And so I wanted the ->stop() callback to be more about the driver than the
governor.
- And because a policy contains only the CPUs that share clock line, its
only required to call stop() for last CPU of the policy.

--
viresh
