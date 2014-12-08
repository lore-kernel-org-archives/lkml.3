Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaLHSX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:23:29 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:43545 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLHSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:23:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141208181401.GD22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
	<20141208164650.GB29028@node.dhcp.inet.fi>
	<CA+55aFz6izpVGxkziynRXg7zbHzteQyPJH1Kg91ZO3fzqn3LaQ@mail.gmail.com>
	<20141208181401.GD22149@ZenIV.linux.org.uk>
Date: Mon, 8 Dec 2014 10:23:26 -0800
X-Google-Sender-Auth: 2rwU2ZjOOK7Bc3Ruf4S6pJOeG_M
Message-ID: <CA+55aFzKGsYKh1HALoeFGYQ46uMHww0WdLf5N-9duNTgMSSFxQ@mail.gmail.com>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:14 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> iov_iter_get_pages() in ITER_KVEC case, trying to avoid get_user_pages_fast()
> and getting it wrong.  FWIW, the reproducer is finit_module(fd, ....)
> where fd has been opened with O_DIRECT.  In that case we get kernel_read()
> on O_DIRECT and the buffer has just been vmalloc'ed.

Ugh. That's horrid. Do we need to even support O_DIRECT in that case?
In general, we should *not* do IO on vmalloc'ed areas, although at
least the non-O_DIRECT case where we just memcpy() it as if it came
from user space is much better.

Did this actually use to work? Or is it an issue of "the new iov_iter
is so generic that something that used to just return an error now
'works' and triggers the problem"?

> What's the sane way to grab struct page * for a vmalloc'ed address?

So "vmalloc_to_page()" should work.

However, it's actually fundamentally racy unless you can guarantee
that the vmalloc()'ed area in question is stable (so you had better
have done that allocation yourself, and be in control of the freeing,
rather than "we look up random vmalloc'ed addresses).

In general, it's really a horrible thing to use, and tends to be a big
red sign that "somebody misdesigned this badly"

                    Linus
