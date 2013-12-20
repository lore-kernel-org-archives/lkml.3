Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214Ab3LTN4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:56:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189Ab3LTN4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:56:02 -0500
Date: Fri, 20 Dec 2013 13:55:56 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131220135556.GB11295@suse.de>
References: <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131219142405.GM11295@suse.de>
 <20131219164925.GA29546@gmail.com>
 <20131220111303.GZ11295@suse.de>
 <20131220111818.GA23349@gmail.com>
 <20131220115854.GA11295@suse.de>
 <20131220122019.GA24479@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131220122019.GA24479@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 01:20:19PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > tlb_flushall_shift == -1	Always use flush all
> > tlb_flushall_shift == 1		Aggressively use individual flushes
> > tlb_flushall_shift == 6		Conservatively use individual flushes
> > 
> > IvyBridge was too aggressive using individual flushes and my patch 
> > makes it less aggressive.
> > 
> > Intel's code for this currently looks like
> > 
> >         switch ((c->x86 << 8) + c->x86_model) {
> >         case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
> >         case 0x616: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
> >         case 0x617: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
> >         case 0x61d: /* six-core 45 nm xeon "Dunnington" */
> >                 tlb_flushall_shift = -1;
> >                 break;
> >         case 0x61a: /* 45 nm nehalem, "Bloomfield" */
> >         case 0x61e: /* 45 nm nehalem, "Lynnfield" */
> >         case 0x625: /* 32 nm nehalem, "Clarkdale" */
> >         case 0x62c: /* 32 nm nehalem, "Gulftown" */
> >         case 0x62e: /* 45 nm nehalem-ex, "Beckton" */
> >         case 0x62f: /* 32 nm Xeon E7 */
> >                 tlb_flushall_shift = 6;
> >                 break;
> >         case 0x62a: /* SandyBridge */
> >         case 0x62d: /* SandyBridge, "Romely-EP" */
> >                 tlb_flushall_shift = 5;
> >                 break;
> >         case 0x63a: /* Ivybridge */
> >                 tlb_flushall_shift = 2;
> >                 break;
> >         default:
> >                 tlb_flushall_shift = 6;
> >         }
> > 
> > That default shift of "6" is already conservative which is why I 
> > don't think we need to change anything there. AMD is slightly more 
> > aggressive in their choices but not enough to panic.
> 
> Lets face it, the per model tunings are most likely crap: the only 
> place where it significantly deviated from '6' was Ivybridge - and 
> there it was causing a regression.
> 
> With your patch we'll have 6 everywhere, except on SandyBridge where 
> it's slightly more agressive at 5 - which is probably noise.
> 
> So my argument is that we should use '6' _everywhere_ and do away with 
> the pretense that we do per model tunings...
> 

Understood. I prototyped a suitable patch and stuck it in a queue. I
also took the libery of adding a patch that also reset IvyBridge to 6
out of curiousity. I'll post a suitable series once I have results.

-- 
Mel Gorman
SUSE Labs
