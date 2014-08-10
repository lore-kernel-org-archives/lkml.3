Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaHJPfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:35:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34109 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaHJPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:35:49 -0400
Date: Sun, 10 Aug 2014 17:35:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Flipped jump labels
Message-ID: <20140810153539.GA9490@pd.tnic>
References: <20140809105742.GA5910@pd.tnic>
 <20140810061103.GA13968@gmail.com>
 <20140810061303.GA14206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140810061303.GA14206@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 08:13:03AM +0200, Ingo Molnar wrote:
> Wouldn't using STATIC_KEY_INIT_TRUE and static_key_true() [instead of
> !static_key_false()] result in the same good code placement effects?

Nope, not really. static_key_true() is !static_key_false() and we're not
changing anything, logically. ASM looks non-optimal here, in any case,
with the "true" version.

Also, the problem in this particular use case in native_sched_clock is
that we want to do some initialization first before we enable the RDTSC,
i.e., the likely branch.

So we want to have the following static layout after build:

JMP
likely
unlikely

and the initialization code turns the JMP into a NOP at runtime.
Basically something like alternatives. :-)

Current jump labels do not have the possibility to get generated as
jump-to-unlikely labels which get changed at init time - they issue
NOPs only.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
