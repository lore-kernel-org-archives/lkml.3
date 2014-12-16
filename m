Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaLPWKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:10:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48121 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLPWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:10:28 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rjw@rjwysocki.net,
        len.brown@intel.com, ulf.hansson@linaro.org, tomasz.figa@gmail.com,
        kgene.kim@samsung.com, s.nawrocki@samsung.com, thomas.ab@samsung.com,
        pankaj.dubey@samsung.com, geert+renesas@glider.be,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] PM / Domains: Extend API pm_genpd_dev_need_restore to use restore types
References: <1418489518-7252-1-git-send-email-amit.daniel@samsung.com>
	<54901341.20106@samsung.com>
Date: Tue, 16 Dec 2014 14:10:25 -0800
In-Reply-To: <54901341.20106@samsung.com> (Marek Szyprowski's message of "Tue,
	16 Dec 2014 12:10:57 +0100")
Message-ID: <7h61dbdz5a.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szyprowski <m.szyprowski@samsung.com> writes:

> Hello,
>
> On 2014-12-13 17:51, Amit Daniel Kachhap wrote:
>> Instead of using bool to restore suspended devices initially, use flags
>> like GPD_DEV_SUSPEND_INIT, GPD_DEV_RESTORE_INIT and GPD_DEV_RESTORE_FORCE.
>> The first two flags will be similar to the existing true/false functionality.
>> The third flag may be used to force restore of suspended devices
>> whenever their associated power domain is turned on.
>>
>> Currently, PD power off function powers off all the associated unused
>> devices. The functionality added in this patch is similar to it.
>>
>> This feature may be used for those devices which are always in ON state
>> if the PD associated with them is ON but may need local runtime resume
>> and suspend during PD On/Off. These devices (like clock) may not implement
>> complete pm_runtime calls such as pm_runtime_get/pm_runtime_put due to
>> subsystems interaction behaviour or any other reason.
>>
>> The model works like,
>>      DEV1 (Attaches itself with PD but no calls to pm_runtime_get and
>>      /	pm_runtime_put. Its local runtime_suspend/resume is invoked via
>>     /	GPD_DEV_RESTORE_FORCE option)
>>    /
>> PD -- DEV2 (Implements complete PM runtime and calls pm_runtime_get and
>>    \	pm_runtime_put. This in turn invokes PD On/Off)
>>     \
>>      DEV3 (Similar to DEV1)
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>
> The idea of adding new gen_pd flag and reusing runtime pm calls intead
> of additional notifiers looks promising, but I have some doubts. 

I agree, this is better than notifiers, but I have some doubts too.

> don't see any guarantee that devices with GPD_DEV_RESTORE_FORCE flag
> will be suspended after all "normal" devices and restored before
> them. Without such assumption it will be hard to use this approach for
> iommu related activities, because device might need to use (in its
> suspend/resume callbacks) the functionality provided by the other
> device with GPD_DEV_RESTORE_FORCE flag. Maybe some additional flags
> like suspend/resume priority (or more flags) will solve somehow this
> dependency.

At a deeper level, the problem with this approach is that this is more
generically a runtime PM dependency problem, not a genpd problem.  For
example, what happens when the same kind of dependency exists on a
platform using a custom PM domain instead of genpd (like ACPI.) ?

What's needed to solve this problem is a generalized way to have runtime
PM dependencies between devices.  Runtime PM already automatically
handles parent devices as one type of dependent device (e.g. a parent
device needs to be runtime PM resumed before its child.)  So what's
needed is a generic way to other PM dependencies with the runtime PM
core (not the genpd core.)

If runtime PM handles the dependencies corretcly, then genpd (and any
other PM domain) will get them "for free".

Kevin
