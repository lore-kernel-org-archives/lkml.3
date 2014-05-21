Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaEUSMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:12:05 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:61882 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:12:03 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 11:11:41 -0700
Message-ID: <CALCETrUNWAU238xRZQ5zJwwQBArCHNzm=xsDBw4_LWGgGPjAuQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 5:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Here's a real proposal for iret-less return.  If this is correct, then
> NMIs will never nest, which will probably delete a lot more scariness
> than is added by the code I'm describing.

OK, here's a case where I'm wrong.  An NMI interrupts userspace on a
16-bit stack.  The return from NMI goes through the espfix code.
Something interrupts while on the espfix stack.  Boom!  Neither return
style is particularly good.

More generally, if we got interrupted while on the espfix stack, we
need to return back there using IRET.  Fortunately, re-enabling NMIs
there in harmless, since we've already switched off the NMI stack.

This makes me think that maybe the logic should be turned around: have
some RIP ranges on which the kernel stack might be invalid (which
includes the espfix code and some of the syscall code) and use IRET
only on return from NMI, return to nonstandard CS, and return to these
special ranges.  The NMI code just needs to never so any of this stuff
unless it switches off the NMI stack first.

For this to work reliably, we'll probably have to change CS before
calling into EFI code.  That should be straightforward.

--Andy
