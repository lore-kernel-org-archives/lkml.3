Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3CORXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:23:18 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:55683 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3CORXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:23:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130315165131.GA32065@redhat.com>
References: <20130314162413.GA21344@redhat.com>
	<CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
	<20130315134632.GA18335@redhat.com>
	<CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
	<20130315165131.GA32065@redhat.com>
Date: Fri, 15 Mar 2013 18:23:15 +0100
Message-ID: <CAFTL4hxNh5qMZyyrLc8_yG5-i7UoS_nan22pO8o1fb8yS7Vz3w@mail.gmail.com>
Subject: Re: + atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
 .patch added to -mm tree
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/15 Oleg Nesterov <oleg@redhat.com>:
> On 03/15, Ming Lei wrote:
>>
>> On Fri, Mar 15, 2013 at 9:46 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > On 03/15, Ming Lei wrote:
>> >>
>> >> On Fri, Mar 15, 2013 at 12:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> >  static inline int atomic_inc_unless_negative(atomic_t *p)
>> >> >  {
>> >> >         int v, v1;
>> >> > -       for (v = 0; v >= 0; v = v1) {
>> >> > +       for (v = atomic_read(p); v >= 0; v = v1) {
>> >> >                 v1 = atomic_cmpxchg(p, v, v + 1);
>> >>
>> >> Unfortunately, the above will exchange the current value even though
>> >> it is negative, so it isn't correct.
>> >
>> > Hmm, why? We always check "v >= 0" before we try to do
>> > atomic_cmpxchg(old => v) ?
>>
>> Sorry, yes, you are right. But then your patch is basically same with the
>> previous one, isn't it?
>
> Sure, the logic is the same, just the patch (and the code) looks simpler
> and more understandable.
>
>> And has same problem, see below discussion:
>>
>> http://marc.info/?t=136284366900001&r=1&w=2
>
> The lack of the barrier?
>
> I thought about this, this should be fine? atomic_add_unless() has the same
> "problem", but this is documented in atomic_ops.txt:
>
>         atomic_add_unless requires explicit memory barriers around the operation
>         unless it fails (returns 0).
>
> I thought that atomic_add_unless_negative() should have the same
> guarantees?

I feel very uncomfortable with that. The memory barrier is needed
anyway to make sure we don't deal with a stale value of the atomic val
(wrt. ordering against another object).
The following should really be expected to work without added barrier:

void put_object(foo *obj)
{
      if (atomic_dec_return(obj->ref) == -1)
          free_rcu(obj);
}

bool try_get_object(foo *obj)
{
      if (atomic_add_unless_negative(obj, 1))
           return true;
      return false;
}

= CPU 0 =                = CPU 1
                                rcu_read_lock()
put_object(obj0);
                                obj = rcu_derefr(obj0);
rcu_assign_ptr(obj0, NULL);
                                if (try_get_object(obj))
                                     do_something...
                                else
                                     object is dying
                                rcu_read_unlock()


But anyway I must defer on Paul, he's the specialist here.
