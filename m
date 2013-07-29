Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3G2Fis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:38:48 -0400
Received: from chicago.guarana.org ([192.210.136.102]:50963 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3G2Fir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:38:47 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 01:38:47 EDT
Message-ID: <20130729153035.18805zox54aoyubf@chicago.guarana.org>
Date: Mon, 29 Jul 2013 15:30:35 +1000
From: caf@guarana.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, davem@davemloft.net,
        arnd@arndb.de, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
References: <20130727225828.GA11864@linux.vnet.ibm.com>
In-Reply-To: <20130727225828.GA11864@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>:

> According to the C standard 3.4.3p3, overflow of a signed integer results
> in undefined behavior.  This commit therefore changes the definitions
> of time_after() and time_after_eq() to avoid this undefined behavior.
> The trick is that the subtraction is done using unsigned arithmetic,
> which according to 6.2.5p9 cannot overflow because it is defined as
> modulo arithmetic.  This has the added (though admittedly quite small)
> benefit of shortening two lines of code by four characters each.
>
> Note that the C standard considers the cast from signed to
> unsigned to be implementation-defined, see 6.3.1.3p3.  However, on a
> two-complement system, an implementation that defines anything other
> than a reinterpretation of the bits is free come to me, and I will be
> happy to act as a witness for its being committed to an insane asylum.
> (Although I have nothing against saturating arithmetic or signals in
> some cases, these things really should not be the default.)

Don't worry, the case from signed to unsigned is actually well-defined -
the relevant part is 6.3.1.3p2 (in C99):

> Otherwise, if the new type is unsigned, the value is converted by
> repeatedly adding or subtracting one more than the maximum value that
> can be represented in the new type until the value is in the range of
> the new type.

...which ends up just being reinterpretation of the bits on a two's
complement system, as you'd hope (after sign-extension to the width of
the target unsigned type, that is).  This actually means if you were
mad enough to implement C on a sign-magnitude system, you'd be forced to
do a non-trivial conversion in this case.

     - Kevin

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

