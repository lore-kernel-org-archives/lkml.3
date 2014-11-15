Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaKOSpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 13:45:42 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45991 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaKOSpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 13:45:41 -0500
MIME-Version: 1.0
In-Reply-To: <20141115182806.GZ12538@two.firstfloor.org>
References: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293D455@ORSMSX114.amr.corp.intel.com>
 <CALCETrVLwzhQVMbu2c=NCzAfEBWa8=SOpfu5gPoxpuTBcNngRA@mail.gmail.com> <20141115182806.GZ12538@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 15 Nov 2014 10:45:19 -0800
Message-ID: <CALCETrUNcAwg7mSvxOQjPrvNpe=acqkhgSo8OJLyCA+WRJ3cOg@mail.gmail.com>
Subject: Re: Request for help: what did I do wrong with idtentry?
To: Andi Kleen <andi@firstfloor.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 10:28 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> I'm not
>> completely thrilled with what it does to double_fault, though.  If we
>> somehow get a double fault caused by an interrupt hitting userspace
>> with a bad kernel_stack, then we'll end up page faulting in the
>> double_fault prologue.  I'm not convinced that this is worth worrying
>> about.  It would be easy enough to fix, though, even if it would
>> further uglify the code.
>
> If you're "cleaning up" good and working code the functionality should
> be the same as before. The old code handled this situation fine.
> So your new code should handle this too.

First, this failure mode should be almost impossible.  We'd really
have to screw up to have the kernel stack point to a bad address.
(This isn't the stack *pointer* being bad -- it's the value in the
TSS.)

If this happens, the existing code will die (no recovery possible
unlike with normal OOPSes).  The new code will log a kernel-mode page
fault on the DF stack (as shown on the stack trace, assuming that
logic works), complain some more in do_exit, and make some sort of
effort to recover, which might even work.

In other words, I'd be happy to "fix" it, but I'm not entirely
convinced that this change should count as a regression in the first
place.

If we go for the fix-it approach, we could add a fixup in sync_regs
and probe the kernel_stack or we could add a paranoid=2 mode for
double_fault.

>
> In general yes handling all the corner cases makes code ugly.
> That is how the existing code got how it became.

Most of those corner cases are at least in code paths that are
supposed to work.  This particular corner case is in a handler that's
just trying to print something useful rather than silently rebooting,
and it should still work well enough to print something useful.

--Andy
