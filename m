Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3HERMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:12:08 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50482 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3HERMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <1375721715.22073.80.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
Date: Mon, 5 Aug 2013 10:12:04 -0700
X-Google-Sender-Auth: BE7950wLo91XKS7cFPs3hayBmEM
Message-ID: <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 9:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Almost a full year ago, Mathieu suggested something like:
>
> if (unlikely(x)) __attribute__((section(".unlikely"))) {
>         ...
> } else __attribute__((section(".likely"))) {
>         ...
> }

It's almost certainly a horrible idea.

First off, we have very few things that are *so* unlikely that they
never get executed. Putting things in a separate section would
actually be really bad.

Secondly, you don't want a separate section anyway for any normal
kernel code, since you want short jumps if possible (pretty much every
single architecture out there has a concept of shorter jumps that are
noticeably cheaper than long ones). You want the unlikely code to be
out-of-line, but still *close*. Which is largely what gcc already does
(except if you use "-Os", which disables all the basic block movement
and thus makes "likely/unlikely" pointless to begin with).

There are some situations where you'd want extremely unlikely code to
really be elsewhere, but they are rare as hell, and mostly in user
code where you might try to avoid demand-loading such code entirely.

So give up on sections. They are a bad idea for anything except the
things we already use them for. Sure, you can try to fix the problems
with sections with link-time optimization work and a *lot* of small
individual sections (the way per-function sections work already), but
that's basically just undoing the stupidity of using sections to begin
with.

                    Linus
