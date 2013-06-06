Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3FFBie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:38:34 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:39446 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab3FFBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130606012010.GE13110@ZenIV.linux.org.uk>
References: <20130606012010.GE13110@ZenIV.linux.org.uk>
Date: Thu, 6 Jun 2013 10:38:31 +0900
X-Google-Sender-Auth: aa9LSfVrtQV_r9QDGkTl8HOqfqY
Message-ID: <CA+55aFxB9GRfxhCg+s3xMCUQ5Sjt+nViRHQA-DPJ_5DB+v57Uw@mail.gmail.com>
Subject: Re: [RFC] corner cases of open() on procfs symlinks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 10:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>         I'm not sure whether to treat that as a bug or as a weird misfeature
> enshrined in userland ABI:
>         open("/tmp", O_CREAT, 0) => -EISDIR     // LAST_NORM case
>         open("/", O_CREAT, 0) => -EISDIR        // LAST_ROOT
>         open(".", O_CREAT, 0) => -EISDIR        // LAST_DOT
>         open("..", O_CREAT, 0) => -EISDIR       // LAST_DOTDOT
>         open("/proc/self/cwd", O_CREAT, 0) => success   // LAST_BIND
>         open("/proc/self/cwd/", O_CREAT, 0) => -EISDIR  // trailing slashes

Ok, that looks buggy. O_CREAT should definitely return EISDIR for
/proc/self/cwd too, since it's a directory. I don't think the
O_RDWR/O_WRONLY thing should matter.

>        I would obviously
> like to do that - do_last() is far too convoluted as it is; the only
> question is whether we can change the first weirdness...  Comments?

Exactly which cases does that change? I have no objections if it's
only the "LAST_BIND" case that now starts returning EISDIR. Is there
anything else it affects?

That said, obviously if something breaks, we'd have to revert it, and
as a cleanup rather than some serious bug (ie this doesn't cause
crashes or security issues), I suspect this should wait until 3.11
regardless. No?

           Linus
