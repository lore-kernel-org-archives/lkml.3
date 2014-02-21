Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbaBUAar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:30:47 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42735 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaBUAap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:30:45 -0500
MIME-Version: 1.0
In-Reply-To: <53068F5C.9000008@zytor.com>
References: <53068F5C.9000008@zytor.com>
Date: Thu, 20 Feb 2014 16:30:44 -0800
X-Google-Sender-Auth: W85SfvWK_dUusjyHkC5mHXHl_mQ
Message-ID: <CA+55aFw211LMAk=CSgOo26a-1QqpSEjmJZNJ4TSnbPnJUjPwOQ@mail.gmail.com>
Subject: Re: "m" constraints, jumps, and alternatives
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 3:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Another option is to say "don't do that then", and weed out the current
> uses of "m" and instead force the pointer in question explicitly into a
> register.

Passing addresses in registers is usually a *horrible* thing for the
kernel, because most of the time they are actually offsets within some
structure, and the address is almost invariably of the type
"offset(%register)". Which means that if you have to pass it as a pure
register, you are now (a) wasting a register and (b) adding an extra
"lea" or similar instruction just to do so.

Sadly, there is no good constraint for something like that. There's
"o" for "offsetable", but that is actually perfectly fine with a
PC-relative thing.

My preferred solution would be to (a) just say that it cannot be done
for replacement instructions (but is ok for the original
non-replacement one) and (b) perhaps have some build-time check of
just the replacement tables.

So then we'd at least get a build-time failure, and any users could be
taught that they have to use some obfuscation macro - I know we have
them, I can't recall their name, we've used them for the percpu stuff
- to force the address to be in a register rather than to be
%rip-relative.

Does that sound doable at all?

             Linus
