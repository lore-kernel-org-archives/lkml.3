Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3FNUwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:52:31 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:38347 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3FNUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:52:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
Date: Fri, 14 Jun 2013 13:52:28 -0700
X-Google-Sender-Auth: Z4pbB_moQjGQ4AbvSDwp6ahdj3M
Message-ID: <CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Colin Cross <ccross@android.com>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 11:42 AM, Zoran Markovic
<zoran.markovic@linaro.org> wrote:
>> I am not sure I understand why this patch is needed. When a new card
>> is inserted/removed and the upper levels gets notification about the
>> new card, triggering the mounting/un-mounting of the file system, why
>> should it be the lowest layer (mmc) that prevents the platform from
>> enter suspend/sleep? Why do we need to prevent it at all?
>>
>> Note that notifier handling in mmc_pm_notify, was if I remember
>> correctly, not completely developed when the original version of this
>> patch was being discussed. mmc_pm_notify prevents cards from being
>> inserted/removed in the middle of suspend->resume sequence, is that
>> not enough?
>
> I will try to speak on behalf of the original implementers in a hope
> they would provide the original motivation for the patch.
>
> My understanding is that any preemption in the procedure could be an
> opportunity to suspend, as there may be a suspend request racing with
> this code. This is why the calls to __pm_stay_awake() and
> queue_delayed_work() are so tightly coupled. It would be up to the
> delayed work procedure (mmc_rescan()) to decide whether or not it is
> safe to suspend. If there are no changes in the MMC state or all
> changes can be handled by mmc_rescan(), it is safe to call
> __pm_relax(). Otherwise, userland may take over processing of this
> event, and this is why the awake state needs to be extended by 1/2
> second.

The __pm_stay_awake() is required to prevent autosleep during the time
between the card detect interrupt and when the userspace process that
gets the notification runs.  The 1/2 second delay is used because it
is easier than trying to detect when the userspace process has
received the notification, at which time it should hold its own
wakelock and the mmc subsystem can call __pm_relax().
