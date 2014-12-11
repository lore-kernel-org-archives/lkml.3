Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaLKMnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:43:12 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33658 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoBRxFh+BzHTakij6=NvLm0C-S8eX8+p2odpSwtdTrvoA@mail.gmail.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
 <1418286387-9663-3-git-send-email-tfiga@chromium.org> <CAPDyKFoBRxFh+BzHTakij6=NvLm0C-S8eX8+p2odpSwtdTrvoA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 11 Dec 2014 21:42:47 +0900
Message-ID: <CAAFQd5CA374MF-_w=3zqsZctwTcBHz9J_0Ygg4fD_wjg8kLATg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Heiko Stuebner <heiko@sntech.de>, Joerg Roedel <joro@8bytes.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Thu, Dec 11, 2014 at 8:58 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 11 December 2014 at 09:26, Tomasz Figa <tfiga@chromium.org> wrote:
>> This patch modifies the rockchip-iommu driver to consider state of
>> the power domain the IOMMU is located in. When the power domain
>> is powered off, the IOMMU cannot be accessed and register programming
>> must be deferred until the power domain becomes enabled.

[snip]

>> @@ -988,11 +1107,28 @@ static int rk_iommu_probe(struct platform_device *pdev)
>>                 return -ENXIO;
>>         }
>>
>> +       pm_runtime_no_callbacks(dev);
>> +       pm_runtime_enable(dev);
>> +
>> +       /* Synchronize state of the domain with driver data. */
>> +       pm_runtime_get_sync(dev);
>> +       iommu->is_powered = true;
>
> Doesn't the runtime PM status reflect the value of "is_powered", thus
> why do you need to have a copy of it? Could it perpahps be that you
> try to cope with the case when CONFIG_PM is unset?
>

It's worth noting that this driver fully relies on status of other
devices in the power domain the IOMMU is in and does not enforce the
status on its own. So in general, as far as my understanding of PM
runtime subsystem, the status of the IOMMU device will be always
suspended, because nobody will call pm_runtime_get() on it (except the
get and put pair in probe). So is_powered is here to track status of
the domain, not the device. Feel free to suggest a better way, though.

Best regards,
Tomasz
