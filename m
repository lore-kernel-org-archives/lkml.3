Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab3LXEfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 23:35:17 -0500
Received: from ozlabs.org ([203.10.76.45]:55473 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab3LXEfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 23:35:14 -0500
Message-ID: <1387859710.15093.4.camel@concordia>
Subject: Re: [PATCH V4 08/10] powerpc, perf: Enable SW filtering in branch
 stack sampling framework
From: Michael Ellerman <mpe@ellerman.id.au>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org,
        ak@linux.intel.com, eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Date: Tue, 24 Dec 2013 15:35:10 +1100
In-Reply-To: <52B9049D.4020403@linux.vnet.ibm.com>
References: <20131209062146.EABBE2C00C1@ozlabs.org>
	 <52B42394.4060705@linux.vnet.ibm.com> <1387855790.15093.1.camel@concordia>
	 <52B9049D.4020403@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 09:20 +0530, Anshuman Khandual wrote:
> On 12/24/2013 08:59 AM, Michael Ellerman wrote:
> > On Fri, 2013-12-20 at 16:31 +0530, Anshuman Khandual wrote:
> >> On 12/09/2013 11:51 AM, Michael Ellerman wrote:
> >>> On Wed, 2013-04-12 at 10:32:40 UTC, Anshuman Khandual wrote:
> >>>> +
> 
> >>>> +	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_COND) {
> >>>> +
> >>>> +		/* I-form instruction - excluded */
> >>>> +		if (instr_is_branch_iform(*addr))
> >>>> +			goto out;
> >>>> +
> >>>> +		/* B-form or XL-form instruction */
> >>>> +		if (instr_is_branch_bform(*addr) || instr_is_branch_xlform(*addr))  {
> >>>> +
> >>>> +			/* Not branch always  */
> >>>> +			if (!is_bo_always(*addr)) {
> >>>> +
> >>>> +				/* Conditional branch to CTR register */
> >>>> +				if (is_bo_ctr(*addr))
> >>>> +					goto out;
> >>>
> >>> We might have discussed this but why not?
> >>
> >> Did not get that, discuss what ?
> > 
> > Why are we saying a conditional branch to the CTR is not a conditional branch?
> > 
> > It is conditional, so I think it should be included.

> I believe conditional branch to CTR register and the below conditional branch
> with static hint are excluded when processed with BHRB PMU based filter IFM3,
> Here the SW implemented filter try to match those exclusions, so that a user
> should not see any difference in results whether the filter is processed
> either in PMU or in SW.

OK. That's what I meant by "we might have discussed this".

So you need to make it very clear in the code that we are implementing the IFM3
semantics, with a comment. Otherwise it's not obviously clear why those
semantics make sense.

And we need to make extra sure we implement the same semantics as IFM3, which I
don't think you do at the moment.

The description for IFM3 is:

   Do not record:
    * b and bl instructions, 
    * bc and bcl instructions for which the BO field indicates “Branch always.”
   
   For bclr, bclrl, bctr, bctrl, bctar, and bctarl instructions for which
   the BO field indicates “Branch always,” record only one entry
   containing the Branch target address.

So I don't think your SW filter implements that part correctly. You are
discarding all branches with "branch always" set.


   Do not record:
    * Branch instructions for which BO[0]=1, 

This is what excludes branches to CTR. But, it's only branches to CTR that
don't also depend on CR[BI] - we need to make that clear in the code.

    * Branch instructions for which the “a” bit in the BO field is set to 1.

So that's the is_bo_crbi_hint() check and rejection, but it's not related to
CR[BI] at all.

There's a note about CR[BI]:

    Do not record instructions that do not depend on the value of CR[BI].

But I think you've misinterpreted that. 

    Do not record instructions that do not depend on the value of CR[BI].

    Do     record instructions that        depend on the value of CR[BI].


In fact the only branches that don't depend on CR[BI] are "branch always"
branches, and branches with BO[0]=1, both of which were handled above.

cheers


