Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177AbaDXEWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:22:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34961 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaDXEWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:22:49 -0400
Message-ID: <53589195.3060605@linaro.org>
Date: Wed, 23 Apr 2014 21:22:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org> <20140212154221.GG666@localhost>
In-Reply-To: <20140212154221.GG666@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Miroslav!

  Once again, a few months pass and I finally get some more time to look
at this. :( Sorry for how slow this has been going.


On 02/12/2014 07:42 AM, Miroslav Lichvar wrote:
> On Mon, Jan 06, 2014 at 07:57:03PM -0800, John Stultz wrote:
>> Got a few cycles to take another look at this, and tried to address
>> Miroslav's latest comments. Please let me know if you have further
>> thoughts!
> In the simulations this version of the patch does indeed work better
> than the previous one. I tested it with the ntp_error correction added
> back as per your previous mail. It converges, the measured frequency
> matches the value set by adjtimex and the ntp error stays close to
> zero. I'm concerned about two things now and I'm not sure if they can
> be fixed easily.
>
> One is that the convergence still seems too slow to me.
>
> ./tk_test -t 500 -n 4000
> samples: 1-500 reg: 1-500 slope: 1.00 dev: 1947.5 max: 36940.9 freq: -100.08081
> samples: 501-1000 reg: 501-1000 slope: 1.00 dev: 430.7 max: 1669.6 freq: -100.07168
> samples: 1001-1500 reg: 1001-1500 slope: 1.00 dev: 675.3 max: 3172.9 freq: -100.07393
> samples: 1501-2000 reg: 1501-2000 slope: 1.00 dev: 453.9 max: 2223.4 freq: -100.07177
> samples: 2001-2500 reg: 2001-2500 slope: 1.00 dev: 2601.2 max: 10875.4 freq: -100.03978
> samples: 2501-3000 reg: 2501-3000 slope: 1.00 dev: 185.6 max: 1251.6 freq: -99.99987
> samples: 3001-3500 reg: 3001-3500 slope: 1.00 dev: 160.1 max: 1181.7 freq: -99.99996
> samples: 3501-4000 reg: 3501-4000 slope: 1.00 dev: 150.7 max: 1103.2 freq: -99.99990
>
> You can see in this test it takes about 2500 updates to correct the
> initial ntp error and settle down. That's with 1GHz clocksource. In
> some tests I did with smaller clock frequencies or different frequency
> offsets it took much longer than that.

So I started to look into this slow update issue. I was a little
confused, as the logarithmic approximation done in the frequency
correction shouldn't let *that* much initial error accumulate before get
to the +1/0 adjustments.

It ends up this is more a reflection of a different part of your patch.
Particularly the tk->ntp_tick storage. Bascially the ntp_tick variable
is a cache of the ntp_tick_length() value, however it doesn't get set to
ntp_tick_length() until *after* you do the first frequency correction.
Basically this avoids accumulating any error until after the first
correction is made.

My main concern is that this seems like an accounting error. By
basically avoiding accumulating the initial error it seems it would
never be corrected, no?

If I add a similar ntp_tick caching to my current implementation, it
converges practically as fast (with the only initial error coming from
the logarithmic approximation of the divide being quite small). 
Similarly, if you remove the usage of tk->ntp_tick in the error
accumulation loop, using ntp_tick_length() your patch behaves quite
similarly to mine.

Does this align with your view of the code? Or am I misunderstanding
something?

> $ ./tk_test -s 2500 -n 5000
> samples: 1-5000 reg: 2501-5000 slope: 1.00 dev: 135942.4 max: 390761.8 freq: -100.00000
>
> Here the regression line is calculated only through the latter half of
> the samples (where it was already settled down) and we can see the
> total ntp error corrected since the first update is around 390
> microseconds.
>
> I'm not saying ntpd or linuxptp can't work with this. The PLL and PI
> controllers seem to handle this slowness in the frequency adjustment
> well. I'm more worried about designs that may change the frequency
> quickly and rely on accurate prediction of the clock in their feedback
> loop.
>
> The other thing I'm concerned about is that the multiplier doesn't
> change only between two closest values when the loop has settled down,
> but in a larger range. With the 1GHz clock I see the multiplier is
> moving in range of 8387767-8387772, which makes the ntp error several
> times larger than it would be if the multiplier switched just between
> 8387769 and 8387770.

So this point is valid. I spent some time reworking things and I'm not
totally happy with it currently (there's a little mess to it), but its
much closer to your implementation logically, but again just avoids the
divide and keeps the accounting closer to what we already have.

I'll hopefully clean up my current work and send it out tomorrow.

Also I do really appreciate your submissions here and apologize I've not
been able to put more time towards it recently. I also know having me
rewrite your patch over and over with various mistakes is probably
frustrating, but I do really want to make sure I both understand all the
subtleties of your changes (which resynthesizing helps) as well as make
sure the accounting is really correct (or at least not changed subtlety
without clear reason).

Thanks so much again!
-john
