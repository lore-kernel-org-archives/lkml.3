Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3COQxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab3COQxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:53:31 -0400
Date: Fri, 15 Mar 2013 17:51:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130315165131.GA32065@redhat.com>
References: <20130314162413.GA21344@redhat.com> <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com> <20130315134632.GA18335@redhat.com> <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, Ming Lei wrote:
>
> On Fri, Mar 15, 2013 at 9:46 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 03/15, Ming Lei wrote:
> >>
> >> On Fri, Mar 15, 2013 at 12:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >  static inline int atomic_inc_unless_negative(atomic_t *p)
> >> >  {
> >> >         int v, v1;
> >> > -       for (v = 0; v >= 0; v = v1) {
> >> > +       for (v = atomic_read(p); v >= 0; v = v1) {
> >> >                 v1 = atomic_cmpxchg(p, v, v + 1);
> >>
> >> Unfortunately, the above will exchange the current value even though
> >> it is negative, so it isn't correct.
> >
> > Hmm, why? We always check "v >= 0" before we try to do
> > atomic_cmpxchg(old => v) ?
>
> Sorry, yes, you are right. But then your patch is basically same with the
> previous one, isn't it?

Sure, the logic is the same, just the patch (and the code) looks simpler
and more understandable.

> And has same problem, see below discussion:
>
> http://marc.info/?t=136284366900001&r=1&w=2

The lack of the barrier?

I thought about this, this should be fine? atomic_add_unless() has the same
"problem", but this is documented in atomic_ops.txt:

	atomic_add_unless requires explicit memory barriers around the operation
	unless it fails (returns 0).

I thought that atomic_add_unless_negative() should have the same
guarantees?

Paul? Frederic?

Oleg.

