Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3FCMkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:40:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60314 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab3FCMkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:40:36 -0400
Date: Mon, 3 Jun 2013 13:39:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130603123953.GE32242@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <20130603101809.GK18614@n2100.arm.linux.org.uk>
 <20130603102723.GD32242@mudshark.cambridge.arm.com>
 <20130603104534.GL18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603104534.GL18614@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:45:34AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 03, 2013 at 11:27:23AM +0100, Will Deacon wrote:
> > On Mon, Jun 03, 2013 at 11:18:09AM +0100, Russell King - ARM Linux wrote:
> > > On Thu, May 30, 2013 at 12:41:12PM +0100, Will Deacon wrote:
> > > > +#if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)
> > > > +	/*
> > > > +	 * We may have faulted trying to load the SWI instruction due to
> > > > +	 * concurrent page aging on another CPU. In this case, return
> > > > +	 * back to the swi instruction and fault the page back.
> > > > +	 */
> > > > +9001:
> > > > +	sub	lr, lr, #4
> > > > +	str	lr, [sp, #S_PC]
> > > > +	b	ret_fast_syscall
> > > > +#endif
> > > 
> > > The comment is wrong.  If we get here, it means that the fault from
> > > trying to loading the instruction can't be fixed up.  Arguably, that
> > > should result in a SIGSEGV being sent immediately, but we'll get to
> > > that when we then try to re-load the instruction.
> > 
> > Why would we kill the application in this case? The reported problem is
> > where one CPU ages the page containing the swi instruction (mkold =>
> > clears L_PTE_YOUNG => write 0 to the pte) in between the other CPU executing
> > the swi and the kernel trying to read the immediate. The VMA is fine.
> 
> If you mark the instruction was a user-accessing instruction, the kernel
> will handle the resulting exception, trying to make the page accessible.
> If it is successful, then execution resumes as normal at the faulting
> instruction and continues as if nothing happened.
> 
> If it can't make the page accessible (eg, out of memory) the exception
> handler path (your code above) will be called instead.  Normal action in
> that case would be for a system call to return -EFAULT, but in this case
> we can't know what the syscall was, so we don't know if userspace will
> even pay attention to the returned error code.  In any case, if the page
> is no longer accessible, it's going to end up being killed by a SEGV
> when we eventually return to userspace anyway.

Yes, of course, the fault handling will sort out non-fatal faults for us, so
I'll update the comment.

Thanks,

Will
