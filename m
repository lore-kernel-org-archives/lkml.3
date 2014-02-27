Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaB0TrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:47:23 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:41432 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaB0TrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:47:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140227190611.GU8264@linux.vnet.ibm.com>
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
Date: Thu, 27 Feb 2014 11:47:08 -0800
X-Google-Sender-Auth: qWeWZ-q6hLQsPhjuQQhImg6TCwU
Message-ID: <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:06 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> 3.      The comparison was against another RCU-protected pointer,
>         where that other pointer was properly fetched using one
>         of the RCU primitives.  Here it doesn't matter which pointer
>         you use.  At least as long as the rcu_assign_pointer() for
>         that other pointer happened after the last update to the
>         pointed-to structure.
>
> I am a bit nervous about #3.  Any thoughts on it?

I think that it might be worth pointing out as an example, and saying
that code like

   p = atomic_read(consume);
   X;
   q = atomic_read(consume);
   Y;
   if (p == q)
        data = p->val;

then the access of "p->val" is constrained to be data-dependent on
*either* p or q, but you can't really tell which, since the compiler
can decide that the values are interchangeable.

I cannot for the life of me come up with a situation where this would
matter, though. If "X" contains a fence, then that fence will be a
stronger ordering than anything the consume through "p" would
guarantee anyway. And if "X" does *not* contain a fence, then the
atomic reads of p and q are unordered *anyway*, so then whether the
ordering to the access through "p" is through p or q is kind of
irrelevant. No?

                     Linus
