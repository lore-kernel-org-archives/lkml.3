Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaDPEHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:07:07 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54576 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaDPEHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1404152028560.22697@ionos.tec.linutronix.de>
References: <cover.1397537986.git.viresh.kumar@linaro.org>
	<1af3a250749c7c103ef38b52d653559ac4ec899c.1397537987.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1404152028560.22697@ionos.tec.linutronix.de>
Date: Wed, 16 Apr 2014 09:37:04 +0530
Message-ID: <CAKohponxwG4ECBz21S7F0fjWs3LM7hFLBQBhPi60b+WS_P+x4Q@mail.gmail.com>
Subject: Re: [PATCH V1 Resend 2/5] tick-common: don't check
 tick_oneshot_mode_active() from tick_check_preferred()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 00:00, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 15 Apr 2014, Viresh Kumar wrote:
>
>> If 'curdev' passed to tick_check_preferred() is the current clock_event_device
>> then these two checks look exactly same, because td->mode is set to
>> TICKDEV_MODE_ONESHOT only when the event device has ONESHOT feature.
>>
>>       if (curdev && (curdev->features & CLOCK_EVT_FEAT_ONESHOT))
>>               return false;
>>
>>       if (tick_oneshot_mode_active())
>>               return false;
>>
>> Now left the case where 'curdev' is not the current clock_event_device. This can
>> happen from the sequence started from clockevents_replace(). Here we are trying
>> to find the best possible device that we should choose. And so even in this case
>> we don't need the above check as we aren't really worried about the current
>> device.
>
> Wrong. If curdev is NULL, you might select a device w/o ONESHOT if the
> system is in oneshot mode. Go figure.

Okay, so the logs must have another case where curdev is NULL. But codewise
we are already taking care of that here:

        return !curdev ||
                newdev->rating > curdev->rating ||
               !cpumask_equal(curdev->cpumask, newdev->cpumask);

And so this patch wouldn't harm. And this is preserved in the next patch (3/5)
as well, which adds checks for other cases as well.
