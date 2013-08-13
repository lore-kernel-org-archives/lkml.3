Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3HMP2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:28:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMP2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:28:14 -0400
Date: Tue, 13 Aug 2013 17:27:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as
 weight
Message-ID: <20130813152758.GB24092@twins.programming.kicks-ass.net>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <1376010946-28666-3-git-send-email-andi@firstfloor.org>
 <20130813112301.GV27162@twins.programming.kicks-ass.net>
 <20130813143517.GT19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813143517.GT19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:35:17PM +0200, Andi Kleen wrote:
> > How about something like the below instead? I didn't copy the !fll test
> > because I couldn't find why that was. Section 18.10.5.1 (Aug 2012)
> 
> !fll is so that if a memory weight is requested we don't overwrite it.

Oh, hum.. it would be good to document that collision. Neither your
changelog nor your patch clarified this. So fail on you.

> >  	u64 status, dla, dse, lat;
> >  };
> >  
> > -/*
> > - * Same as pebs_record_nhm, with two additional fields.
> > - */
> >  struct pebs_record_hsw {
> > -	struct pebs_record_nhm nhm;
> > -	/*
> > -	 * Real IP of the event. In the Intel documentation this
> > -	 * is called eventingrip.
> > -	 */
> > -	u64 real_ip;
> > -	/*
> > -	 * TSX tuning information field: abort cycles and abort flags.
> > -	 */
> > -	u64 tsx_tuning;
> > +	u64 flags, ip;
> > +	u64 ax, bx, cx, dx;
> > +	u64 si, di, bp, sp;
> > +	u64 r8,  r9,  r10, r11;
> > +	u64 r12, r13, r14, r15;
> > +	u64 status, dla, dse, lat;
> 
> Seems like an unrelated change.

Sorta, it gets rid of pebs_hsw. That should've never been introduced.

> > +	u64 real_ip; /* the actual eventing ip */
> > +	u64 tsx_tuning; /* TSX abort cycles and flags */
> >  };
> >  
> >  void init_debug_store_on_cpu(int cpu)
> > @@ -759,16 +754,41 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
> >  	return 0;
> >  }
> >  
> > +union hsw_tsx_tuning {
> > +	struct {
> > +		u64 cycles_last_block : 32,
> > +		    hle_abort         : 1,
> > +		    rtm_abort         : 1,
> > +		    ins_abort         : 1,
> > +		    non_ins_abort     : 1,
> > +		    retry             : 1,
> > +		    mem_data_conflict : 1,
> > +		    capacity          : 1;
> 
> I think you used an old SDM for this, there were some changes in the
> latest.

Like said, Aug 2012. If only Intel would properly announce new SDMs and
with better names than: 325462.pdf.

Let me go fetch a new one.

> This would break my next patch which copies the abort bits into 
> a new field (well it would need an union at least) 
> 
> https://git.kernel.org/cgit/linux/kernel/git/ak/linux-misc.git/commit/?h=hsw/pmu7&id=a88a029a6b3cb95148452584c93cbb4004f77f28

Make it a bigger mess: :-)

struct hsw_tsx_abort_info {
	union {
		u64 value;
		struct {
			u32 cycles_last_tx;
			union {
				u32 abort_reason : 8;
				struct {
					u32 hle_abort : 1,
					    rtm_abort : 1,
					    ins_abort : 1,
					    non_ins_abort : 1,
					    retry : 1,
					    data_conflict : 1,
					    capacity_writes : 1,
					    capacity_reads : 1;
				};
			};
		};
	};
};

Also, I think your patch is 'broken' in that it dumps the reserved bits
out to userspace and this brand spanking new SDM doesn't say they're 0.

> Other than that it seems ok and would likely generate the same
> code as mine. I prefer mine as it's simpler (I don't think there
> is anything in the kernel that needs to look at the individual bits,
> they should be just reported together)

The sole reason I even bothered poking at this was that your 'simple'
patch was out there ugly. The moment you need to struggle with that many
line breaks for a conditional you just know you've failed.

__intel_pmu_pebs_event() isn't getting any prettier with all those
pebs_format tests; but I'm not seeing anything to really fix that.
