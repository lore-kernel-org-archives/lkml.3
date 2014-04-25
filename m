Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaDYVF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:05:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52195 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaDYVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:05:52 -0400
Message-ID: <535ACE2D.9000408@linaro.org>
Date: Fri, 25 Apr 2014 14:05:49 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org> <20140425140421.GA7933@localhost>
In-Reply-To: <20140425140421.GA7933@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 07:04 AM, Miroslav Lichvar wrote:
> On Thu, Apr 24, 2014 at 04:04:34PM -0700, John Stultz wrote:
>> Continuing the sporadic work on improving the timekeeping
>> frequency steering logic when NOHZ is enabled, I've made a number
>> of changes to my re-implementation of Miroslav's patch (most
>> recently posted here: https://lkml.org/lkml/2014/2/12/401 ),
>> and I'm getting much closer results in the simulator.
> Thanks, in my initial testing it seems to be working well. The results
> from the simulator are much better than with the previous patch.
>
>> Compared with Miroslav's patch, this avoids doing any extra
>> divisions, and instead approximates the correction
>> logarithmically.
> Hm, doesn't that basically make the code a software implementation of
> division? It seems it needs about 4-8 iterations to get to the final
> result.
>
> I didn't measure it, but I think with this change it now may be close
> or possibly even slower than my patch. The extra division and
> multiplication in my patch are used only when the tick length changes
> (normally once per second), otherwise the update is very cheap.

This point is quite true, though I'm really not convinced the last patch
in the series is realistically needed. It does help the code get close
to your implementation in comparisons w/ the simulator but I haven't had
the chance to sort out what the real world impact is likely to be.

That said, you're points about just setting the freq rather then trying
to converge towards it to eliminate the second layer of correction
oscillation is starting to resonate more with me. Thus I may very well
switch to the division, but if so I also want to get the manipulations
to the supporting accounting variables similarly documented as the
scaled manipulation currently provides.


>
>> Miroslav's patch:
>> -----------------
>> $ ./test1.sh 
>> 		freq10          freq100         dev             max
>> nohz on	0.00601         0.00028         74.0            279.4
>> nohz off	0.05867         0.00204         0.2             0.6
>> This patchset:
>> --------------
>> $ ./test1.sh 
>> 		freq10          freq100         dev             max
>> nohz on	0.00748         0.00076         110.8           476.4
>> nohz off	0.07173         0.03590         0.6             2.1
> This looks pretty good to me. It's interesting that the performance
> with nohz off got worse, but when I modify the test to use more points
> I can see it does converge to the correct frequency and probably it's
> not a big problem.
>
> It seems it still doesn't always switch mult only between the two
> closest values, which explains the slightly worse dev and max values.
Huh. I don't think I saw that in my testing. I'll look into it again.

I suspect the extra error comes from the occasional underflow handling
(which you avoid w/ the second_overflow_skip stuff which would help but
feels a little clunky to me - but I'm still thinking it over).

thanks
-john
