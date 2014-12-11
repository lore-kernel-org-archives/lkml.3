Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079AbaLKPbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:31:17 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53333 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879AbaLKPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:31:15 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "open list\:ARM\/Rockchip SoC..." 
	<linux-rockchip@lists.infradead.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
	<1418286387-9663-3-git-send-email-tfiga@chromium.org>
	<CAPDyKFoBRxFh+BzHTakij6=NvLm0C-S8eX8+p2odpSwtdTrvoA@mail.gmail.com>
	<CAAFQd5CA374MF-_w=3zqsZctwTcBHz9J_0Ygg4fD_wjg8kLATg@mail.gmail.com>
Date: Thu, 11 Dec 2014 07:31:12 -0800
In-Reply-To: <CAAFQd5CA374MF-_w=3zqsZctwTcBHz9J_0Ygg4fD_wjg8kLATg@mail.gmail.com>
	(Tomasz Figa's message of "Thu, 11 Dec 2014 21:42:47 +0900")
Message-ID: <7h8uiemce7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+ Laurent Pinchart]

Tomasz Figa <tfiga@chromium.org> writes:

> On Thu, Dec 11, 2014 at 8:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

[...]

>>> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct platform_device *pdev)
>>>                 return -ENXIO;
>>>         }
>>>
>>> +       pm_runtime_no_callbacks(dev);
>>> +       pm_runtime_enable(dev);
>>> +
>>> +       /* Synchronize state of the domain with driver data. */
>>> +       pm_runtime_get_sync(dev);
>>> +       iommu->is_powered = true;
>>
>> Doesn't the runtime PM status reflect the value of "is_powered", thus
>> why do you need to have a copy of it? Could it perpahps be that you
>> try to cope with the case when CONFIG_PM is unset?
>>
>
> It's worth noting that this driver fully relies on status of other
> devices in the power domain the IOMMU is in and does not enforce the
> status on its own. So in general, as far as my understanding of PM
> runtime subsystem, the status of the IOMMU device will be always
> suspended, because nobody will call pm_runtime_get() on it (except the
> get and put pair in probe). So is_powered is here to track status of
> the domain, not the device. Feel free to suggest a better way, though.

I still don't like these notifiers.  I think they add ways to bypass
having proper runtime PM implemented for devices/subsystems.

>From a high-level, the IOMMU is just another device inside the PM
domain, so ideally it should be doing it's own _get() and _put() calls
so the PM domain code would just do the right thing without the need for
notifiers.

No knowing a lot about the IOMMU API, I'm guessing the reason you're not
doing that is because the IOMMU API currently doesn't have an easy way
to keep track of *active* users so it's not obvious where to put those
_get and _put calls.  If that doesn't exist, perhaps a simple
iommu_get() and iommu_put() API needs to be introduced (which inside the
IOMMU core would just do runtime PM calls) so that users of the IOMMU
could inform the subsystem that the IOMMU is needed and it should not be
powered off.

I Cc'd Laurent because I know he's thought about this before from the
IOMMU side, and not sure if he came up with a solution.

Kevin
