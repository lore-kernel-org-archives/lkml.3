Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3ISRjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:39:11 -0400
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:59559 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831Ab3ISRjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:39:10 -0400
Date: Thu, 19 Sep 2013 13:40:43 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, eranian@googlemail.com
Subject: Re: [PATCH, v4] perf: Fix capabilities bitfield compatibility in
 'struct perf_event_mmap_page'
In-Reply-To: <20130919114254.GA22807@gmail.com>
Message-ID: <alpine.DEB.2.02.1309191313440.4111@pianoman.cluster.toy>
References: <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy> <20130918154224.GK9326@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy> <20130919081642.GL9326@twins.programming.kicks-ass.net>
 <20130919091452.GB14112@gmail.com> <20130919101240.GN9326@twins.programming.kicks-ass.net> <20130919102818.GA23487@gmail.com> <20130919103550.GO9326@twins.programming.kicks-ass.net> <20130919104056.GA18991@gmail.com> <523ADD8D.1030607@intel.com>
 <20130919114254.GA22807@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.523B36BC.01F1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Ingo Molnar wrote:

> To solve all that make this change explicit, detectable and self-contained,
> by iterating the ABI the following way:
> 
>  - Always clear bit 0, and rename it to usrpage->cap_bit0, to at least not
>    confuse old user-space binaries. RDPMC will be marked as unavailable
>    to old binaries but that's within the ABI, this is a capability bit.
> 
>  - Rename bit 1 to ->cap_bit0_is_deprecated and always set it to 1, so new
>    libraries can reliably detect that bit 0 is deprecated and perma-zero
>    without having to check the kernel version.
> 
>  - Use bits 2, 3, 4 for the newly defined, correct functionality:
> 
> 	cap_user_rdpmc		: 1, /* The RDPMC instruction can be used to read counts */
> 	cap_user_time		: 1, /* The time_* fields are used */
> 	cap_user_time_zero	: 1, /* The time_zero field is used */
> 

So let me think through the possible combinations:

OLD-KERNEL OLD-HEADER
   + cap_usr_rdpmc and cap_usr_time map to the same bit
   + In general for kernels from 3.4 to 3.11 the bit will be set
     for all x86

NEW-KERNEL OLD-HEADER
   + cap_usr_rdpmc (cap_bit0) and cap_usr_time (cap_bit0) both are 0
   + code detecting cap_usr_rdpmc will probably fall back to non-rdpmc
     even through rdpmc code is probably there and functioning

OLD-KERNEL NEW-HEADER
   + cap_user_rdpmc and cap_user_time both set to 0
   + cap_bit0_is_deprecated can be read; if it is 0 you can
     read cap_bit0, and if it is 1, assume rdpmc is available
     with the same likelyhood you could with the old header

NEW-KERNEL NEW-HEADER
   + Use cap_user_rdpmc and cap_user_time and everything is OK


>  - Rename all the bitfield names in perf_event.h to be different from the
>    old names, to make sure it's not possible to mis-compile it
>    accidentally with old assumptions.

Well this breaks that API, though I guess there are no guarantees there.
I guess that's intentional since it will force 
users to fix their code, but a pain if you aren't expecting it and 
suddenly your project doesn't compile anymore after a kernel-headers 
update.  Most of my code carries around its own perf_event.h so I guess
I'll be unaffected.

In any case this seems to be about as reasonable a solution to this 
problem as we can get.

Vince
