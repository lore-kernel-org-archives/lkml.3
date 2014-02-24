Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBXQhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:37:46 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:46854 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaBXQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:37:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com>
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
	<CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com>
Date: Mon, 24 Feb 2014 08:37:43 -0800
X-Google-Sender-Auth: dwVSVWkoz_XaU5Lmlj606Gnwapw
Message-ID: <CA+55aFyYtMm1_UsPVw8mi7o2iH_--1wLvxPUt5Z9mAEOGMgXdQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Biener <richard.guenther@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 8:27 AM, Richard Biener
<richard.guenther@gmail.com> wrote:
>
> To me that reads like
>
>   int i;
>   int *q = &i;
>   int **p = &q;
>
>   atomic_XXX (p, CONSUME);
>
> orders against accesses '*p', '**p', '*q' and 'i'.  Thus it seems they
> want to say that it orders against aliased storage - but then go further
> and include "indirectly through a chain of pointers"?!  Thus an
> atomic read of a int * orders against any 'int' memory operation but
> not against 'float' memory operations?

No, it's not about type at all, and the "chain of pointers" can be
much more complex than that, since the "int *" can point to within an
object that contains other things than just that "int" (the "int" can
be part of a structure that then has pointers to other structures
etc).

So in your example,

    ptr = atomic_read(p, CONSUME);

would indeed order against the subsequent access of the chain through
*that* pointer (the whole "restrict" thing that I left out as a
separate thing, which was probably a mistake), but certainly not
against any integer pointer, and certainly not against any aliasing
pointer chains.

So yes, the atomic_read() would be ordered wrt '*ptr' (getting 'q')
_and_ '**ptr' (getting 'i'), but nothing else - including just the
aliasing access of dereferencing 'i' directly.

            Linus
