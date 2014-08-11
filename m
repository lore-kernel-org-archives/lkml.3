Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaHKIs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:48:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40079 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaHKIsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:48:55 -0400
Date: Mon, 11 Aug 2014 10:42:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: Ingo Molnar <mingo@kernel.org>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Flipped jump labels
Message-ID: <20140811084258.GA4236@nazgul.tnic>
References: <20140809105742.GA5910@pd.tnic>
 <20140810061103.GA13968@gmail.com>
 <20140810061303.GA14206@gmail.com>
 <20140810153539.GA9490@pd.tnic>
 <20140810154515.GA27199@gmail.com>
 <20140810160756.GB9490@pd.tnic>
 <53E8394F.4020600@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53E8394F.4020600@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 11:32:31PM -0400, Jason Baron wrote:
> That is correct. We don't currently support having the default
> branch direction or the fast path be different from how the
> 'static_key' is initialized.
> 
> If I understand your use-case correctly,  you can't have the tsc
> path be the default *before* tsc_init() is called?

Yes. And also have it come first in the function so that after nopping
out the JMP later turns it into a 0-cost path.

> If not, another thought on the implementation here might be
> to re-visit the work the Steven Rostedt  proposed a while back,
> to use jump instead of no-ops by default, and then convert
> the jumps to no-ops in a post-processing phase in order to
> reduce code size (by having 2-byte jumps for example on
> x86). Potentially, we could then avoid converting some of the
> jumps, if they didn't match the default branch direction.
> See: http://www.serverphorums.com/read.php?12,759207

Haha, so I did a very similar thing too, independently from Steve (patch
at the end):

https://lkml.kernel.org/r/20140809105742.GA5910@pd.tnic

but mine is dumber.

I'll dig out Steve's version and play with it a bit.

> In that way there is no API change, we are just relaxing the
> restriction that the default branch direction must match the
> way that the keys are initialized.

Which would make the change even smaller and invisible to users, good!

Thanks.
