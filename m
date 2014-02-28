Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaB1RSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:18:17 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:33414 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaB1RSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:18:16 -0500
Message-ID: <5310C4CB.2060201@mev.co.uk>
Date: Fri, 28 Feb 2014 17:18:03 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-28 07:35, Chase Southwood wrote:
> Smatch located a handful of while loops testing readl calls in s626.c.
> Since these while loops depend on readl succeeding, it's safer to make
> sure they time out eventually.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> Ian and/or Hartley, I'd love your comments on this.  It seems to me that
> we want these kinds of while loops properly timed out, but I want to make
> sure I'm doing everything properly.  First off, s626_debi_transfer() says
> directly that it is called from within critical sections, so I assume
> that means that the new comedi_timeout() function is no good here, and
> s626_send_dac() looked equally suspicious, so I opted for iterative
> timeouts.  Is this correct?  Also, for these timeouts, I used a very
> conservative 10000 iterations, would it be better to decrease that?

Well 10000 iterations is an improvement on infinity!  If the hardware is 
working, you'd expect it to go round a lot fewer iterations than that, 
but if the hardware is broken all bets are off, especially if it is 
generating interrupts.

> Also, do my error strings appear acceptable?

Mostly.  There's a type in one of the strings that says "TLS" instead of 
"TSL".

> And finally, are timeouts here even necessary or helpful, or are there
> any better ways to do it?

In the case of s626_send_dac(), it doesn't seem to be used in any 
critical sections, so it could make use of Hartley's comedi_timeout().

Some of the timeout errors could be propagated, especially for 
s626_send_dac() which is only reachable from very few paths.

There are other infinite loops involving calls to the s626_mc_test() 
function, but those could be dealt with by other patches.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
