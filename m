Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3LSRHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:07:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:54064 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3LSRH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:07:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131219155313.GA25771@redhat.com>
References: <20131219040738.GA10316@redhat.com>
	<CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
	<20131219155313.GA25771@redhat.com>
Date: Thu, 19 Dec 2013 09:07:27 -0800
X-Google-Sender-Auth: R_PThA20UqS1I6WHDtfVvrJCl8c
Message-ID: <CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
Subject: Re: bad page state in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 7:53 AM, Dave Jones <davej@redhat.com> wrote:
>
> Interesting that CPU2 was doing sys_io_setup again. Different trace though.

Well, it was once again in aio_free_ring() - double free or freeing
while already in use? And this time the other end of the complaint was
allocating a new page that definitely was still busily in use (it's
locked).

And there's no sign of migration, although obviously that could have
happened or be in progress on another CPU and just didn't notice the
mess. But yes, based on the two traces, fs/aio.c:io_setup() would seem
to be the main point of interest.

Have you started doing something new in trinity wrt AIO, and
io_setup() in particular? Or anything else different that might have
started triggering this?

But we do have new AIO code, and these two in particular look suspicious:

 - new page migration logic:

    71ad7490c1f3 rework aio migrate pages to use aio fs

 - trying to fix double frees and error cases:

    e34ecee2ae79 aio: Fix a trinity splat
    d558023207e0 aio: prevent double free in ioctx_alloc
    d1b9432712a2 aio: clean up aio ring in the fail path

and some kind of double free in an error path would certainly explain
this (with io_setup() . And the first oops reported obviously had that
migration thing. So maybe those "fixes" weren't fixing things at all
(or just moved the error case around).

Btw, that "rework aio migrate pages to use aio fs" looks odd. It has
Ben LaHaise marked as author, but no sign-off, instead "Tested-by" and
"Acked-by".

Al, Ben, Kent, see the beginning thread on lkml
(https://lkml.org/lkml/2013/12/18/932). Any comments?

                      Linus
