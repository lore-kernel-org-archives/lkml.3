Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaLQSZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:25:16 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39931 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaLQSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:25:12 -0500
From: Kevin Hilman <khilman@kernel.org>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API pm_genpd_dev_need_restore to use restore types
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
	<54901341.20106@samsung.com> <7h61dbdz5a.fsf@deeprootsystems.com>
	<CADGdYn4WQ6i29ecTthu7eNUfSSQ--YESGyHcA1_9CdK-h53hxA@mail.gmail.com>
Date: Wed, 17 Dec 2014 10:25:09 -0800
In-Reply-To: <CADGdYn4WQ6i29ecTthu7eNUfSSQ--YESGyHcA1_9CdK-h53hxA@mail.gmail.com>
	(amit daniel kachhap's message of "Wed, 17 Dec 2014 20:06:48 +0530")
Message-ID: <7h4msub0ca.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap <amit.daniel@samsung.com> writes:

> On Wed, Dec 17, 2014 at 3:40 AM, Kevin Hilman <khilman@kernel.org> wrote:
>> Marek Szyprowski <m.szyprowski@samsung.com> writes:
>>
>>> Hello,
>>>
>>> On 2014-12-13 17:51, Amit Daniel Kachhap wrote:
>>>> Instead of using bool to restore suspended devices initially, use flags
>>>> like GPD_DEV_SUSPEND_INIT, GPD_DEV_RESTORE_INIT and GPD_DEV_RESTORE_FORCE.
>>>> The first two flags will be similar to the existing true/false functionality.
>>>> The third flag may be used to force restore of suspended devices
>>>> whenever their associated power domain is turned on.
>>>>
>>>> Currently, PD power off function powers off all the associated unused
>>>> devices. The functionality added in this patch is similar to it.
>>>>
>>>> This feature may be used for those devices which are always in ON state
>>>> if the PD associated with them is ON but may need local runtime resume
>>>> and suspend during PD On/Off. These devices (like clock) may not implement
>>>> complete pm_runtime calls such as pm_runtime_get/pm_runtime_put due to
>>>> subsystems interaction behaviour or any other reason.
>>>>
>>>> The model works like,
>>>>      DEV1 (Attaches itself with PD but no calls to pm_runtime_get and
>>>>      /       pm_runtime_put. Its local runtime_suspend/resume is invoked via
>>>>     /        GPD_DEV_RESTORE_FORCE option)
>>>>    /
>>>> PD -- DEV2 (Implements complete PM runtime and calls pm_runtime_get and
>>>>    \ pm_runtime_put. This in turn invokes PD On/Off)
>>>>     \
>>>>      DEV3 (Similar to DEV1)
>>>>
>>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>
>>> The idea of adding new gen_pd flag and reusing runtime pm calls intead
>>> of additional notifiers looks promising, but I have some doubts.
>>
>> I agree, this is better than notifiers, but I have some doubts too.
>
> Thanks,
>
>>
>>> don't see any guarantee that devices with GPD_DEV_RESTORE_FORCE flag
>>> will be suspended after all "normal" devices and restored before
>>> them. Without such assumption it will be hard to use this approach for
>>> iommu related activities, because device might need to use (in its
>>> suspend/resume callbacks) the functionality provided by the other
>>> device with GPD_DEV_RESTORE_FORCE flag. Maybe some additional flags
>>> like suspend/resume priority (or more flags) will solve somehow this
>>> dependency.
>>
>> At a deeper level, the problem with this approach is that this is more
>> generically a runtime PM dependency problem, not a genpd problem.  For
>> example, what happens when the same kind of dependency exists on a
>> platform using a custom PM domain instead of genpd (like ACPI.) ?
>
> This patch does not try to solve runtime PM dependencies between
> devices. As an example, if there are three devices D1, D2, D3 in a
> power domain. Device D3 would update the power domain state
> requirement using runtime PM API but devices D1 and D2 do not want to
> control the domain but just want to be notified when the power domain
> state changes.

Yes, I understand that.  

The question is: what do you do when you have the same dependency
problem and you're not using genpd (for example, some SoCs have
implmeented their own PM domains, and ACPI devices are managed by their
own PM domain, not genpd.)

>> What's needed to solve this problem is a generalized way to have runtime
>> PM dependencies between devices.  Runtime PM already automatically
>> handles parent devices as one type of dependent device (e.g. a parent
>> device needs to be runtime PM resumed before its child.)  So what's
>> needed is a generic way to other PM dependencies with the runtime PM
>> core (not the genpd core.)
>
> Considering the example above with three devices, device D1 and D2 are
> passive components in this power domain. These devices only need to
> know the state changes of the power domains but would not control the
> power domain themselves nor put forth constraints in the power domain
> state changes. So I did not clearly understand as to how this example
> could be solved by introducing changes in runtime PM core.

Your solution only solves the problems for devices managed by genpd.

If I understood your example correctly, what you really want to solve
this problem more generically is to be able to tell the runtime PM core
that D3 has a dependency on D1 and D2.  Then, whenver the runtime PM
core is doing get/put operations for D3, it needs to also do them for D1
and D2.

This will accomplish the same as your proposed approach, but work for
any devices in any PM domains.

Kevin

