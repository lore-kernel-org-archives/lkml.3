Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaEUSHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:07:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49109 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaEUSHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:07:43 -0400
Date: Wed, 21 May 2014 20:07:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140521180718.GN21205@pd.tnic>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
 <1400639227.9759.21.camel@pippen.local.home>
 <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <20140521094626.GB21205@pd.tnic>
 <CALCETrWkAnSe6kzha5+MmnZn+YT+rBrmu0vz+9Pr94uUjh9dDQ@mail.gmail.com>
 <20140521163002.GI21205@pd.tnic>
 <CALCETrXP1GSfgObP4DLbG+Reu3a4g=26aoOpe9jfUtt4_bzCfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrXP1GSfgObP4DLbG+Reu3a4g=26aoOpe9jfUtt4_bzCfQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:52:01AM -0700, Andy Lutomirski wrote:
> I think that some of these exceptions are synchronous things (e.g.
> int3 or page faults) that happen because the kernel caused them.
> 
> Anyway, going through the list:
> 
> Reset, INIT, and stpclk ought to be irrelevant -- we don't handle them anyway.

Yeah.

> SMI is already supposedly correct wrt nesting inside NMI.

It better be. :)

> Debug register stuff should be handled in my outline.  Hopefully
> correctly :)  We need to make sure that no breakpoints trip before the
> nmi count is incremented, but that should be straightforward as long
> as we don't do ridiculous things like poking at userspace addresses.
> I don't know how kgdb/kdb fits in -- if someone sets a watchpoint on a
> kernel address (e.g. the nesting count) or enables single-stepping,
> we'll mess up.
> 
> 
> It may pay to bump the nesting count inside the #DB and #BP handlers
> and to check the RIP that we're returning to,

Right, at a first glance, all those higher prio exceptions' nesting
count could be nicely dealt with in those paranoidzeroentry* macros.

> but that starts to look ugly, and we have to be careful about NMI,
> immediate breakpoint, and them immediate MCE.

Btw, hpa just confirmed that exceptions are never deferred and thus can
happen while the NMI nahdler runs. Which means, we should defensively
prepare for NMI handlers being interrupted at any point.

> I'd rather just be able to say that there are some very short windows
> in which a debug or breakpoint exception will never happen.

Sounds perfectly fine to me.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
