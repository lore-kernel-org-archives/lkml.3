Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaFKSog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:36 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51860 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaFKSoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <53982FF7.8030606@samsung.com>
References: <1402446800-4043-1-git-send-email-jonghwa3.lee@samsung.com>
	<CAPDyKFr6aoev3vSmxQOJWDGGFLWyE4eZ_0joQ45-GgZNztYdGA@mail.gmail.com>
	<53982FF7.8030606@samsung.com>
Date: Wed, 11 Jun 2014 20:44:31 +0200
X-Google-Sender-Auth: pZlV_EXwcw9OaQQjFH9Vk3drT8s
Message-ID: <CAJZ5v0gNCFSwfmwaeGevbzica95ZD8CH-FUxD_2VN607-EhXCQ@mail.gmail.com>
Subject: Re: [RFC PATCH] PM: Domain: Add flag to assure that device's runtime
 pm callback is called at once.
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: jonghwa3.lee@samsung.com
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, cw00.choi@samsung.com,
        Myungjoo Ham <myungjoo.ham@samsung.com>, jy0922.shim@samsung.com,
        inki.dae@samsung.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:31 PM,  <jonghwa3.lee@samsung.com> wrote:
> Hi Ulf,
> On 2014년 06월 11일 17:27, Ulf Hansson wrote:
>
>> On 11 June 2014 02:33, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>>> When device uses generic pm domain, its own runtime suspend callback will be
>>> executed only when all devices in the same domain are suspended. However, some
>>> device needs sychronized runtime suspend and not to be deffered.
>>> For those devices, Generic pm domain adds new API for adding device with flag,
>>> which shows that it guerantees driver's runtime suspend will be executed right
>>> away not at the time domain is really powered off.
>>> Existed API, pm_genpd_add_device(), now adds device with flag representing this
>>> device is not needed sychrnoized callback. It will work as same as before.
>>
>> Hi Jonghwa,
>>
>> I understand you have an issue of the behaviour of genpd here and I
>> agree we need a solution, but I am not sure this is the correct one.
>> :-)
>>
>> The current behaviour of how genpd deals with runtime PM suspend
>> callbacks has two severe issues:
>>
>> 1 ) It prevents fine grained power management within a domain. Simply
>> because those resources that are controlled on levels below the
>> pm_domain, can't be put in low power state until the complete domain
>> will be dropped.
>> 2 ) All devices within a domain will be runtime PM suspended at the
>> same time. This causes a thundering herd problem since latencies gets
>> accumulated for each device in a domain.
>>
>> Instead I think we should try to change the default behaviour of genpd
>> and let it invoke the runtime PM callbacks immediately and not wait
>> for the domain to be dropped. Do you think that could work?
>>
>
>
> Yes, I think it could. I didn't understand why genpd prohibits device to be
> suspended separately but puts all devices suspended altogether.

The reason why was because it assumed device-specific suspend to be carried
out by genpd_stop_dev() and the device state to be saved by the runtime
suspend callback of the driver.  Of course, it only makes sense to save
device states if power is going to be removed from the domain and that's
why it was done this way.


> But, I'm just
> afraid to change genpd's behavior totally due to my own inconvenience.
>
> And addition to above problems, there is one more problem due to genpd's current
> bust suspending.
>
> 3) It would break the device dependency. Even if devices request to be suspended
> sequentially considering their dependencies, genpd simply ignores it and let
> them suspended in order of registration. It means suspending order absolutely
> depends on when device is bound to genpd.
>
> Observing 3 definite problems, it looks genpd should be changed. However,
> someone might want to keep it work as like before, who knows? I respectfully ask
> Rafael's opinion.

Well, I don't work on it directly any more.

I'm also not against changing it if that's going to help.  What you need to do,
though, is to audit all code using it and figure out how your changes are going
to affect that code.

Rafael
