Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbaKMJDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:03:14 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58262 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaKMJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <1642105.slZZIy9b79@vostro.rjw.lan>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
	<1415802748-30530-6-git-send-email-k.kozlowski@samsung.com>
	<1642105.slZZIy9b79@vostro.rjw.lan>
Date: Thu, 13 Nov 2014 10:03:08 +0100
Message-ID: <CAPDyKFqj8SuGhehR1e=qY-6fd3tPegdhaeBgAB61YjUkSVnzDg@mail.gmail.com>
Subject: Re: [PATCH v11 5/6] dmaengine: pl330: Add PM sleep support
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2014 02:37, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, November 12, 2014 03:32:27 PM Krzysztof Kozlowski wrote:
>> Add system suspend/resume capabilities to the pl330 driver so the amba
>> bus clock could be also unprepared to conserve energy.
>>
>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>> ---
>>  drivers/dma/pl330.c | 37 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 37 insertions(+)
>>
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
>> index c3bd3584f261..fd71777fc565 100644
>> --- a/drivers/dma/pl330.c
>> +++ b/drivers/dma/pl330.c
>> @@ -2627,6 +2627,42 @@ static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
>>       return 0;
>>  }
>>
>> +/*
>> + * Runtime PM callbacks are provided by amba/bus.c driver.
>> + *
>> + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
>> + * bus driver will only disable/enable the clock in runtime PM callbacks.
>> + */
>> +static int __maybe_unused pl330_suspend(struct device *dev)
>> +{
>> +     struct amba_device *pcdev = to_amba_device(dev);
>> +
>> +     if (!pm_runtime_status_suspended(dev)) {
>
> It generally isn't safe to call that in .suspend(), because the status may still
> change in theory.  On the other hand, if you do that in .suspend_late(), you'll
> be safe from that.
>

Just to clarify that statement; it's safe in a ->suspend_late()
callback, because runtime PM has been disabled by the PM core.

That's also the reason why the pm_runtime_force_suspend() helper is
disabling runtime PM, such it may be used in some of the earlier
phases of the system PM callbacks.

Kind regards
Uffe
