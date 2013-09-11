Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3IKPWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:22:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20055 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3IKPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:22:19 -0400
Date: Wed, 11 Sep 2013 11:21:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911152149.GA22076@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
 <20130911134717.GA10925@phenom.dumpdata.com>
 <20130911135745.GB11043@phenom.dumpdata.com>
 <20130911142545.GA11364@phenom.dumpdata.com>
 <20130911105633.1c029147@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911105633.1c029147@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 10:56:33AM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 10:25:45 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > > It seems to imply line 53 is the originating bug, so that would be:
> > > 
> > >  47         if (type == JUMP_LABEL_ENABLE) {
> > >  48                 /*
> > >  49                  * We are enabling this jump label. If it is not a nop
> > >  50                  * then something must have gone wrong.
> > >  51                  */
> > >  52                 if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> > >  53                         bug_at((void *)entry->code, __LINE__);
> > > 
> > > But it is a NOP isn't it? The code is
> > > 
> > > Unexpected op at trace_clock_global+0x6b/0x120 [ffffffff8113a21b] (0f 1f 44 00 00) 53
> > > 
> > > Perhaps the ideal_nop has not been set yet?
> > > 
> > 
> > And this looks to fix it for me.
> 
> I'm trying to understand how this will fix it for you. Are you sure you
> removed 'xen_nopvspin'?

Yes.
> 
> If you are calling static_key_slow_inc() before jump_label_init(), then
> it should still fail. The static_key_slow_inc() eventually calls
> arch_jump_label_transform(), which calls __jump_label_transform() with
> init == 0.

Perhaps I am misreading the code, but I believe init is set to one.
That is due to us calling:

arch_jump_label_transform (.., JUMP_LABEL_ENABLE)

which calls __jump_label_transform(.., 1)
?

Perhaps the 'init' and 'enable' parameters have different meanings?

> 
> The below code looks to me that it would still compare the contents
> with the ideal_nop, which hasn't been set yet.

In the !init case - sure. 

In the init case - just with default_nop.

> 
> -- Steve
> 
> > 
> > diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> > index ee11b7d..d688348 100644
> > --- a/arch/x86/kernel/jump_label.c
> > +++ b/arch/x86/kernel/jump_label.c
> > @@ -44,13 +44,20 @@ static void __jump_label_transform(struct jump_entry *entry,
> >  	union jump_code_union code;
> >  	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
> >  
> > +	if (init) {
> > +		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
> > +		if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
> > +			bug_at((void *)entry->code, __LINE__);
> > +	}
> >  	if (type == JUMP_LABEL_ENABLE) {
> >  		/*
> >  		 * We are enabling this jump label. If it is not a nop
> >  		 * then something must have gone wrong.
> >  		 */
> > -		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> > -			bug_at((void *)entry->code, __LINE__);
> > +		if (!init) {
> > +			if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
> > +				bug_at((void *)entry->code, __LINE__);
> > +		}
> >  
> >  		code.jump = 0xe9;
> >  		code.offset = entry->target -
> > @@ -62,11 +69,7 @@ static void __jump_label_transform(struct jump_entry *entry,
> >  		 * If this is the first initialization call, then we
> >  		 * are converting the default nop to the ideal nop.
> >  		 */
> > -		if (init) {
> > -			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
> > -			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
> > -				bug_at((void *)entry->code, __LINE__);
> > -		} else {
> > +		if (!init) {
> >  			code.jump = 0xe9;
> >  			code.offset = entry->target -
> >  				(entry->code + JUMP_LABEL_NOP_SIZE);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
