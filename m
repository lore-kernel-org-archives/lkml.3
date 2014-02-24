Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaBXQ1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:27:31 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:56771 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaBXQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
References: <20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<20140220181116.GT4250@linux.vnet.ibm.com>
	<CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
	<1392922421.28840.36.camel@triegel.csb>
	<CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	<1393095223.28840.4914.camel@triegel.csb>
	<CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	<20140223003933.GQ4250@linux.vnet.ibm.com>
	<CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	<20140223063426.GT4250@linux.vnet.ibm.com>
	<CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	<CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
Date: Mon, 24 Feb 2014 17:27:26 +0100
Message-ID: <CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Richard Biener <richard.guenther@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 4:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 23, 2014 at 11:31 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Let me think about it some more, but my gut feel is that just tweaking
>> the definition of what "ordered" means is sufficient.
>>
>> So to go back to the suggested ordering rules (ignoring the "restrict"
>> part, which is just to clarify that ordering through other means to
>> get to the object doesn't matter), I suggested:
>>
>>  "the consume ordering guarantees the ordering between that
>>   atomic read and the accesses to the object that the pointer
>>   points to"
>>
>> and I think the solution is to just say that this ordering acts as a
>> fence. It doesn't say exactly *where* the fence is, but it says that
>> there is *some* fence between the load of the pointer and any/all
>> accesses to the object through that pointer.
>
> I'm wrong. That doesn't work. At all. There is no ordering except
> through the pointer chain.
>
> So I think saying just that, and nothing else (no magic fences, no
> nothing) is the right thing:
>
>  "the consume ordering guarantees the ordering between that
>   atomic read and the accesses to the object that the pointer
>   points to directly or indirectly through a chain of pointers"

To me that reads like

  int i;
  int *q = &i;
  int **p = &q;

  atomic_XXX (p, CONSUME);

orders against accesses '*p', '**p', '*q' and 'i'.  Thus it seems they
want to say that it orders against aliased storage - but then go further
and include "indirectly through a chain of pointers"?!  Thus an
atomic read of a int * orders against any 'int' memory operation but
not against 'float' memory operations?

Eh ...

Just jumping in to throw in my weird-2-cents.

Richard.
