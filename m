Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3CMUM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:12:29 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42435 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130Ab3CMUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <5140C816.3090008@metafoo.de>
References: <1362625743-10401-1-git-send-email-ch.naveen@samsung.com>
	<1363150138-20819-1-git-send-email-ch.naveen@samsung.com>
	<CAD=FV=XoE6NCruDUv2UajaP+LWDCp+pgaZJsEKpkoxy3tZNeAw@mail.gmail.com>
	<5140C155.2070507@metafoo.de>
	<CAD=FV=XZMDrhQm+tZKL1RW35ZiT-JuDpmdGUXB9A6e9fG+54Fw@mail.gmail.com>
	<5140C6EE.9080802@metafoo.de>
	<5140C816.3090008@metafoo.de>
Date: Wed, 13 Mar 2013 13:12:25 -0700
X-Google-Sender-Auth: zWblpNtzk7EKZoRMp1HAcUX8Jt0
Message-ID: <CAD=FV=UBaVQyz-UJPVWy5fik+OfmeCZtF99qTMd0RPErugPdZw@mail.gmail.com>
Subject: Re: [PATCH v3] iio: adc: exynos5_adc: fix compilation warnings
From: Doug Anderson <dianders@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>, dan.carpenter@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars,

On Wed, Mar 13, 2013 at 11:40 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> Yes, but that's a different issue and to be honest I didn't even realize
>> that the patch was trying to fix this as well. In my opinion it's best to
>> split this up into two patches one which fixes the OF dependency. The other
>> fixing the timeout issue. Cause there is more to it than just changing the type.

Sounds fair to split into two patches.  ;)


>> wait_for_completion_interruptible_timeout() may return
>>       1) 0, if there was a timeout, waiting for the completion
>>       2) > 0, if the completion was completeted, the returned value
>>          the  remaining time.
>>       3) < 0, If it was interrupt while waiting for the completion
>>
>> The code currently only handles 1) and 2), but it also needs to handle 3).
>> Since the completion has not been completed in case 3.
>>
>> E.g. something like this should work:
>>
>>       if (timeout == 0)
>>               return -ETIMEDOUT;
>>       else if(timeout < 0)
>>               return timeout;
>>       return 0;

Good catch.  Yes, that looks right to me.


> I just saw, there is another issue related to this. The driver should call
> INIT_COMPLETION(&info->completion) before starting the conversion. Otherwise
> there may be a problem if we got interrupted while waiting for the
> interrupt. E.g. imagine the following sequence.
>
> 1) Start conversion
> 2) Wait for completion
> 3) Abort waiting
> 4) Interrupt kicks in and marks the completion as done
>
> Now if another conversion is started the completion will already be
> completed and wait_for_completion_interruptible_timeout() will return right
> away without waiting for the conversion to be finished.

Another good catch.  ...but are you sure that your solution is enough?
 It seems like we'd also want to lock a spinlock in the ISR and to
consider the completion protected by the lock.  If we don't do that it
seems like you could get an interrupt _right_ after you re-init the
completion.

Notes:
* I thought we could perhaps just disable the interrupt after
wait_for_completion_interruptible_timeout() returns, but I'm not sure
that's guaranteed to work in a multiprocessor environment.

* I don't see any other iio/adc drivers using a spin_lock so maybe
there's a better way to do it (or I'm misunderstanding).  A quick scan
shows only two other iio/adc drivers even use request_irq().
at91_adc.c appears to suffer from similar problems to what we're
discussing here (only init the completion in probe).  ad_sigma_delta
at lest calls INIT_COMPLETION before waiting but seems like it still
has a small window of race (I'd have to dig more to be sure).


Perhaps someone will tell me that I'm just confused.  ;)

-Doug
