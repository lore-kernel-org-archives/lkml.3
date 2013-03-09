Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3CIXA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 18:00:58 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42299 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3CIXA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 18:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130309223403.GZ9138@mwanda>
References: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
	<20130308162922.88ad40997d01099949008452@linux-foundation.org>
	<20130309053859.GY9138@mwanda>
	<CANeU7QnhB566ZJqjcaLkn7o701EeVbJcB=8VHW_33nwK=FZRhg@mail.gmail.com>
	<20130309223403.GZ9138@mwanda>
Date: Sat, 9 Mar 2013 15:00:54 -0800
X-Google-Sender-Auth: MUHn9nYMbO2pgYVoDPETu9fXHYc
Message-ID: <CANeU7Qk2axG8wUFt9JgHt3UpJZTiF50Ug9Udt3BAv99cBR9HPw@mail.gmail.com>
Subject: Re: Suggestion for fixing the variable length array used in the kernel.
From: Christopher Li <sparse@chrisli.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 2:34 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The problems is if we go over the 8k stack.  So big arrays are bad.
> Also if the dynamically sized array is inside a loop then normally
> GCC frees it after each iteration, but on some arches it didn't free
> it until after the last iteration.

So it seems that you agree those variable array usage should be
better change to use kmalloc or some thing.

> Btw, I've Smatch has cross function analysis, and I'd like to use
> it here to figure out if the max size for dynamically sized arrays.
> I ran into a problem:
>
> The code looks like this:
>         char buf[a];
> The size expression should be an EXPR_SYMBOL, but smatch gets:
>         char buf[*a];

Sparse currently does not deal with the dynamic array size right now.
It only want to get constant value from the array size.

The part that evaluate the array size is actually correct. Remember
the EXPR_SYMBOL
actually contain the *address* of symbol "a". So the proper
sizeof(buf) is actually
the content of "*a". That part is fine.
The more complicated case of dynamic array size is using the dynamic array in
a struct:

struct {
    char descriptor1[length+1];
    char descriptor2[length+1];
} *d;

Then the sizeof(*d) need to be ((*length) + 1 + (*length) + 1), assume
"length" is a
symbol address. The sizeof (struct foo) can be pretty complicate expression.

Some USB code use this kind of the dynamic array. However, it does not allocate
the struct in the stack, the struct is allocated via kmalloc using pointer.
Sparse still complain the variable length array though.

Let me see if I can make the sparse handle dynamic array better.

Chris
