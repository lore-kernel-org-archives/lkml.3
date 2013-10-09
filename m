Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3JIWZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:25:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:47915 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab3JIWZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:25:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1067,1371106800"; 
   d="scan'208";a="416886926"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen\, Andi" <andi.kleen@intel.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
References: <20131009144150.108f7041@gandalf.local.home>
	<5255C07E.70805@linux.intel.com>
Date: Wed, 09 Oct 2013 15:25:23 -0700
In-Reply-To: <5255C07E.70805@linux.intel.com> (H. Peter Anvin's message of
	"Wed, 09 Oct 2013 13:45:50 -0700")
Message-ID: <878uy2ytd8.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@linux.intel.com> writes:

>> Summary
>> -------
>> 
>> Although the extreme case shows a nice improvement, I'm skeptical if it
>> is worth doing for real world applications.
>
> You did the experiment, and credit to you for not going "I did the work,
> now include it" but rather for publishing the results so we can learn
> from them.
>
> It *does* make me wonder if we can leverage RTM for a significant subset
> of these (as an interrupt will abort a transaction); that should be
> substantially cheaper and less complex.

I miss the original context and can't find the original patchkit, but:

- If the goal is to lower interrupt latency then RTM would still
need to use a fallback, so the worst case would be the fallback, thus
not be better.

- If the goal is to make CLI/STI faster:
I'm not sure RTM is any faster than a PUSHF/CLI/POPF pair. It may
well be slightly slower in fact (guessing here, haven't benchmarked)

- Also when you abort you would need to reexecute of course.

- My TSX patchkit actually elides CLI/STI inside transactions
(no need to do them, as any interrupt would abort anyways)
but the main motivation was to avoid extra aborts.

- That said, I think a software CLI/STI is somewhat useful for profiling,
as it can allow to measure how long interrupts are delayed
by CLI/STI.  I heard use cases of this, but I'm not 
sure how common it really is

[I presume a slightly modified RT kernel could also give the same
profiling results]

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
