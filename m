Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaLSEs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 23:48:26 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:49126 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 23:48:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141219040308.GB20022@redhat.com>
References: <CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<20141215055707.GA26225@redhat.com>
	<CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
Date: Thu, 18 Dec 2014 20:48:24 -0800
X-Google-Sender-Auth: sz6XF3CSZmVXbCshiHedG3xvN24
Message-ID: <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
>
> So the only thing that was on that could cause spinlock overhead
> was DEBUG_SPINLOCK (and LOCK_STAT, though iirc that's not huge either)

So DEBUG_SPINLOCK does have one big downside if I recall correctly -
the debugging spinlocks are very much not fair. So they don't work
like the real ticket spinlocks. That might have serious effects on the
contention case, with some thread not making any progress due to just
the implementation of the debug spinlocks.

Peter, Ingo, maybe I'm full of crap on the debug spinlock thing., but
a quick look tells me thay are all built on top of the "trylock"
primitive that does indeed not queue anything, and is thus not fair.

I'm not sure why the debug spinlocks couldn't just be ticket locks
instead. But there you are - once more, the debug infrastructure is
actually much weaker and inferior to the "real" code.

                   Linus
