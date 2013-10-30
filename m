Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3J3TaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:30:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45111 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259Ab3J3TaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:30:03 -0400
Date: Wed, 30 Oct 2013 19:29:27 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030192927.GB27625@mudshark.cambridge.arm.com>
References: <20131030143750.GT19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030143750.GT19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:37:50PM +0000, Peter Zijlstra wrote:
> Hi Frederic,

Hi Peter,

> I just spotted:
> 
> #ifndef arch_perf_out_copy_user
> #define arch_perf_out_copy_user __copy_from_user_inatomic
> #endif
> 
> vs:
> 
> arch/x86/include/asm/perf_event.h:#define arch_perf_out_copy_user copy_from_user_nmi
> 
> 
> Now the problem is that copy_from_user_nmi() and
> __copy_from_user_inatomic() have different return semantics.
> 
> Furthermore, the macro you use them in DEFINE_OUTPUT_COPY() assumes the
> return value is the amount of memory copied; as also illustrated by
> memcpy_common().
> 
> Trouble is, __copy_from_user_inatomic() returns the number of bytes
> _NOT_ copied.
> 
> With this, my question to Will is, how did your ARM unwind support
> patches ever work? AFAICT they end up using the
> __copy_from_user_inatomic() thing.

Yeah, that's weird, because they *do* appear to work! In fact, looking at
the code in kernel/events/core.c, it looks like __output_copy_user is
expected to return the number of bytes not copied, so providing the
__copy_from_user_inatomic succeeds first time around, the DEFINE_OUTPUT_COPY
macro will return len (dump_size) and the perf_output_skip will deal with
the buffer pointers for us. The issue then is that dynamic size will be 0,
and the unwind code in perf will never be called (except I know that it *is*
being called).

I'll go dig further...

Will
