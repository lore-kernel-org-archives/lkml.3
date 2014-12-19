Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaLSUha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:37:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaLSUh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:37:29 -0500
Date: Fri, 19 Dec 2014 15:36:45 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219203645.GA17130@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com>
 <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
 <20141219145528.GC13404@redhat.com>
 <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
 <20141219203135.GA1200@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141219203135.GA1200@ret.masoncoding.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 03:31:36PM -0500, Chris Mason wrote:

 > > So it's not stuck *inside* read_hpet(), and it's almost certainly not
 > > the loop over the sequence counter in ktime_get() either (it's not
 > > increasing *that* quickly). But some basically infinite __run_hrtimer
 > > thing or something?
 > 
 > Really interesting.
 > 
 > So, we're calling __run_hrtimer in a loop:
 > 
 >                 while ((node = timerqueue_getnext(&base->active))) {
 > 				...
 > 				__run_hrtimer(timer, &basenow);
 > 				...
 > 		}
 > 
 > The easy question is how often does trinity call nanosleep?

It shouldn't call it directly. (syscalls/nanosleep.c)

/*
 * SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp, struct timespec __user *, rmtp)
 */
#include "sanitise.h"

struct syscallentry syscall_nanosleep = {
	.name = "nanosleep",
	.num_args = 2,
	.arg1name = "rqtp",
	.arg1type = ARG_ADDRESS,
	.arg2name = "rmtp",
	.arg2type = ARG_ADDRESS,
	.flags = AVOID_SYSCALL, // Boring.  Can cause long sleeps.
};


That last line being the key one.  We used to do it, but it's well.. boring.
We could do something smarter, but given it's never triggered anything
interesting in the past, focussing runtime on the more interesting
syscalls seems to have been more fruitful.

	Dave

