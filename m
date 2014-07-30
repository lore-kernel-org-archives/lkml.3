Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaG3Qnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:43:55 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62623 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaG3Qnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:43:53 -0400
Date: Wed, 30 Jul 2014 18:43:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, linux-arch@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>, hpa@zytor.com
Subject: Re: [PATCH v4 2/5] x86,entry: Only call user_exit if TIF_NOHZ
Message-ID: <20140730164344.GA27954@localhost.localdomain>
References: <cover.1406604806.git.luto@amacapital.net>
 <7123b2489cc5d1d5abb7bcf1364ca729cab3e6ca.1406604806.git.luto@amacapital.net>
 <20140729193232.GA8153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729193232.GA8153@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 09:32:32PM +0200, Oleg Nesterov wrote:
> On 07/28, Andy Lutomirski wrote:
> >
> > @@ -1449,7 +1449,12 @@ long syscall_trace_enter(struct pt_regs *regs)
> >  {
> >  	long ret = 0;
> >  
> > -	user_exit();
> > +	/*
> > +	 * If TIF_NOHZ is set, we are required to call user_exit() before
> > +	 * doing anything that could touch RCU.
> > +	 */
> > +	if (test_thread_flag(TIF_NOHZ))
> > +		user_exit();
> 
> Personally I still think this change just adds more confusion, but I leave
> this to you and Frederic.
> 
> It is not that "If TIF_NOHZ is set, we are required to call user_exit()", we
> need to call user_exit() just because we enter the kernel. TIF_NOHZ is just
> the implementation detail which triggers this slow path.
> 
> At least it should be correct, unless I am confused even more than I think.

Agreed, Perhaps the confusion is on the syscall_trace_enter() name which suggests
this is only about tracing? syscall_slowpath_enter() could be an alternative.
But that's still tracing in a general sense so...
