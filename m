Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaE1Qe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:34:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38952 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbaE1Qe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:34:56 -0400
Date: Wed, 28 May 2014 18:34:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        m.chehab@samsung.com, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140528163452.GF17196@pd.tnic>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140528112832.5f83c66b@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:28:32AM -0400, Steven Rostedt wrote:
> > +static void __trace_mem_error(const uuid_le *fru_id, char *fru_text,
> > +			       u32 err_number, u8 severity,
> > +			       struct cper_sec_mem_err *mem)
> > +{
> > +	u8 etype = ~0, pa_mask_lsb = ~0;
> > +	u64 pa = ~0ull;
> > +
> > +	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> > +		etype = mem->error_type;
> > +
> > +	if (mem->validation_bits & CPER_MEM_VALID_PA)
> > +		pa = mem->physical_addr;
> > +
> > +	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> > +		pa_mask_lsb = (u8)__ffs64(mem->physical_addr_mask);
> > +
> > +	memset(mem_location, 0, CPER_REC_LEN);
> > +	cper_mem_err_location(mem, mem_location);
> > +	memset(dimm_location, 0, CPER_REC_LEN);
> > +	cper_dimm_err_location(mem, dimm_location);
> > +	trace_extlog_mem_event(err_number, etype, severity, pa, pa_mask_lsb,
> > +			       fru_id, dimm_location, mem_location, fru_text);
> 
> This seems like a lot of work for a tracepoint. Why all the strings?
> Ideally, you want to record in the fast path the minimum raw data and
> reconstruct it at the time it is read.

Well, they're constructed from a bunch of values which are checked for
validity first:

http://lkml.kernel.org/r/1400142646-10127-4-git-send-email-gong.chen@linux.intel.com

We probably could get rid of the fru* things by reading them out from
ACPI and enumerating them and issuing only an index here which the slow
path decodes.

The others we can split into fields again which should definitely make
the record smaller. Fields are defined in struct cper_sec_mem_err.

The thing is, this TP needs to be designed properly before we expose it
to the world and so that hoperfully most future uses are covered.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
