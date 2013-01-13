Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3AMRlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:41:11 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59435 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3AMRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:41:10 -0500
X-Originating-IP: 108.223.40.66
Date: Sun, 13 Jan 2013 09:41:05 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: antoine.trux@gmail.com, fa.linux.kernel@googlegroups.com,
        Johannes Weiner <hannes@saeurebad.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20130113174105.GA24081@roeck-us.net>
References: <fa.cHMztHfqJXv7vw5O0nQ8SdTrma0@ifi.uio.no>
 <fa.V9M+5l8C/um5KEiBtZOjbJDQmu4@ifi.uio.no>
 <379cc523-8f08-4c7f-ae20-20f216352a01@googlegroups.com>
 <50F26BE0.7020005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F26BE0.7020005@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 04:10:08PM +0800, Chen Gang F T wrote:
> Hello Antoine:
> 
>   after read through the whole reply of Linus Torvalds for it
>     (the time stamp is "Wed, 16 Jan 2008 10:39:00 -0800 (PST)").
> 
>   at least for me, his reply is correct in details.
> 
>   although what you said is also correct,
>   it seems you misunderstanding what he said.
> 
>   all together:
>     kfree() should use 'const void *' as parameter type
>     the free() of C Library is incorrect (it use void *).
> 
Maybe the confusion arises from the somewhat lax use of the term "const
pointer", and the csomewhat confusing way of defining variable attributes in C.
Strictly speaking,
	const char *name;
which is identical to
	char const *name;
is not a const pointer, it is a pointer to a constant (string in this case).
A "const pointer", or "constant pointer to an object", would be
	char * const name;

Guenter

> 
> 于 2013年01月13日 03:18, antoine.trux@gmail.com 写道:
> > On Wednesday, January 16, 2008 8:39:48 PM UTC+2, Linus Torvalds wrote:
> > 
> >> "const" has *never* been about the thing not being modified. Forget all 
> >> that claptrap. C does not have such a notion.
> > 
> > I beg your pardon?!
> > 
> > C has had that very notion ever since its first standard (1989). Here is an excerpt from that standard (ISO/IEC 9899:1990, section 6.5.3):
> > 
> >     "If an attempt is made to modify an object defined with a const-qualified type through use of an lvalue with non-const-qualified type, the behavior is undefined."
> > 
> > 
> >> "const" is a pointer type issue, and is meant to make certain mis-uses 
> >> more visible at compile time. It has *no* other meaning, and anybody who 
> >> thinks it has is just setting himself up for problems.
> > 
> > 'const' is also a pointer issue, but not only - see above quote from the C Standard.
> > 
> > 
> > Defining an object 'const' can have an impact on optimization (and also on whether the object is placed in read-only memory). Here are trivial examples to illustrate:
> > 
> > <Program1>
> > 
> >     <foo1.c>
> >     void foo1(const int* pi)
> >     {
> >         *(int*)pi = 1;
> >     }
> >     </foo1.c>
> > 
> >     <main1.c>
> >     #include <stdio.h>
> >     void foo1(const int* pi);
> >     int main(void)
> >     {
> >         int i = 0;
> >         foo1(&i);
> >         printf("i = %d\n", i);
> >         return 0;
> >     }
> >     </main1.c>
> > 
> > </Program1>
> > 
> > Program1 defines 'i' non-const, and modifies it through a const pointer, by casting const away in foo1(). This is allowed - although not necessarily wise.
> > 
> > Program1 has well defined behavior: it prints "i = 1". The generated code dutifully retrieves the value of 'i' before passing it to printf().
> > 
> > 
> > <Program2>
> > 
> >     <foo2.c>
> >     void foo2(const int* pi)
> >     {
> >     }
> >     </foo2.c>
> > 
> >     <main2.c>
> >     #include <stdio.h>
> >     void foo2(const int* pi);
> >     int main(void)
> >     {
> >         const int i = 0;
> >         foo2(&i);
> >         printf("i = %d\n", i);
> >         return 0;
> >     }
> >     </main2.c>
> > 
> > </Program2>
> > 
> > Program2 defines 'i' const. A pointer to 'i' is passed to foo2(), which does not modify 'i'.
> > 
> > Program2 has well defined behavior: it prints "i = 0". When it generates code for main1.c, the compiler can assume that 'i' is not modified, because 'i' is defined const.
> > 
> > When compiling main2.c with gcc 4.4.7 with optimizations turned off (-O0), the generated code retrieves the value of 'i' before passing it to printf(). With optimizations turned on (-O3), it inlines the value of 'i', 0, in the call to printf(). Both versions have the same, correct behavior.
> > 
> > 
> > <Program3>
> > 
> >     <foo3.c>
> >     void foo3(const int* pi)
> >     {
> >         *(int*)pi = 1;
> >     }
> >     </foo3.c>
> > 
> >     <main3.c>
> >     #include <stdio.h>
> >     void foo3(const int* pi);
> >     int main(void)
> >     {
> >         const int i = 0;
> >         foo3(&i);
> >         printf("i = %d\n", i);
> >         return 0;
> >     }
> >     </main3.c>
> > 
> > </Program3>
> > 
> > Program3 defines 'i' const, and attempts to modify it through a const pointer, by casting const away in foo3().
> > 
> > On my particular system, when compiling Program3 with gcc 4.4.7 with optimizations turned off (-O0), the program prints "i = 1". With optimizations turned on (-O3), it prints "i = 0".
> > 
> > The question of which of these two behaviors is "correct" would be pointless, since Program3 has undefined behavior.
> > 
> > 
> > Antoine
> > --
> 
> 
> -- 
> Chen Gang
> 
> Flying Transformer

> begin:vcard
> fn:Chen Gang
> n:;Chen Gang
> version:2.1
> end:vcard
> 

