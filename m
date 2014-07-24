Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbaGXNbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:31:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41059 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932723AbaGXNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:31:08 -0400
X-Sasl-enc: LxnvveOMum/CvmmA0eHBzV2WuyJWCTnX8BgJj1cCZVSh 1406208667
Date: Thu, 24 Jul 2014 10:30:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 5/8] x86, microcode, intel: don't use fields from unknown
 format header
Message-ID: <20140724133059.GA32421@khazad-dum.debian.net>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-6-git-send-email-hmh@hmh.eng.br>
 <20140724113726.GL19239@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724113726.GL19239@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Borislav Petkov wrote:
> On Wed, Jul 23, 2014 at 05:10:48PM -0300, Henrique de Moraes Holschuh wrote:
> > We must make sure the microcode has a known header format before
> > we attempt to access its Total Size or Data Size fields through
> > get_totalsize() or get_datasize().
> 
> Well, this is a pretty weak check but I'm all for being as defensive as
> possible with the microcode loader so yes, let's do it.
> 
> However, I'd carve it out from microcode_sanity_check() in a separate
> function called
> 
> static bool microcode_check_header(struct microcode_header_intel *hdr);
> 
> and do the ->hdrver and -> ldrver checks in it. In two places to be exact...

We care about ->hdrver to get data from the header.  We only care about
->ldrver for the exact procedure to install it in the processor.

The more correct implementation would be to not error out, but just skip
anything with an unknown ldrver.   We can't do that for an unknown hrdver,
since we don't know the size of the unknown data, but an unknown ldrver just
means we don't know how to punt the microcode to the processor.

Want me to respin the patch to do it like that?

> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > ---
> >  arch/x86/kernel/cpu/microcode/intel.c       |    5 +++++
> >  arch/x86/kernel/cpu/microcode/intel_early.c |    3 +++
> >  arch/x86/kernel/cpu/microcode/intel_lib.c   |   11 ++++++-----
> >  3 files changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
> > index a51cb19..61d430e 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel.c
> > @@ -199,6 +199,11 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
> >  		if (get_ucode_data(&mc_header, ucode_ptr, sizeof(mc_header)))
> >  			break;
> >  
> > +		if (mc_header.hdrver != 1) {
> > +			pr_err("error! Unknown microcode update format\n");
> > +			break;
> > +		}
> 
> ... here ...
> 
> > +
> >  		mc_size = get_totalsize(&mc_header);
> >  		if (!mc_size || mc_size > leftover) {
> >  			pr_err("error! Bad data in microcode data file\n");
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
> > index b88343f..c1bf915f 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_early.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_early.c
> > @@ -324,6 +324,9 @@ get_matching_model_microcode(int cpu, unsigned long start,
> >  	while (leftover) {
> >  		mc_header = (struct microcode_header_intel *)ucode_ptr;
> >  
> > +		if (mc_header->hdrver != 1)
> > +			break;
> > +
> 
> ... and here. I.e., everytime we're looking at a mc_header from userspace.
> 
> >  		mc_size = get_totalsize(mc_header);
> >  		if (!mc_size || mc_size > leftover ||
> >  			microcode_sanity_check(ucode_ptr, 0) < 0)
> > diff --git a/arch/x86/kernel/cpu/microcode/intel_lib.c b/arch/x86/kernel/cpu/microcode/intel_lib.c
> > index ce69320..95c2d19 100644
> > --- a/arch/x86/kernel/cpu/microcode/intel_lib.c
> > +++ b/arch/x86/kernel/cpu/microcode/intel_lib.c
> > @@ -52,6 +52,12 @@ int microcode_sanity_check(void *mc, int print_err)
> >  	int sum, orig_sum, ext_sigcount = 0, i;
> >  	struct extended_signature *ext_sig;
> >  
> > +	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> > +		if (print_err)
> > +			pr_err("error! Unknown microcode update format\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	total_size = get_totalsize(mc_header);
> >  	data_size = get_datasize(mc_header);
> >  
> > @@ -61,11 +67,6 @@ int microcode_sanity_check(void *mc, int print_err)
> >  		return -EINVAL;
> >  	}
> >  
> > -	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> > -		if (print_err)
> > -			pr_err("error! Unknown microcode update format\n");
> > -		return -EINVAL;
> > -	}
> 
> This one is then redundant.

Well, I just moved the test to a more appropriate place, it was already
there.  I didn't remove it because, IMHO, the intel microcode driver code is
already quite twisty, so I thought it was best to leave that duplicated
check in there just in case.

That said, microcode_sanity_check() requires that the caller perform one of
the most important checks (that the data it got from userspace is large
enough).  A better header-version abstraction would give us a
microcode_sanity_check(void **uc, uint32_t* remaining_size, ...) and a new
microcode_skip(void **uc, uint32_t* remaining_size) to walk/validate the
microcode.

I don't think it is really worth it to go that far ATM, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
