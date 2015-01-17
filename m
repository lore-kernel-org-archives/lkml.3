Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbbAQBMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:12:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:45389 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbbAQBL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:11:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,414,1418112000"; 
   d="scan'208";a="652415516"
User-Agent: Microsoft-MacOutlook/14.4.6.141106
Date: Fri, 16 Jan 2015 17:11:49 -0800
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Carlos O'Donell" <carlos@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Torvald Riegel <triegel@redhat.com>,
        Roland McGrath <roland@redhat.com>, Darren Hart <dvhart@infradead.org>,
        Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Message-ID: <D0DEF5CA.B7F02%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
 <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de>
 <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com>
 <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de>
 <54B7D87C.3090901@gmail.com>
 <alpine.DEB.2.11.1501152313330.5526@nanos>
 <54B92B71.2090509@gmail.com>
 <alpine.DEB.2.11.1501161618080.5526@nanos>
 <54B97A72.2050205@gmail.com>
 <1421456216.27134.2.camel@stgolabs.net>
In-Reply-To: <1421456216.27134.2.camel@stgolabs.net>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/15, 4:56 PM, "Davidlohr Bueso" <dave@stgolabs.net> wrote:


>On Fri, 2015-01-16 at 21:54 +0100, Michael Kerrisk (man-pages) wrote:
>> On 01/16/2015 04:20 PM, Thomas Gleixner wrote:
>> > On Fri, 16 Jan 2015, Michael Kerrisk (man-pages) wrote:
>> > 
>> >> Hello Thomas,
>> >>
>> >> On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
>> >>> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
>> >>>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
>> >>>>
>> >>>> ??? I added this, but does this error not occur only for PI
>>requeues?
>> >>>
>> >>> It's equally wrong for normal futexes. And its actually the same
>>code
>> >>> checking for this for all variants.
>> >>
>> >> I don't understand "equally wrong" in your reply, I'm sorry. Do you
>> >> mean:
>> >>
>> >> a) This error text should be there for both normal and PI requeues
>> > 
>> > It is there for both. The requeue code has that check independent of
>> > the requeue type (normal/pi). It never makes sense to requeue
>> > something to itself whether normal or pi futex. We added this for PI,
>> > because there it is harmful, but we did not special case it. So normal
>> > futexes get the same treatment.
>> 
>> Hello Thomas, 
>> 
>> Color me stupid, but I can't see this in futex_requeue(). Where is that
>> check that is "independent of the requeue type (normal/pi)"?
>> 
>> When I look through futex_requeue(), all the likely looking sources
>> of EINVAL are governed by a check on the 'requeue_pi' argument.
>
>Yeah, its not very straightforward, I was also scratching my head. First
>we do:
>
>	if (requeue_pi) {
>		/*
>		 * Requeue PI only works on two distinct uaddrs. This
>		 * check is only valid for private futexes. See below.
>		 */
>		if (uaddr1 == uaddr2)
>			return -EINVAL;

We check here to abort as early as possible for the usual security reasons.

>
>Then:
>
>	/*
>	 * The check above which compares uaddrs is not sufficient for
>	 * shared futexes. We need to compare the keys:
>	 */
>	if (requeue_pi && match_futex(&key1, &key2)) {
>		ret = -EINVAL;
>		goto out_put_keys;
>	}
>
>I wonder why we're checking for requeue_pi again, when, at least
>according to the comments, it should be for shared. I guess it would
>make sense depending on the mappings as the keys are the only true way
>of determining if both futexes are the same, so perhaps:
>
>	if ((requeue_pi || (flags & FLAGS_SHARED)) && match_futex())

No, the rule only applies to requeue_pi. This check is the for-sure
version of the uaddr comparison above. We could add if flags &
FLAGS_SHARED, but I'm not sure it's worth it.

--
Darren Hart
Intel Open Source Technology Center



