Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3FRNRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:17:16 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50933 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3FRNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
	<CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
	<CAPDyKFqy9EEb6o8wYABYT6zE-7Rb0xxo8Y0DuAwooeYZp5=Grw@mail.gmail.com>
	<CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
Date: Tue, 18 Jun 2013 15:17:09 +0200
Message-ID: <CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        San Mehat <san@google.com>, John Stultz <john.stultz@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2013 20:33, Colin Cross <ccross@android.com> wrote:
> On Mon, Jun 17, 2013 at 7:22 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 14 June 2013 22:52, Colin Cross <ccross@android.com> wrote:
>>> On Fri, Jun 14, 2013 at 11:42 AM, Zoran Markovic
>>> <zoran.markovic@linaro.org> wrote:
>>>>> I am not sure I understand why this patch is needed. When a new card
>>>>> is inserted/removed and the upper levels gets notification about the
>>>>> new card, triggering the mounting/un-mounting of the file system, why
>>>>> should it be the lowest layer (mmc) that prevents the platform from
>>>>> enter suspend/sleep? Why do we need to prevent it at all?
>>>>>
>>>>> Note that notifier handling in mmc_pm_notify, was if I remember
>>>>> correctly, not completely developed when the original version of this
>>>>> patch was being discussed. mmc_pm_notify prevents cards from being
>>>>> inserted/removed in the middle of suspend->resume sequence, is that
>>>>> not enough?
>>>>
>>>> I will try to speak on behalf of the original implementers in a hope
>>>> they would provide the original motivation for the patch.
>>>>
>>>> My understanding is that any preemption in the procedure could be an
>>>> opportunity to suspend, as there may be a suspend request racing with
>>>> this code. This is why the calls to __pm_stay_awake() and
>>>> queue_delayed_work() are so tightly coupled. It would be up to the
>>>> delayed work procedure (mmc_rescan()) to decide whether or not it is
>>>> safe to suspend. If there are no changes in the MMC state or all
>>>> changes can be handled by mmc_rescan(), it is safe to call
>>>> __pm_relax(). Otherwise, userland may take over processing of this
>>>> event, and this is why the awake state needs to be extended by 1/2
>>>> second.
>>>
>>> The __pm_stay_awake() is required to prevent autosleep during the time
>>> between the card detect interrupt and when the userspace process that
>>> gets the notification runs.  The 1/2 second delay is used because it
>>> is easier than trying to detect when the userspace process has
>>> received the notification, at which time it should hold its own
>>> wakelock and the mmc subsystem can call __pm_relax().
>>
>> Hi Colin,
>>
>> I don't have the in-depth knowledge about how the userspace deamons
>> handles the event notifications, so please bare with me while I am
>> trying to understand more here.
>>
>> First of all, are we trying to solve an  issue here or just improving
>> some specific situation, that is not clear to me.
>>
>> I might have misunderstood this patch, but it seems like your concern
>> is that you believe the event notification can get lost - if userspace
>> are about to trigger a suspend while a card is being inserted/removed.
>> If that is the case, could you elaborate on what level the
>> notification can get lost?
>>
>> Kind regards
>> Ulf Hansson
>
> This is a generic requirement for using a kernel with autosleep
> enabled.  Autosleep will enter suspend whenever there is no wakeup
> source/wakelock held.  Consider the following sequence:
>
> Kernel is suspended
> Card is inserted, triggering a wakeup interrupt, which is an implicit
> wakeup source until it is handled

I don't think a card insert/remove irq need to be configured as a
wakeup interrupt. As you say, it will force a resume to detect the
card, but for what reason?
Instead, I think it it better to leave the card detection to be
handled at the next resume, thus not resuming the system when not
needed.

> Kernel starts resuming, resumes the mmc driver
> The mmc driver enables its interrupt, which is immediately handled and
> queues an event to be handled by userspace
> At this point the wakeup interrupt is handled and gone, and no wakeup
> sources are being held, so the kernel can choose to go back to
> suspend, so userspace can't handle the insertion event until the
> kernel wakes up for another reason.

Is this a problem? From my point of view it should be perfectly
acceptable to let userspace handle the event at the next resume/wakeup
instead. Don't you think so?

>
> In general, an event that is triggered by a wakeup interrupt that is
> being passed from the kernel to userspace needs to have a wakeup
> source held while the event is queued.

That's sounds reasonable. Would it then make sense to hold a generic
wakeup source in the "suspend/resume core", once a wakeup interrupt is
fetched?

Kind regards
Ulf Hansson
