Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaBQUIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:08:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55454 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbaBQUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:08:17 -0500
Date: Mon, 17 Feb 2014 21:08:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 1/3] x86: Add another set of MSR accessor functions
Message-ID: <20140217200813.GH4559@pd.tnic>
References: <1391953709-15400-1-git-send-email-bp@alien8.de>
 <1391953709-15400-2-git-send-email-bp@alien8.de>
 <5302371B.4090403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5302371B.4090403@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 08:21:47AM -0800, H. Peter Anvin wrote:
> Good patch series overall, but I do have some issues with this one:
> 
> On 02/09/2014 05:48 AM, Borislav Petkov wrote:
> > + */
> > +int msr_read(u32 msr, struct msr *m)
> > +{
> > +	int err;
> > +	u64 val;
> > +
> > +	val = native_read_msr_safe(msr, &err);
> 
> I don't think we should use the native_ function here.

Ah, right, pv gunk, I conveniently victimized those cache lines away
from my head. :-P

rdmsrl_safe it is.

> 
> > +	if (err)
> > +		pr_warn("%s: Error reading MSR 0x%08x\n", __func__, msr);
> > +	else
> > +		m->q = val;
> 
> I also don't think we should print a message if the MSR doesn't exist.
> This will be a normal occurrence in a number of flows.

Right, I was suspecting the screaming in dmesg could upset people but
wasn't sure. Good point.

> > +static int __flip_bit(u32 msr, u8 bit, bool set)
> > +{
> > +	struct msr m;
> > +
> > +	if (bit > 63)
> > +		return -1;
> 
> Feels a bit excessive, but I'd suggest returning -EINVAL instead.

Ok.

> I would suggest explicitly making this an inline function.

Sure.

> > +	if (msr_read(msr, &m))
> > +		return -1;
> 
> Return -EIO?

Actually, msr_read already gives a retval so I can simply carry that
out. And it *is* -EIO already :-)

> How about:
> 
> 	m1 = m;
> 	if (set)
> 		m1.q |= BIT_64(bit);
> 	else
> 		m1.q &= ~BIT_64(bit);
> 
> 	if (m1.q != m.q) {
> 		if (msr_write(...))
> 			...

It's all the same to me, sure.

> Again, I'm not sure if printing a message here makes sense. In fact,
> this is the second message you print for the same thing.

Ok, I'll make them completely silent - if their users wanna say
something, they can do that based on the retval. Good.

Thanks for checking them out - I'll start playing with the revised
versions on real hw.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
