Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaCCTCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbaCCTCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:02:23 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
References: <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	 <20140223063426.GT4250@linux.vnet.ibm.com>
	 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	 <20140224172110.GO8264@linux.vnet.ibm.com>
	 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	 <20140224185341.GU8264@linux.vnet.ibm.com>
	 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
	 <1393515453.28840.9961.camel@triegel.csb>
	 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
	 <20140227190611.GU8264@linux.vnet.ibm.com>
	 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Mar 2014 19:59:31 +0100
Message-ID: <1393873171.28840.11667.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 11:47 -0800, Linus Torvalds wrote:
> On Thu, Feb 27, 2014 at 11:06 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > 3.      The comparison was against another RCU-protected pointer,
> >         where that other pointer was properly fetched using one
> >         of the RCU primitives.  Here it doesn't matter which pointer
> >         you use.  At least as long as the rcu_assign_pointer() for
> >         that other pointer happened after the last update to the
> >         pointed-to structure.
> >
> > I am a bit nervous about #3.  Any thoughts on it?
> 
> I think that it might be worth pointing out as an example, and saying
> that code like
> 
>    p = atomic_read(consume);
>    X;
>    q = atomic_read(consume);
>    Y;
>    if (p == q)
>         data = p->val;
> 
> then the access of "p->val" is constrained to be data-dependent on
> *either* p or q, but you can't really tell which, since the compiler
> can decide that the values are interchangeable.

The wording I proposed would make the p dereference have a value
dependency unless X and Y would somehow restrict p and q.  The reasoning
is that if the atomic loads return potentially more than one value, then
even if we find out that two such loads did return the same value, we
still don't know what the exact value was.

