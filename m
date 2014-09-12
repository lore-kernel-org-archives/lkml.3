Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaILRma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:42:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:49189 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaILRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:42:29 -0400
Date: Fri, 12 Sep 2014 19:42:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <54130F9A.3000406@intel.com>
Message-ID: <alpine.DEB.2.10.1409121934520.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
 <54130F9A.3000406@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Dave Hansen wrote:
> On 09/12/2014 01:11 AM, Thomas Gleixner wrote:
> > So what you are saying is, that if user space sets the pointer to NULL
> > via the unregister prctl, kernel can safely ignore vmas which have the
> > VM_MPX flag set. I really can't follow that logic.
> >  
> > 	mmap_mpx();
> > 	prctl(enable mpx);
> > 	do lots of crap which uses mpx;
> > 	prctl(disable mpx);
> > 
> > So after that point the previous use of MPX is irrelevant, just
> > because we set a pointer to NULL? Does it just look like crap because
> > I do not get the big picture how all of this is supposed to work?
> 
> The prctl(register) is meant to be a signal from userspace to the kernel
> to say, "I would like your help in managing these bounds tables".
> prctl(unregister) is the opposite, meaning "I don't want your help any
> more".

Fine, but that's a totally different story. I can see the usefulness
of this, but then it's a complete misnomer. It should be:

   prctl(EN/DISABLE_MPX_BT_MANAGEMENT)

So this wants to be a boolean value and not some random user space
address collected at some random point and then ignored until you do
the magic cleanup. See the other reply.

> If userspace uses MPX, it does not necessarily want the kernel to do
> bounds table management all the time (or ever in some cases).  Without
> the prctl(), the kernel has no way of distinguishing what userspace wants.

Fine with me, but it needs to be done proper. And proper means: ON/OFF

The kernel has to handle the information for which context it
allocated stuff and then tear it down when the context goes
away. Relying on a user space address sampled at some random prctl
point is just stupid.

> > And then you need another bunch of logic in the prctl(disable mpx)
> > path to cleanup the mess instead of just setting a random pointer to
> > NULL.
> 
> The bounds tables potentially represent a *lot* of state.  If userspace
> wants to temporarily turn off the kernel's MPX bounds table management,
> it does not necessarily want that state destroyed.  On the other hand,
> if userspace feels the need to go destroying all the state, it is free
> to do so and does not need any help to do so from the kernel.

Fine with me, but the above still stands.

Thanks,

	tglx

 
