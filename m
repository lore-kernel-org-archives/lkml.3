Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3HETBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:01:04 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:57160 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3HETBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:01:01 -0400
MIME-Version: 1.0
In-Reply-To: <51FFF430.1060701@linux.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	<1375725328.22073.101.camel@gandalf.local.home>
	<51FFEC56.6040206@linux.intel.com>
	<1375727010.22073.110.camel@gandalf.local.home>
	<51FFEEEC.5060902@linux.intel.com>
	<1375728583.22073.118.camel@gandalf.local.home>
	<51FFF430.1060701@linux.intel.com>
Date: Mon, 5 Aug 2013 12:01:01 -0700
X-Google-Sender-Auth: qqlx7b2eEBvniYNhlVOV75_MHsE
Message-ID: <CA+55aFwz6cpsaWZ-19h91_CNGB5C3d1bNOv7woxetXOTyJ_CRw@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 11:51 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> Also, how would you pass the parameters? Every tracepoint has its own
>> parameters to pass to it. How would a trap know what where to get "prev"
>> and "next"?
>
> How do you do that now?
>
> You have to do an IP lookup to find out what you are doing.

No, he just generates the code for the call and then uses a static_key
to jump to it. So normally it's all out-of-line, and the only thing in
the hot-path is that 5-byte nop (which gets turned into a 5-byte jump
when the tracing key is enabled)

Works fine, but the normally unused stubs end up mixing in the normal
code segment. Which I actually think is fine, but right now we don't
get the short-jump advantage from it (and there is likely some I$
disadvantage from just fragmentation of the code).

With two-byte jumps, you'd still get the I$ fragmentation (the
argument generation and the call and the branch back would all be in
the same code segment as the hot code), but that would be offset by
the fact that at least the hot code itself could use a short jump when
possible (ie a 2-byte nop rather than a 5-byte one).

Don't know which way it would go performance-wise. But it shouldn't
need gcc changes, it just needs the static key branch/nop rewriting to
be able to handle both sizes. I couldn't tell why Steven's series to
do that was so complex, though - I only glanced through the patches.

            Linus
