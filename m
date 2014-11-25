Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaKYN40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:56:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38915 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKYN4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:56:25 -0500
Date: Tue, 25 Nov 2014 13:56:26 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 2/6] arm64: ptrace: allow tracer to skip a system call
Message-ID: <20141125135626.GB8541@arm.com>
References: <1416273038-15590-1-git-send-email-takahiro.akashi@linaro.org>
 <1416273038-15590-3-git-send-email-takahiro.akashi@linaro.org>
 <20141118140425.GM18842@arm.com>
 <546C58DB.5080204@linaro.org>
 <20141119190601.GM15985@arm.com>
 <546D7860.2010300@linaro.org>
 <546D81A2.4040405@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D81A2.4040405@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:52:34AM +0000, AKASHI Takahiro wrote:
> On 11/20/2014 02:13 PM, AKASHI Takahiro wrote:
> > On 11/20/2014 04:06 AM, Will Deacon wrote:
> >> Ok, but now userspace sees -ENOSYS for a skipped system call in that case,
> >> whereas it would usually see whatever the trace put in x0, right?
> >
> > Yes.
> > If you don't really like this behavior, how about this patch instead of my [2/6] patch?
> >
> > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > index 726b910..1ef57d0 100644
> > --- a/arch/arm64/kernel/entry.S
> > +++ b/arch/arm64/kernel/entry.S
> > @@ -668,8 +668,15 @@ ENDPROC(el0_svc)
> >           * switches, and waiting for our parent to respond.
> >           */
> >   __sys_trace:
> > +       cmp     w8, #-1                         // default errno for invalid
> 
> I needed to correct the code here:
> w8 should be w26, thinking of compat syscalls.
> 
> > +       b.ne    1f                              // system call
> > +       mov     x0, #-ENOSYS
> > +       str     x0, [sp, #S_X0]
> > +1:
> 
> and this part might better be generalized like the following:
> 
> __sys_trace:
> 	cmp	w26, w25	// cannot use x26 and x25 here
> 	b.hs	1f		// scno > sc_nr || scno < 0
> 	b	2f
> 1:
> 	mov	x0, #-ENOSYS
> 	str	x0, [sp, #S_X0]
> 2:
> 
> If you will be comfortable, I will submit a new patch soon.

Yes, please send a new series including this change.

Will
