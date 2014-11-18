Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaKRVj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:39:29 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63707 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbaKRVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:39:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141118212307.GU7996@ZenIV.linux.org.uk>
References: <20141118084745.GT7996@ZenIV.linux.org.uk>
	<CA+55aFxK0wj2LLp0WmhRsBZch8XfoYbzmbEeJaMpt=SDh5GBvw@mail.gmail.com>
	<20141118212307.GU7996@ZenIV.linux.org.uk>
Date: Tue, 18 Nov 2014 13:39:26 -0800
X-Google-Sender-Auth: Ze6xNhk_hMNnNSUPEfYuhE_8rsU
Message-ID: <CA+55aFzFPrJLE8qWpefBqWJJWqqv1Sn+p1oFde3gVYAd1YqJAA@mail.gmail.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 1:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> OK...  If netdev folks can live with that for now, I've no problem with
> dropping 3/5.  However, I really think we need a variant of csum-and-copy
> that would _not_ bother with access_ok() longer term.  That can wait, though...

iirc,access_ok() ends up being something like three or four
instructions. It's generally not very painful.

The main reason to ever use the "__" functions is for __get_user() or
__put_user() in a loop (or when doing multiple ones when
loading/storing a struct or a signal stack frame or whatever), and
then the real issue ends up being that the __get_user() is really
often just a single instruction, while "get_user()" is a function call
that does that access_ok().

So then moving the access_ok() outside the loop, or to above the
structure load, can make a *big* deal.  But removing the access_ok()
entirely tends to not be a huge issue - it's just that you want to do
it *once*, instead of doing it over-and-over.

There might be some case you really want to remove it from the
function entirely so that the "access_ok()" is no longer close to the
accesses it checks, but I really think you want to have a goof
performance case for it, and a comment about it.

And no, we haven't really always followed those rules.

Btw, these days, on x86, we actually have a bigger issue with the
whole STAC/CLAC thing:  it's a good safety measure, but doing
STAC/CLAC for each access is painful. So "__get_user()" and
"__put_user()" sadly aren't the single-instruction things they used to
be any more. The code sequences that really want tight code (think the
'struct stat' copying and the like) sadly cannot get it as it is..

                   Linus
