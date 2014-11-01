Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbaKAA3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 20:29:38 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:52068 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaKAA3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 20:29:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe option
Date: Sat, 01 Nov 2014 02:29:42 +0200
Message-ID: <3452823.YQ5FR2FtKz@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1414766416.6537.6.camel@AMDC1943>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com> <20141031142241.GA17547@amd> <1414766416.6537.6.camel@AMDC1943>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On Friday 31 October 2014 15:40:16 Krzysztof Kozlowski wrote:
> On pią, 2014-10-31 at 15:22 +0100, Pavel Machek wrote:
> > On Fri 2014-10-31 10:14:55, Krzysztof Kozlowski wrote:
> >> On pon, 2014-10-20 at 11:04 +0200, Krzysztof Kozlowski wrote:
> >>> Add a simple getter pm_runtime_is_irq_safe() for querying whether
> >>> runtime PM IRQ safe was set or not.
> >>> 
> >>> Various bus drivers implementing runtime PM may use choose to suspend
> >>> differently based on IRQ safeness status of child driver (e.g. do not
> >>> unprepare the clock if IRQ safe is not set).
> >>> 
> >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> >> 
> >> Rafael, Len, Pavel,
> >> 
> >> Is proposed API ok? Do you have any comments?
> >> 
> >> I'll upload whole patchset to Russell's patch tracking system. However
> >> an ack from PM maintainer is probably needed.
> > 
> > I don't like the API. Having callbacks work in different context (irq
> > / noirq) based on what another function reports is ugly.
> > 
> > What is the penalty if we always decide callbacks are not IRQ safe?
> 
> Then pm_runtime_get_sync() could not be called in atomic context. The
> pl330 runtime PM would have to be completely reworked because one
> pm_runtime_get_sync() is called in device_issue_pending which cannot
> sleep (at least in non preemptible kernels). Probably this can be solved
> some way...

Many other drivers suffer from the same problem. While I won't reject your 
proposed fix, I would prefer a more generic approach.

One option that has been discussed previously was to use a work queue to delay 
starting the DMA transfer to an interruptible context where 
pm_runtime_get_sync() could be called. However, as Russell pointed out [1], 
even that won't work in all cases as the DMA slave might need the transfer to 
be started before enabling part of its hardware (OMAP audio seem to be such a 
case).

I've heard a rumor of a possible DMA engine rework to forbid calling the 
descriptor preparation API from atomic context. This could be used as a base 
to implement runtime PM, as DMA slave drivers should not prepare descriptors 
if they don't need to use them. However that's a long term plan, and we need a 
solution sooner than that.

I've been toying with the idea of adding explicit open/close (or whatever we 
would call them) operations to the DMA engine API. Those would be used by DMA 
slave drivers to signal that they will start/stop using the DMA engine.

If (1) we must start the DMA synchronously with a DMA slave call, (2) need to 
sleep to handle PM, and (3) don't want to keep the DMA engine powered for as 
long as one channel is requested, then we need to turn at least preparation as 
not callable in atomic context, or introduce a new operation.

[1] http://www.spinics.net/lists/dmaengine/msg01548.html

> >>> --- a/Documentation/power/runtime_pm.txt
> >>> +++ b/Documentation/power/runtime_pm.txt
> >>> 
> >>> @@ -468,6 +468,10 @@ drivers/base/power/runtime.c and
> >>> include/linux/pm_runtime.h:
> >>>      - set the power.irq_safe flag for the device, causing the
> >>>      runtime-PM
> >>>      
> >>>        callbacks to be invoked with interrupts off
> >>> 
> >>> +  bool pm_runtime_is_irq_safe(struct device *dev);
> >>> +    - return true if power.irq_safe flag was set for the device,
> >>> causing
> >>> +      the runtime-PM callbacks to be invoked with interrupts off
> >>> +
> >>> 
> >>>    void pm_runtime_mark_last_busy(struct device *dev);
> >>>    
> >>>      - set the power.last_busy field to the current time

-- 
Regards,

Laurent Pinchart

