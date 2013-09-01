Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3IAUDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 16:03:34 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:42836 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab3IAUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130901141139.43645159@gandalf.local.home>
References: <CA+55aFz7k5zUvJdZxpZgCgfx_-PT+f-9J50hnC1i3x=8_dXkBw@mail.gmail.com>
	<20130901085049.21748.qmail@science.horizon.com>
	<20130901111008.GA28812@thunk.org>
	<CA+55aFx5oAdGHGXd9P95-0UrKe9Tki_8Q8NoUtCVJtM-=he-Cg@mail.gmail.com>
	<20130901141139.43645159@gandalf.local.home>
Date: Sun, 1 Sep 2013 13:03:32 -0700
X-Google-Sender-Auth: VS5S9OwKwgw_zm3pwWpySfHUTmw
Message-ID: <CA+55aFzKQ6Pj18TB8p4Yr0M4t+S+BsiHH=BJNmn=76-NcjTj-g@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <waiman.long@hp.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 1, 2013 at 11:11 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I've been told that gcc works better with 'bool' than with an int.
> Should I replace those bools with bit fields in the structure?

I think bitfields are a better idea in a struct, yes. They take less
space, and there's a possibility to generate better code with a
bitfield test than with a bool, especially if you have multiple values
and you test them together.

If it's a single bool in a structure, it really doesn't matter. It's
going to take up at least a char (and usually more due to padding of
other fields) regardless of bool-vs-bitfield issues. But I'd much
rather see bitfields in structs because they *can* work better, and
they are more flexible than "bool" anyway.

Bools generally should generate the same code as "char", and yes, that
can be better than "int". On x86, for example, the "setcc" instruction
always sets a char, so if you use an "int" for boolean values, the
compiler usually generates something like "xor %eax,%eax; test ..;
setne %al" or similar. A bool or a char will skip the "xor", because
the "setne" will set the low bits that are sufficient. That said, it's
not actually noticeable in practice, and most routines that return
true/false will just do plain "return 0" or whatever, so there's no
use for "setcc" to begin with.

         Linus
