Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3FMA7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:59:54 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:58483 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3FMA7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130613004941.GJ4165@ZenIV.linux.org.uk>
References: <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	<1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFwDYvCR9SavTQt62kibvmv37M4+GxzjxU1ZqZVVB9Ce9w@mail.gmail.com>
	<20130612233224.GH4165@ZenIV.linux.org.uk>
	<CA+55aFw2=3ua32vkpWc_9ckCNweFmmH3c0d-VqoaUD86rkR-=w@mail.gmail.com>
	<20130613002058.GI4165@ZenIV.linux.org.uk>
	<CA+55aFxEnNvj1SoOL+ChVQqK+ouSNgsM+6cQt+=PpmTGdcFggg@mail.gmail.com>
	<20130613004941.GJ4165@ZenIV.linux.org.uk>
Date: Wed, 12 Jun 2013 17:59:52 -0700
X-Google-Sender-Auth: O4y90Z51uwtE9HjuIZdyn16eaXs
Message-ID: <CA+55aFz-=xewm_6MuxK9JK_GoqyFSo6L-beXyEv83awe+B_rVw@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "?????????" <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 5:49 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jun 12, 2013 at 05:38:13PM -0700, Linus Torvalds wrote:
>>
>> For the particular case of dget_parent() maybe dget_parent() should
>> just double-check the original dentry->d_parent pointer after getting
>> the refcount on it (and if the parent has changed, drop the refcount
>> again and go to the locked version). That might be a good idea anyway,
>> and should fix the possible race (which would be with another cpu
>> having to first rename the child to some other parent, and the
>> d_invalidate() the original parent)
>
> Yes, but...  Then we'd need to dput() that sucker if we decide we shouldn't
> have grabbed that reference, after all, which would make dget_parent()
> potentially blocking.

Ho humm.. interesting. I was talking about wanting to mix atomics and
spinlocks earlier in this thread due to space constraints, and it
strikes me that that would actually help this case a lot. Having the
dentry count mix d_lock and the count in one word would allow for
atomic ops like "increment if not locked", and we'd avoid this whole
race entirely..

Something like "low bit of count is the lock bit" would end up being
lovely for this case. Of course, that's not how our spinlocks work ..

              Linus
