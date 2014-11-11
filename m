Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaKKHmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:42:55 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:53144 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaKKHmw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 11 Nov 2014 02:42:52 -0500
Message-Id: <5461CC0702000078000464B3@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 11 Nov 2014 07:42:47 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <mingo@elte.hu>, "Ingo Molnar" <mingo@kernel.org>, <tglx@linutronix.de>,
        "Tony Jones" <tonyj@suse.de>, <linux-kernel@vger.kernel.org>,
        "Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
References: <5458A9600200007800044AE5@mail.emea.novell.com>
 <20141110100117.GA15841@gmail.com>
 <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
In-Reply-To: <CA+55aFw9MV1n8T7_k5oftfY-sOu8s1ywKYM-3k4+PF022vv9ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.11.14 at 18:56, <torvalds@linux-foundation.org> wrote:
> So no. A very strong NACK. The code was too ugly to live, there is no good
> stated reason for it, and the only reason I can even remotely imagine is
> wrong and complete crap anyway (ie making the CFI annotations a correctness
> issue by introducing other infrastructure that depends on it always being
> right).
> 
> We've been through this before. The same suspects were involved. If this is
> some crazy "debug info has to be right, because otherwise our total crap
> unwinding goes boom", then the solution is not to add more broken and ugly
> CFI annotations, the solution is to not depend on a broken and fragile
> unwinder.
> 
> Any debug infrastructure *must* be robust enough that missing or even
> actively wrong frame information must not break it. If it's too fragile to
> handle missing or bad debug information, then it is too fragile to be used
> for debugging.

And no-one said this not to be the case. The fact here is that the
unwind information can be improved, resulting in better use of
whatever consumes it. And the "whatever" that prompted this was
upstream's perf subsystem (I think I even mentioned this in the
patch description), which - through the way things get connected
together in the kernel - just _happens_ to use the unwinder when
it's present in the kernel.

Nothing crashes with the unwind information being wrong. It is
solely you who was claiming (without proof) years ago that the
unwinder repeatedly caused issues. Yes, we did find a bug or two
over the years in it, but there being bugs in software is pretty
much unavoidable. If you didn't accept that, you shouldn't be
merging any patches introducing new features.

The point of the patch, however, is to make the unwinder do a
better job. And even if you prefer to ignore this fact, people
over here actually prefer looking at stack traces they don't have
to guess or verify for each entry whether it actually belongs to
the call stack - this saves them time, and hence allows them to
be more productive.

> The fact is, debug information had better *never* be so important that it
> has to be right. Seriously. Even gcc historically gets the debug
> information wrong quite regularly, exactly because there are so few things
> that depend on it. We have to assume that frame information is incomplete,
> and that also means that we don't add insane crap to our inline asm code.
> 
> So for something like this to be workable, it has better be:

So finally you're getting to at least slightly productive criticism.

> - much cleaner and less hacky

And I asked for suggestions in the patch comment.

> - not have to depend on random gcc code generation

I don't think I can correlate this to any particular aspect of the
change.

Jan

