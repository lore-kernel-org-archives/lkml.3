Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3IJQyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:54:45 -0400
Received: from mail.eperm.de ([89.247.134.16]:41191 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab3IJQyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:54:44 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many architectures
Date: Tue, 10 Sep 2013 18:54:38 +0200
Message-ID: <2722901.IcH4JOB8ab@tauon>
User-Agent: KMail/4.10.5 (Linux/3.10.10-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130910150419.GA29237@thunk.org>
References: <10005394.BRCyBMYWy3@tauon> <20130910150419.GA29237@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. September 2013, 11:04:19 schrieb Theodore Ts'o:

Hi Theodore,

>On Tue, Sep 10, 2013 at 01:31:41PM +0200, Stephan Mueller wrote:
>> Hi,
>> 
>> /dev/random uses the get_cycles() function to obtain entropy in
>> addition to jiffies and the event value of hardware events.
>> 
>> Typically the high-resolution timer of get_cycles delivers the
>> majority of entropy, because the event value is quite deterministic
>> and jiffies are very coarse.
>> 
>> However, on the following architectures, get_cycles will return 0....
>
>I am working on this issue with the MIPS maintainers, and on all of
>the platforms where we have some kind of counter which is derived from
>the CPU cycle clock, we should use it.  So for example there is a
>register on MIPS which is incremented on every single clock cycle mod
>the number of entries in the TLB.  This isn't sufficient for
>get_cycles() in general, but what I am thinking about doing is
>defining interface random_get_fast_cycles() which can be get_cycles()
>on those platforms that have such an interface, but on platforms that
>don't we can try to do something else.

So, MIPS seem to be covered, and m68k too. But what about the number of 
other platforms?
>
>> The following patch uses the clocksource clock for a time value in
>> case get_cycles returns 0. As clocksource may not be available
>> during boot time, a flag is introduced which allows random.c to
>> check the availability of clocksource.
>
>I'm a bit concerned about doing things this way because reading the
>clocksource clock might be quite heavyweight, and we need something
>which is very low overhead, since we call get_cycles() on every single
>interrupt.  If reading fom the clocksource clock is the equivalent of
>a L3 cache miss (or worse) doing this on every single interrupt could
>be highly problematic.  So I think we will need to implement a
>random_get_fast_cycles() for each platform for which get_cycles() is
>not available.  In some cases we may be able to use the local clock
>source (if that's the best we can do), but in others, that may not be
>appropriate at all.

In any case, we need to make sure that get_cycles (or its planned 
replacement random_get_fast_cycles) must deliver a high-resolution 
timer.

However, as the RNG is critical to crypto, we should make sure that we 
have a fix rather sooner than later.

Why do you say that clocksource is heavyweight? Yes, there is a bit more 
code than for get_cycles, but that is all just leading to usually an 
equally small clock read code as get_cycles.

Moreover, until having your proposed real fix, wouldn't it make sense to 
have an interim patch to ensure we have entropy on the mentioned 
platforms? I think /dev/random is critical enough to warrant some cache 
miss even per interrupt?
>
>Cheers,
>
>					- Ted


Ciao
Stephan
-- 
| Nimm das Recht weg -                                             |
|  was ist dann der Staat noch anderes als eine groﬂe R‰uberbande? |

