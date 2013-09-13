Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3IMLeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:34:11 -0400
Received: from plane.gmane.org ([80.91.229.3]:41671 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab3IMLeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:34:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thorsten Glaser <tg@mirbsd.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Fri, 13 Sep 2013 11:33:38 +0000 (UTC)
Message-ID: <loom.20130913T132740-708@post.gmane.org>
References: <10005394.BRCyBMYWy3@tauon> <2947789.S63SVUbC3N@tauon> <CAMuHMdWMiD1kw34CUJ-KCbk4mKggjtMzxVPpkN=ddfaq_vs9sg@mail.gmail.com> <5896310.H6rEVunj63@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 94.198.62.204 (Mozilla/5.0 (X11; Linux 3.10-2-amd64 i686) KHTML/4.10.5 (like Gecko) Konqueror/4.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller <at> chronox.de> writes:

> A monotonic counter is fully ok. Note, for /dev/random, the occurrence 
> of events delivers entropy. Thus, we have to be able to precisely 
> measure that occurrence. The timer itself does not need to deliver any 
> entropy as long as it is fast.

Rather the other way round… the get_cycles() value is XORd with jiffies
in drivers/char/random.c in one instance, and used alongside it in the
other, so it should NOT be derived from jiffies or the clocksource.

I think the focus on it being high-frequence enough to return a different
result every call is also too strict: better have a 16-bit 700 kHz counter
than none at all (plus, chances are very good it’s increased between calls
for drivers/char/random.c at least).

Geert’s question was probably about the requirement to be monotonic…
other callers do do things like & 0xFF but the random code doesn’t,
so something like use the 16 bit of the fast counter and fill the
slower counter into the upper bits would work… but this is a trade-off
against interrupt speed. I can’t judge whether it’s better to only
use the fast 16-bit counter, considering bus speeds and interrupt counts.
We do have jiffies too and use get_cycles() only to introduce more
uncertainty, so it may very well be enough…

[OT] Oh and for all who have not yet read e.g. Fefe today:
http://people.umass.edu/gbecker/BeckerChes13.pdf
Basically, RDRAND must not be used except to mix it into the pool,
now confirmed. (Kudos to Theodore and Matt for always insisting on this.)

bye,
//mirabilos

