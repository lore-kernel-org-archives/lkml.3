Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHKDce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:32:34 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:40626 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbaHKDcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:32:33 -0400
Message-ID: <53E8394F.4020600@akamai.com>
Date: Sun, 10 Aug 2014 23:32:31 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Flipped jump labels
References: <20140809105742.GA5910@pd.tnic> <20140810061103.GA13968@gmail.com> <20140810061303.GA14206@gmail.com> <20140810153539.GA9490@pd.tnic> <20140810154515.GA27199@gmail.com> <20140810160756.GB9490@pd.tnic>
In-Reply-To: <20140810160756.GB9490@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 12:07 PM, Borislav Petkov wrote:
> On Sun, Aug 10, 2014 at 05:45:15PM +0200, Ingo Molnar wrote:
>> Indeed - but could we use that interface to cleanly expose the
>> arch_static_branch_active() code you've written, or do we need new
>> variants?
> We could probably.
>
> The thing is, if we want to do the _active thing, the whole jump labels
> infrastructure would need to know about those, let's call them "new
> types" because they'd need different handling when enabling - see
> __jump_label_transform() in arch/x86/kernel/jump_label.c with all the
> NOP checks.
>
> Which begs the more important question: is adding those just to save us
> a JMP penalty justify the additional code complexity. Frankly, I'm still
> on the fence here and I'd rather do some perf measurements of a kernel
> build with and without the JMP in native_sched_clock() to see whether it
> is even noticeable or it disappears in the noise.
>
> Because if it does disappear, the whole trouble is just for nothing.
>
> Thanks.
>

That is correct. We don't currently support having the default
branch direction or the fast path be different from how the
'static_key' is initialized.

If I understand your use-case correctly,  you can't have the tsc
path be the default *before* tsc_init() is called?

If not, another thought on the implementation here might be
to re-visit the work the Steven Rostedt  proposed a while back,
to use jump instead of no-ops by default, and then convert
the jumps to no-ops in a post-processing phase in order to
reduce code size (by having 2-byte jumps for example on
x86). Potentially, we could then avoid converting some of the
jumps, if they didn't match the default branch direction.
See: http://www.serverphorums.com/read.php?12,759207

In that way there is no API change, we are just relaxing the
restriction that the default branch direction must match the
way that the keys are initialized.

Thanks,

-Jason


