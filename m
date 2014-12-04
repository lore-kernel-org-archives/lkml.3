Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaLDNqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:46:03 -0500
Received: from h1.radempa.de ([176.9.142.194]:49809 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaLDNqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:46:01 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
In-reply-to: <547F8925.3050308@nod.at>
References: <1417563176-31972-1-git-send-email-richard@nod.at> <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at> <547F0CFE.4010107@nod.at> <E1XwAbX-0001Ht-Jg@stardust.g4.wien.funkfeuer.at> <547F8925.3050308@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Wed, 03 Dec 2014 23:05:25 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4038.1417700732.1@stardust.g4.wien.funkfeuer.at>
Date: Thu, 04 Dec 2014 14:45:32 +0100
Message-Id: <E1XwWiq-00013A-NC@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
> Am 03.12.2014 um 15:08 schrieb Harald Geyer:
> >> I was asking because I see the "dht11: WARNING: decoding ambiguous"
> >> very often. (with and without my patches)
> > 
> > Yes, your patches shouldn't have any effect on this.
> > "very often" in the sense of "not always"? This would be very surprising,
> > because this would involve variable length clock ticks, i think.
> > 
> > I guess we should include timeres into the warning message.
> > 
> > Also I guess now is the time to think about a smarter decoder.

I was wrong.
 
> Another question. Your driver defines:
> #define DHT11_DATA_BIT_LOW      27000
> #define DHT11_DATA_BIT_HIGH     70000
> 
> If I read the manual [0] correctly these constants are T_h0/1.
> Why did you use 27000 for T_h0?
>
> [0] http://meteobox.tk/files/AM2302.pdf

It's a compromise between data sheets for various slightly different
sensors. In particular the data sheet for AM2303 specifies
26-28us, so it's just in the middle. But note that DHT11_DATA_BIT_LOW
isn't used in the actual decoding. Just for printing the warning.

But looking at your data sheet I see the we currently use a start
command that's outside the specified range... I will have to look
up where the current 80ms value was suggested.

> Setting it to 26000 (the typical value as stated by the manual),
> I get the "decoding ambiguous" warning *always*. Setting it higher
> makes the message go away.

If you misstyped "always" and "go away" then this is to be expected.

Also I think I now understand what is going on:
Your board most probably has a clock much faster then 32kH and when
we calculate timeres, we don't actually calculate the timestamp
resolution but the length of the shortest pulse. The decoding
algorithm is robust in such cases, but it generates wrong warnings.

The proper fix is to drop messages about clock speed from the
decoding functin. If we want to keep such diagnostics, we should
have them at probe() time. - This will also resolve our disagreement
about proper formatting of log messages about clock issues. :)

Optionally we can drop the calculation of timeres and just use a
constant threshold.

Thanks,
Harald
