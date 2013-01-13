Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab3AMUyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 15:54:47 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41752 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3AMUyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 15:54:46 -0500
MIME-Version: 1.0
In-Reply-To: <50F26BE0.7020005@gmail.com>
References: <fa.cHMztHfqJXv7vw5O0nQ8SdTrma0@ifi.uio.no>
	<fa.V9M+5l8C/um5KEiBtZOjbJDQmu4@ifi.uio.no>
	<379cc523-8f08-4c7f-ae20-20f216352a01@googlegroups.com>
	<50F26BE0.7020005@gmail.com>
Date: Sun, 13 Jan 2013 21:54:45 +0100
X-Google-Sender-Auth: YUaW8QTglbVuCeMKpTK56RFw1KE
Message-ID: <CAM3j68qo2_Jd=sHBtPaweAwp00N-TYnq8Y1OJZBh3sPfxL3ajw@mail.gmail.com>
Subject: Re: Why is the kfree() argument const?
From: Cong Ding <dinggnu@gmail.com>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: antoine.trux@gmail.com, fa.linux.kernel@googlegroups.com,
        Johannes Weiner <hannes@saeurebad.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clameter@sgi.com, penberg@cs.helsinki.fi
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 9:10 AM, Chen Gang F T
<chen.gang.flying.transformer@gmail.com> wrote:
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
you are definitely wrong. both of them are correct - it's the
difference between kernel space and user space.

>
> 于 2013年01月13日 03:18, antoine.trux@gmail.com 写道:
>> On Wednesday, January 16, 2008 8:39:48 PM UTC+2, Linus Torvalds wrote:
>>
>>> "const" has *never* been about the thing not being modified. Forget all
>>> that claptrap. C does not have such a notion.
>>
>> I beg your pardon?!
>>
>> C has had that very notion ever since its first standard (1989). Here is an excerpt from that standard (ISO/IEC 9899:1990, section 6.5.3):
>>
>>     "If an attempt is made to modify an object defined with a const-qualified type through use of an lvalue with non-const-qualified type, the behavior is undefined."
>>
>>
>>> "const" is a pointer type issue, and is meant to make certain mis-uses
>>> more visible at compile time. It has *no* other meaning, and anybody who
>>> thinks it has is just setting himself up for problems.
>>
>> 'const' is also a pointer issue, but not only - see above quote from the C Standard.
>>
>>
>> Defining an object 'const' can have an impact on optimization (and also on whether the object is placed in read-only memory). Here are trivial examples to illustrate:
>>
>> <Program1>
>>
>>     <foo1.c>
>>     void foo1(const int* pi)
>>     {
>>         *(int*)pi = 1;
>>     }
>>     </foo1.c>
>>
>>     <main1.c>
>>     #include <stdio.h>
>>     void foo1(const int* pi);
>>     int main(void)
>>     {
>>         int i = 0;
>>         foo1(&i);
>>         printf("i = %d\n", i);
>>         return 0;
>>     }
>>     </main1.c>
>>
>> </Program1>
>>
>> Program1 defines 'i' non-const, and modifies it through a const pointer, by casting const away in foo1(). This is allowed - although not necessarily wise.
>>
>> Program1 has well defined behavior: it prints "i = 1". The generated code dutifully retrieves the value of 'i' before passing it to printf().
>>
>>
>> <Program2>
>>
>>     <foo2.c>
>>     void foo2(const int* pi)
>>     {
>>     }
>>     </foo2.c>
>>
>>     <main2.c>
>>     #include <stdio.h>
>>     void foo2(const int* pi);
>>     int main(void)
>>     {
>>         const int i = 0;
>>         foo2(&i);
>>         printf("i = %d\n", i);
>>         return 0;
>>     }
>>     </main2.c>
>>
>> </Program2>
>>
>> Program2 defines 'i' const. A pointer to 'i' is passed to foo2(), which does not modify 'i'.
>>
>> Program2 has well defined behavior: it prints "i = 0". When it generates code for main1.c, the compiler can assume that 'i' is not modified, because 'i' is defined const.
>>
>> When compiling main2.c with gcc 4.4.7 with optimizations turned off (-O0), the generated code retrieves the value of 'i' before passing it to printf(). With optimizations turned on (-O3), it inlines the value of 'i', 0, in the call to printf(). Both versions have the same, correct behavior.
>>
>>
>> <Program3>
>>
>>     <foo3.c>
>>     void foo3(const int* pi)
>>     {
>>         *(int*)pi = 1;
>>     }
>>     </foo3.c>
>>
>>     <main3.c>
>>     #include <stdio.h>
>>     void foo3(const int* pi);
>>     int main(void)
>>     {
>>         const int i = 0;
>>         foo3(&i);
>>         printf("i = %d\n", i);
>>         return 0;
>>     }
>>     </main3.c>
>>
>> </Program3>
>>
>> Program3 defines 'i' const, and attempts to modify it through a const pointer, by casting const away in foo3().
>>
>> On my particular system, when compiling Program3 with gcc 4.4.7 with optimizations turned off (-O0), the program prints "i = 1". With optimizations turned on (-O3), it prints "i = 0".
>>
>> The question of which of these two behaviors is "correct" would be pointless, since Program3 has undefined behavior.
>>
>>
>> Antoine
>> --
>
>
> --
> Chen Gang
>
> Flying Transformer
