Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab3KMQTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:19:51 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:55624 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3KMQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:19:48 -0500
MIME-Version: 1.0
In-Reply-To: <87vbzwl307.fsf@linaro.org>
References: <1384297710-29694-1-git-send-email-nm@ti.com>
	<20131113125149.GB28192@saruman.home>
	<52839306.7050701@ti.com>
	<87vbzwl307.fsf@linaro.org>
Date: Wed, 13 Nov 2013 10:19:46 -0600
X-Google-Sender-Auth: VB25XxnrXSnKewFYWPdbBsajvy0
Message-ID: <CAGo_u6q69_uOaps8=+hA1xXgVz75trK6u3oXQyvWNOrO_DK8rg@mail.gmail.com>
Subject: Re: [PATCH V2] ARM: OMAP2+: omap_device: maintain sane runtime pm
 status around suspend/resume
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: balbi@ti.com, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>, Rajendra Nayak <rnayak@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 9:45 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Nishanth Menon <nm@ti.com> writes:
>
>> On 11/13/2013 06:51 AM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Tue, Nov 12, 2013 at 05:08:30PM -0600, Nishanth Menon wrote:
>>>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>>>> index b69dd9a..f97b34b 100644
>>>> --- a/arch/arm/mach-omap2/omap_device.c
>>>> +++ b/arch/arm/mach-omap2/omap_device.c
>>>> @@ -621,6 +621,7 @@ static int _od_suspend_noirq(struct device *dev)
>>>>
>>>>     if (!ret && !pm_runtime_status_suspended(dev)) {
>>>>             if (pm_generic_runtime_suspend(dev) == 0) {
>>>> +                   pm_runtime_set_suspended(dev);
>>>
>>> don't you have to disable pm_runtime around status changes ? Or is
>>> pm_runtime already disabled by the time we get here ?
>>
>> pm_runtime is already disabled by the time no_irq suspend is invoked.
>>
>>>
>>>> @@ -634,10 +635,10 @@ static int _od_resume_noirq(struct device *dev)
>>>>     struct platform_device *pdev = to_platform_device(dev);
>>>>     struct omap_device *od = to_omap_device(pdev);
>>>>
>>>> -   if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
>>>> -       !pm_runtime_status_suspended(dev)) {
>>>> +   if (od->flags & OMAP_DEVICE_SUSPENDED) {
>>>>             od->flags &= ~OMAP_DEVICE_SUSPENDED;
>>>>             omap_device_enable(pdev);
>>>> +           pm_runtime_set_active(dev);
>>>
>>> ditto, also pm_runtime_set_active() may fail.
>>>
>> again, pm_runtime is not yet active here yet - we just restore the pm
>> runtime state with which we went down with -> and that is not expected
>> to fail either - So, how about just adding a WARN if our expectation
>> of balanced operation was somehow broken in the future with changes to
>> runtime framework?
>
> And also a note in the changelog (or comment at the WARN) about the
> assumption that runtime PM is disabled at this point.

Ofcourse. will do.

--
Regards,
Nishanth Menon
