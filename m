Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3FRRPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:15:34 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54917 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab3FRRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
	<CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
	<CAPDyKFqy9EEb6o8wYABYT6zE-7Rb0xxo8Y0DuAwooeYZp5=Grw@mail.gmail.com>
	<CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
	<CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
Date: Tue, 18 Jun 2013 10:15:30 -0700
X-Google-Sender-Auth: NRDDjTbsXc4JRH94ggVLZmD2ceE
Message-ID: <CAMbhsRQwGbpa4a1RziV92qnw4VFh6+=oQiadfqa17FANEiK8_Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Colin Cross <ccross@android.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
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

On Tue, Jun 18, 2013 at 6:17 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 17 June 2013 20:33, Colin Cross <ccross@android.com> wrote:
>> This is a generic requirement for using a kernel with autosleep
>> enabled.  Autosleep will enter suspend whenever there is no wakeup
>> source/wakelock held.  Consider the following sequence:
>>
>> Kernel is suspended
>> Card is inserted, triggering a wakeup interrupt, which is an implicit
>> wakeup source until it is handled
>
> I don't think a card insert/remove irq need to be configured as a
> wakeup interrupt. As you say, it will force a resume to detect the
> card, but for what reason?
> Instead, I think it it better to leave the card detection to be
> handled at the next resume, thus not resuming the system when not
> needed.

That decision is going to be different on each device.  On Android
devices it has been configured as a wakeup interrupt.  This patch is
necessary on devices that want to handle the event as a wakeup event,
and has negligible impact on those that do not.

>> Kernel starts resuming, resumes the mmc driver
>> The mmc driver enables its interrupt, which is immediately handled and
>> queues an event to be handled by userspace
>> At this point the wakeup interrupt is handled and gone, and no wakeup
>> sources are being held, so the kernel can choose to go back to
>> suspend, so userspace can't handle the insertion event until the
>> kernel wakes up for another reason.
>
> Is this a problem? From my point of view it should be perfectly
> acceptable to let userspace handle the event at the next resume/wakeup
> instead. Don't you think so?

Depends what userspace is doing.  If userspace would like to provide
the user some feedback on the event, then it has to be a wakeup
interrupt, and it has to hold a wakelock until it has passed the event
to userspace.

>>
>> In general, an event that is triggered by a wakeup interrupt that is
>> being passed from the kernel to userspace needs to have a wakeup
>> source held while the event is queued.
>
> That's sounds reasonable. Would it then make sense to hold a generic
> wakeup source in the "suspend/resume core", once a wakeup interrupt is
> fetched?

No, the suspend/resume core can only hold a wakeup source until it has
handed the event off to the driver, at which point it is the driver's
responsibility to hold a wakeup source.  The suspend/resume core
cannot tell if the event was handled by the driver or will be passed
to userspace.
