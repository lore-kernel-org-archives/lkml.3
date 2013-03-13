Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab3CMSic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:38:32 -0400
Received: from smtp-out-064.synserver.de ([212.40.185.64]:1074 "EHLO
	smtp-out-064.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3CMSia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:38:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9338
Message-ID: <5140C816.3090008@metafoo.de>
Date: Wed, 13 Mar 2013 19:40:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>, dan.carpenter@oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH v3] iio: adc: exynos5_adc: fix compilation warnings
References: <1362625743-10401-1-git-send-email-ch.naveen@samsung.com> <1363150138-20819-1-git-send-email-ch.naveen@samsung.com> <CAD=FV=XoE6NCruDUv2UajaP+LWDCp+pgaZJsEKpkoxy3tZNeAw@mail.gmail.com> <5140C155.2070507@metafoo.de> <CAD=FV=XZMDrhQm+tZKL1RW35ZiT-JuDpmdGUXB9A6e9fG+54Fw@mail.gmail.com> <5140C6EE.9080802@metafoo.de>
In-Reply-To: <5140C6EE.9080802@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 07:35 PM, Lars-Peter Clausen wrote:
> On 03/13/2013 07:23 PM, Doug Anderson wrote:
>> Lars,
>>
>> On Wed, Mar 13, 2013 at 11:11 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> Agreed. Adding the dependency on OF in Kconfig should be all that is needed.
>>
>> I think changing the timeout from 'unsigned long' to 'long' is also
>> legit (to match the actual type returned) and a good idea.
>>
>> -Doug
> 
> Yes, but that's a different issue and to be honest I didn't even realize
> that the patch was trying to fix this as well. In my opinion it's best to
> split this up into two patches one which fixes the OF dependency. The other
> fixing the timeout issue. Cause there is more to it than just changing the type.
> 
> wait_for_completion_interruptible_timeout() may return
> 	1) 0, if there was a timeout, waiting for the completion
> 	2) > 0, if the completion was completeted, the returned value
> 	   the  remaining time.
> 	3) < 0, If it was interrupt while waiting for the completion
> 
> The code currently only handles 1) and 2), but it also needs to handle 3).
> Since the completion has not been completed in case 3.
> 
> E.g. something like this should work:
> 
> 	if (timeout == 0)
> 		return -ETIMEDOUT;
> 	else if(timeout < 0)
> 		return timeout;
> 	return 0;
> 

I just saw, there is another issue related to this. The driver should call
INIT_COMPLETION(&info->completion) before starting the conversion. Otherwise
there may be a problem if we got interrupted while waiting for the
interrupt. E.g. imagine the following sequence.

1) Start conversion
2) Wait for completion
3) Abort waiting
4) Interrupt kicks in and marks the completion as done

Now if another conversion is started the completion will already be
completed and wait_for_completion_interruptible_timeout() will return right
away without waiting for the conversion to be finished.

- Lars
