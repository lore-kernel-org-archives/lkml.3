Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaILIpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:45:32 -0400
Received: from mx0.aculab.com ([213.249.233.131]:41335 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752263AbaILIp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:45:29 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Chuck Ebbert'" <cebbert.lkml@gmail.com>
CC: "'Aaron Tomlin'" <atomlin@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "jcastillo@redhat.com" <jcastillo@redhat.com>,
        "riel@redhat.com" <riel@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mingo@kernel.com" <mingo@kernel.com>,
        "bmr@redhat.com" <bmr@redhat.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "akpm@google.com" <akpm@google.com>, "jgh@redhat.com" <jgh@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pzijlstr@redhat.com" <pzijlstr@redhat.com>
Subject: RE: [PATCH v3 0/3] sched: Always check the integrity of the canary
Thread-Topic: [PATCH v3 0/3] sched: Always check the integrity of the canary
Thread-Index: AQHPzdccI6w9GrgG8UuGJPEpxz0/G5v8FsrAgAAHw4CAAQ+8MA==
Date: Fri, 12 Sep 2014 08:43:45 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17490889@AcuExch.aculab.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
	<1410450088-18236-1-git-send-email-atomlin@redhat.com>
	<063D6719AE5E284EB5DD2968C1650D6D17490245@AcuExch.aculab.com>
 <20140911122619.51ed1918@as>
In-Reply-To: <20140911122619.51ed1918@as>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert 
> David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > From: Aaron Tomlin
> > > Currently in the event of a stack overrun a call to schedule()
> > > does not check for this type of corruption. This corruption is
> > > often silent and can go unnoticed. However once the corrupted
> > > region is examined at a later stage, the outcome is undefined
> > > and often results in a sporadic page fault which cannot be
> > > handled.
> > >
> > > The first patch adds a canary to init_task's end of stack.
> > > While the second patch provides a helper to determine the
> > > integrity of the canary. The third checks for a stack
> > > overrun and takes appropriate action since the damage
> > > is already done, there is no point in continuing.
> >
> > Clearly you've just been 'bitten' by a kernel stack overflow.
> > But a simple 'canary' isn't going to find most of the overflows
> > and will give an incorrect 'sense of security'.
> >
> > The canary will only work if the stack is densely written.
> > In practise the stack alignment rules create gaps, and the
> > most likely reason for overflow is a large on-stack buffer
> > that isn't actually written to.
> >
> > The only real way to detect kernel stack overflow is to arrange
> > for an unmapped page beyond the stack.
> > That costs KVA, but not much else.
> >
> 
> That doesn't work either, because the threadinfo sits between the end of the
> stack and the beginning of the next page, making it possible to corrupt critical
> data without running off the page.

Then flip the order of the allocations so that the threadinfo is at the other end.
I'm not sure how many per-lwp structures the linux kernel has, but
I know that on netbsd the main thing the kernel stack hits is the fpu
save area - the end of that is the avx area which won't be needed when
the stack usage is large.
Everything else could be moved from the stack pages to the lwp struct itself.

	David



