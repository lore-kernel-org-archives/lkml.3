Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaJVPLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:11:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47789 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaJVPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:11:43 -0400
Date: Wed, 22 Oct 2014 17:11:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141022151135.GB15602@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022144952.GW12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022144952.GW12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:49:52PM +0200, Peter Zijlstra wrote:
> On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
> > +static void pt_config_start(bool start)
> > +{
> > +	u64 ctl;
> > +
> > +	rdmsrl(MSR_IA32_RTIT_CTL, ctl);
> > +	if (start)
> > +		ctl |= RTIT_CTL_TRACEEN;
> > +	else
> > +		ctl &= ~RTIT_CTL_TRACEEN;
> > +	wrmsrl(MSR_IA32_RTIT_CTL, ctl);
> > +
> > +	/*
> > +	 * A wrmsr that disables trace generation serializes other PT
> > +	 * registers and causes all data packets to be written to memory,
> > +	 * but a fence is required for the data to become globally visible.
> > +	 *
> > +	 * The below WMB, separating data store and aux_head store matches
> > +	 * the consumer's RMB that separates aux_head load and data load.
> > +	 */
> > +	if (!start)
> > +		wmb();
> > +}
> 
> wmb is sfence, is that sufficient? One would have expected an mfence
> since that would also orders later reads.

Silly me, we're separating two stores here. Ignore that.
