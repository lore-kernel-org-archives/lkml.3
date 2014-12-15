Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaLOClH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:41:07 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:33357 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaLOCku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:40:50 -0500
MIME-Version: 1.0
In-Reply-To: <7ha92sk533.fsf@deeprootsystems.com>
References: <1418286387-9663-1-git-send-email-tfiga@chromium.org>
 <7h8uiemce7.fsf@deeprootsystems.com> <CAPDyKFo6zH4__Odm+RiJCbvXquAQqaLyCAiXrSN6s3KfQhok=A@mail.gmail.com>
 <1576771.dIVCOxU0se@vostro.rjw.lan> <CAAFQd5B28WiWUqmbmROJUa3H25R=Y774NuemTZDvkoa=CvZUsw@mail.gmail.com>
 <7ha92sk533.fsf@deeprootsystems.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 15 Dec 2014 11:32:10 +0900
Message-ID: <CAAFQd5Bqv_VVTcJ_a7tX2L_3aH=zyGohuCM6mQgAkKn+eHu=6w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] iommu: rockchip: Handle system-wide and runtime PM
To: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Heiko Stuebner <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 5:04 AM, Kevin Hilman <khilman@kernel.org> wrote:
> Tomasz Figa <tfiga@chromium.org> writes:
>
> [...]
>
>> We have a power domain, which contains an IOMMU and an IP block, which
>> can do bus transactions through that IOMMU. Of course the IP block is
>> not aware of the IOMMU, because this is just an integration detail and
>> on other platforms using the same IP block the IOMMU might not be
>> there. This implies that the driver for this IP block should not be
>> aware of the IOMMU either, which, on the buffer allocation and mapping
>> side, is achieved by DMA mapping subsystem. We would also want the
>> IOMMU to be fully transparent to that driver on PM side.
>
> An even more exciting problem exists when a CPU is in the same domain as
> other peripherals, those peripherals are all idle and the power domain
> is gated. :)
>

Definitely an exciting problem. :)

Although I think it's quite opposite to ours, because the kernel knows
when the CPU is online and can simply get() the CPU device from one of
the running CPUs when onlining it and put() when offlining. The same
can't be said about IOMMUs, which are essentially bus interfaces for
other IP blocks, not really standalone devices (more than being
standalone IPs).

>> Now, for PM related details, they are located in the same power
>> domain, which means that whenever the power domain is turned off, the
>> CPU can't access their registers and all the hardware state is gone.
>> To make the case more interesting, there is no point in programming
>> the IOMMU unless the device using it is powered on. Similarly, there
>> is no point in powering the domain on to just access the IOMMU. This
>> implies that the power domain should be fully controlled by the
>> stand-alone IP block, while the peripheral IOMMU shouldn't affect its
>> state and its driver only respond to operations performed by driver of
>> that stand-alone IP block.
>
> Which implies that the IOMMU driver should have it's own set of
> runtime_suspend/runtime_resume callbacks to properly save/restore state
> as well.

Yes, but someone needs to be calling them. Right now when genpd is
used, put()ting the last runtime active device in a domain will
trigger domain power off and calling .suspend() callbacks, but
.resume() callback of each device will be called only on first get()
of this device. This means that get()ting e.g. an video codec device
will not cause the IOMMU's .resume() callback to be called.

>
>> A solution like below could work for the above:
>>
>> - There is a per-device list of peripheral devices, which need to be
>> powered on for this device to work.
>> - Whenever the IOMMU subsystem/driver binds an IOMMU to a device, it
>> adds the IOMMU device to the list of peripheral devices of that device
>> (and similarly for removal).
>> - A runtime PM operation on a device will also perform the same
>> operation on all its peripheral devices.
>
> Yes, that is exactly what we need.
>
> I'd rather use the term "dependent" devices rather than peripheral
> devices, but otherwise it sounds like the right approach to me.

I will leave the terminology to you and other people. I'm not good at
inventing names. :)

Best regards,
Tomasz
