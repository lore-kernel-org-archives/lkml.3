Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaGUVfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:35:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46595 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbaGUVfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:35:39 -0400
Date: Mon, 21 Jul 2014 23:35:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140721213534.GB11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53CD6B50.5010404@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 12:34:40PM -0700, Andy Lutomirski wrote:
> I'm sure I'm missing something, but where is tsc_offset used outside
> the tsc startup code? Is it somehow getting programmed into the TSC
> config registers?

Nah, we're programming the CPU number into the TSC_AUX MSR. However,
that approach might become obsolete for a simpler, preempt-disable
version which Peter suggested today. It should be comparatively cheap
and work on all CPUs, not only RDTSCP-supporting ones:

get_cycles() {
	preempt_disable();
	rdtscll() + this_cpu_read(tsc_offset);
	preempt_disable()
}

So, to answer your question, the TSC offset will be used in get_cycles(). So
even on machines with a skewed TSC, we will have a stable TSC counter by
adding the per-cpu offset each time we read the TSC.

We'll see how it plays out in testing. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
