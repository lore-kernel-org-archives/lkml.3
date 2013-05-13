Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3EML1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:27:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:35666 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3EML1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:27:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="336730675"
Message-ID: <1368444448.16445.62.camel@intelbox>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
 minimum duration
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Date: Mon, 13 May 2013 14:27:28 +0300
In-Reply-To: <20130513092904.3ba12f9d@endymion.delvare>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	 <20130513092904.3ba12f9d@endymion.delvare>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-13 at 09:29 +0200, Jean Delvare wrote:
> Hi Imre,
> 
> On Fri, 10 May 2013 15:13:19 +0300, Imre Deak wrote:
> > The *_to_jiffies(x) macros return a jiffy value, which if used as a
> > delta to wait for a specific amount of time, may result in a wait-time
> > that is less than x.
> 
> Are you sure? I have always considered that *_to_jiffies(x) macros
> rounded up, and reading the code seems to confirm that:
> 
> 	/*
> 	 * Generic case - multiply, round and divide. (...)
> 	 */
> 	(...)
> 	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> 		>> MSEC_TO_HZ_SHR32;
> 
> What makes you think the resulting wait time can be less that requested?

Yes the above does a round-up, but for another reason. It makes only
sure you won't wait less than the requested time because you have a too
coarse HZ value. So for example with HZ=1000 it won't do any adjustment,
but with HZ=100 it'll round up durations not dividable by 10 msec.

What the proposed change wants to solve is how - or rather what point in
time - the returned value is used. For example in the following loop to
wait for some condition to become true:

timeout = msecs_to_jiffies(1);
while (!condition && timeout) {
	prepare_to_wait(wq, ...);
	timeout = schedule_timeout(timeout);
}

it would seem we'll wait at least 1 msec for the condition to become
true. In fact with HZ=1000 and an initial timeout value of 1 we may wait
less, since schedule_timeout() will return with 0 already at the next
scheduling clock tick which is most probably less than 1 msec ahead in
time.

> If this really is the case then the proper way to address the issue is
> to fix the original macros, not introducing new ones.

I'm not sure if we need the adjustment in all cases. For example in the
following polling loop we'd like to wake up every msec (to check for
something not signaled through the wq) and time out after 50 iterations:

for (i = 0; i < 50; i++) {
	prepare_to_wait(wq, ...);
	if (condition)
		break;
	schedule_timeout(msecs_to_jiffies(1));
}

Having the +1 adjustment in msecs_to_jiffies() would result in waking up
close to every 2 msec.

> > Many callers already compensate for this by adding
> > one to the returned value.
> 
> This is an assumption from you, and I am afraid it is wrong in many
> cases. I see that Michal Kubecek already pointed out one case where it
> was indeed wrong, and I am about to make a similar reply to another
> post of yours.

Agreed, I was wrong in those cases and we shouldn't change them. There
are places on the other hand where the adjustment is made to guarantee a
minimum waiting time and thus better expressed with a properly named
helper.

> > To document why we need to add one and to get
> > rid of some code duplication add a helper that does the same.
> 
> I'm sorry but you can't call "+ 1" code duplication.

You're right, the change doesn't reduce code duplication.. It only
documents why the +1 is needed, which is very much called for imo.

> > Later patches will convert the currently open-coded call sites to use
> > the new helpers.
> > 
> > Also this can serve as a basis for auditing those users of *_to_jiffies
> > that most likely do the wrong thing - for example set a timeout value of
> > msecs_to_jiffies(1) - and converting them to use the new helpers.
> 
> You should be very, very careful before claiming that the code is wrong
> and you're fixing it. It might as well be that the code is right but
> you did not understand it, and you're actually breaking it. Or the code
> was already wrong and you're making it worse ;)

Agreed and I should've been more careful with the converting patches.
But the fact is that there is currently code out there that uses
msecs_to_jiffies() incorrectly. Fixing these and making it less likely
for similar problems to appear in the future is worth the trouble
though.

--Imre

> As a summary, I don't like the idea, sorry.

