Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3LXAMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:12:23 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:33332 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab3LXAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <52B8CE99.2050608@zytor.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
	<52B8CE99.2050608@zytor.com>
Date: Mon, 23 Dec 2013 16:12:20 -0800
X-Google-Sender-Auth: h7N4P_bkKYRHh8MEidAdsUq2gFA
Message-ID: <CA+55aFyoUwL2Rkt1qof41HciGCNk9LHdP3ezUFeVYM=gam44rg@mail.gmail.com>
Subject: Re: [RFC] speeding up the stat() family of system calls...
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 4:00 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I guess I'm a bit puzzled... the current code should be just fine if
> everything is present, and do we really care about the performance if we
> actually have an error condition?

I think we should. You could make it to do something like eighteen
expensive page faults in a row for EFAULT, and that's just disgusting,
when there is no reason to do it.

But to be honest, the resulting assembly is also easier to read,
because it doesn't have those annoying bogus branch targets all over
in the middle of the code. That was actually my main issue - looking
at the generated fs/stat.s file and not puking ;)

(it's still hard to read with all the fixup section stuff, but it's
better. And it really does generate better code, so..)

> I'm a bit concerned about the put_user_fail: label having uniqueness
> problem, which I know some versions of gcc at least get very noisy over.

Oh, you're right, I forgot to actually declare the label so that gcc
sees that it's a local one.

So it needs a

   __label__ put_user_fail;

in the put_user_try() (and yes, maybe the label name should have
underscores prepended or something, just to make sure it's internal).

But gcc is perfectly fine with multiple labels in different scopes if
you do that. We already use that in a few places, so this isn't even a
new pattern for us.

             Linus
