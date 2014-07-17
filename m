Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaGQSRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:17:08 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:58700 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaGQSRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMf-jSnPpo39cXLbM9cefUr37J=hnEHqfJSetORxMnjsdoANdw@mail.gmail.com>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1405465241-28684-3-git-send-email-bjorn.andersson@sonymobile.com>
	<CAMf-jSnPpo39cXLbM9cefUr37J=hnEHqfJSetORxMnjsdoANdw@mail.gmail.com>
Date: Thu, 17 Jul 2014 11:17:03 -0700
Message-ID: <CAJAp7OjPPoZYk4QyT4CzB5ncpzYos_f0ZNFk4kWEKBGvzVvOmw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] soc: qcom-rpm: Driver for the Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:33 AM, pramod gurav
<pramod.gurav.etc@gmail.com> wrote:
> Hi Bjorn,
>
> On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
>> Driver for the Resource Power Manager (RPM) found in Qualcomm 8660, 8960
>> and 8064 based devices. The driver exposes resources that child drivers
>> can operate on; to implementing regulator, clock and bus frequency
>> drivers.
>>
>
> [snip]
>
>> +       }
>> +
>> +       ret = irq_set_irq_wake(irq_ack, 1);
>
> This calls fails and throws error on my ifc6410 with 3.16-rc5.
> Does this driver depend on pincntrl. Looks like the DT support for
> pincntrl driver is missing in apq8064 dts in mainline.
> Is that right?
>

This is a gic interrupt, to it's unrelated to pinctrl.

What happens is that you end up in gic_set_wake() checking for the
architecture specific implementation of irq_set_wake; on modern
Qualcomm platforms waking the system up from sleep seems to be handled
in it's entirety by the "Modem Power Manager" (or "MSM Power Manager")
- in short MPM.

So once we introduce a driver for the mpm hardware this should
register these functions with the gic and we should get those marked
as wakeup sources.

It can be argued that this should be an error instead of just a
"warning", but for systems where this fails; i.e. systems without the
mpm driver we will not be able to go to sleep anyways, so if this call
fails we shouldn't expect to ever be woken up again.


So please ignore this warning for now; we will get there at some point.

Regards,
Bjorn
