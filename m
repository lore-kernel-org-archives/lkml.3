Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBXFZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:25:58 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61935 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaBXFZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140224045951.GH8264@linux.vnet.ibm.com>
References: <1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<20140224011651.GC8264@linux.vnet.ibm.com>
	<CA+55aFx06UTTeypXOGUiwwbzJyqpVNR90zBDLPmxFzBkz=VwgQ@mail.gmail.com>
	<20140224045951.GH8264@linux.vnet.ibm.com>
Date: Sun, 23 Feb 2014 21:25:55 -0800
X-Google-Sender-Auth: YGLb4PwIxe_PmgUTy1m9fw2d5kU
Message-ID: <CA+55aFz1sPZ9f0uGpd7pqe162pGdU_i2aXjYOV1y6SNKmYUDGQ@mail.gmail.com>
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

On Sun, Feb 23, 2014 at 8:59 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Feb 23, 2014 at 05:35:28PM -0800, Linus Torvalds wrote:
>>
>> But "q = p->next" is ordered by how something can alias "p->next", not by 'q'!
>>
>> There is no need to restrict anything but 'p' for all of this to work.
>
> I cannot say I understand this last sentence right new from the viewpoint
> of the standard, but suspending disbelief for the moment...

So 'p' is what comes from that consuming load that returns a
'restrict' pointer. That doesn't affect 'q' in any way.

But the act of initializing 'q' by dereferencing p (in "p->next") is -
by virtue of the restrict - something that the compiler can see cannot
alias with anything else, so the compiler could re-order other memory
accesses freely around it, if you see what I mean.

Modulo all the *other* ordering guarantees, of course. So other
atomics and volatiles etc may have their own rules, quite apart from
any aliasing issues.

> Understood -- in this variant, you are taking the marking from the
> fact that there was an assignment from a memory_order_consume load
> rather than from a keyword on the assigned-to variable's declaration.

Yes, and to me, it's really just a legalistic trick to make it clear
that any *other* pointer that  happens to point to the same object
cannot be dereferenced within scope of the result of the
atomic_read(mo_consume), at least not if you expect to get the memory
ordering semantics. You can do it, but then you violate the guarantee
of the restrict, and you get what you get - a potential non-ordering.

So if somebody just immediately assigns the value to a normal
(non-restrict) pointer nothing *really* changes. It's just there to
describe the guarantees.

              Linus
