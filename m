Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaBXSOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:14:05 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44417 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaBXSOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:14:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140224172110.GO8264@linux.vnet.ibm.com>
References: <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	<20140224172110.GO8264@linux.vnet.ibm.com>
Date: Mon, 24 Feb 2014 10:14:01 -0800
X-Google-Sender-Auth: mfeWOHpqZX4vwgO83MtBh-gf5k0
Message-ID: <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
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

On Mon, Feb 24, 2014 at 9:21 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
>         applied to a chained pointer and an integer results in another
>         chained pointer in that same pointer chain.

No. You cannot define it this way. Taking the value of a pointer and
doing a bitwise operation that throws away all the bits (or even
*most* of the bits) results in the compiler easily being able to turn
the "chain" into a non-chain.

The obvious example being "val & 0", but things like "val & 1" are in
practice also something that compilers easily turn into control
dependencies instead of data dependencies.

So you can talk about things like "aligning the pointer value to
object boundaries" etc, but it really cannot and *must* not be about
the syntactic operations.

The same goes for "adding and subtracting an integer". The *syntax*
doesn't matter. It's about remaining information. Doing "p-(int)p" or
"p+(-(int)p)" doesn't leave any information despite being "subtracting
and adding an integer" at a syntactic level.

Syntax is meaningless. Really.

> 8.      Applying any of the following operators to a chained pointer
>         results in something that is not a chained pointer:
>         "()", sizeof, "!", "*", "/", "%", ">>", "<<", "<", ">", "<=",
>         ">=", "==", "!=", "&&", and "||".

Parenthesis? I'm assuming that you mean calling through the chained pointer.

Also, I think all of /, * and % are perfectly fine, and might be used
for that "aligning the pointer" operation that is fine.

             Linus
