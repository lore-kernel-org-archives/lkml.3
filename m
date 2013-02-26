Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3BZPvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 10:51:32 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:47087 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BZPva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 10:51:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130226125739.GA3924@osiris>
References: <20130226045424.GA3576@osiris>
	<CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
	<20130226125739.GA3924@osiris>
Date: Tue, 26 Feb 2013 07:51:29 -0800
X-Google-Sender-Auth: Ze3tOTumOkj-ubu-hx4hKh8RKhQ
Message-ID: <CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 4:57 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> I was wrong. -EFAULT will be returned, however the vma will grow nevertheless.
> Which in turn will cause trouble.

Ok. We should fix that too.

There whole "access just past the end of the previous vma" should
never cause the stack above to expand. The guard page at least gives
people a SIGSEGV, but one of the main reasons for the guard page was
actually to make sure that new "mmap()" calls do not create mappings
just under the stack (in addition to the obvious SIGSEGV when you then
access into that thing).

So while part of the meaning of the guard page is to get that SIGSEGV,
that part is "for safetly". And apparently it works. But at the same
time, there is absolutely no reason to ever expand the stack only to
hit the guard page _anyway_, so if the stack expansion will cause the
requested address to be in the guard page, then the stack expansion
should just have failed.

I think the problem is that we add the guard page *after* we do the
normal "let's try to expand" logic.

I'll take a look.

     Linus
