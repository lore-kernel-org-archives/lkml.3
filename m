Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKYXV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:21:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaKYXVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:21:25 -0500
Date: Tue, 25 Nov 2014 18:20:50 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: zheng.z.yan@intel.com, ak@linux.intel.com, peterz@infradead.org,
        eranian@google.com
Subject: Re: perf/x86/intel/uncore: Add Haswell-EP uncore support
Message-ID: <20141125232050.GA9408@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	zheng.z.yan@intel.com, ak@linux.intel.com, peterz@infradead.org,
	eranian@google.com
References: <20141013152950.11DE26610F1@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013152950.11DE26610F1@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Commit:     e735b9db12d76d45f74aee78bd63bbd2f8f480e1
 > Author:     Yan, Zheng <zheng.z.yan@intel.com>
 > AuthorDate: Thu Sep 4 16:08:26 2014 -0700
 > Committer:  Ingo Molnar <mingo@kernel.org>
 > CommitDate: Wed Sep 24 14:48:21 2014 +0200
 > 
 >     perf/x86/intel/uncore: Add Haswell-EP uncore support

This commit added some code which looks a bit fishy, and got flagged
by coverity in yesterdays scan.

There are a few cases like this :

 > +static void hswep_cbox_enable_event(struct intel_uncore_box *box,
 > +				  struct perf_event *event)
 > +{
 > +	struct hw_perf_event *hwc = &event->hw;
 > +	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
 > +
 > +	if (reg1->idx != EXTRA_REG_NONE) {
 > +		u64 filter = uncore_shared_reg_config(box, 0);
 > +		wrmsrl(reg1->reg, filter & 0xffffffff);
 > +		wrmsrl(reg1->reg + 1, filter >> 32);
 > +	}
 > +
 > +	wrmsrl(hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
 > +}

given the definition of wrmsrl ..

#define wrmsrl(msr, val)	\
       native_write_msr((msr), (u32)((u64)(val)), (u32)((u64)(val) >> 32))

We can see that coverity got upset because it realised that the
code is turned into constant expressions.

result_independent_of_operands: (u64)(filter & 4294967295U) >> 32 is 0
regardless of the values of its operands.
a function call.

result_independent_of_operands: (u64)(filter >> 32) >> 32 is 0
regardless of the values of its operands.


I couldn't quickly decipher which MSRs we're writing to here in the SDM,
but are these really 64-bit wide registers that need 32 bits always set to zero ?
I'm wondering if these should be just wrmsr's instead of wrmsrl's.

If someone more familiar with perf hw can let me know if this is safe,
I'll dismiss the reports in coverity.

thanks,

	Dave

