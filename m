Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaKOBWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 20:22:04 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58424 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaKOBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 20:22:02 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3293D455@ORSMSX114.amr.corp.intel.com>
References: <CALCETrXdaEYjjfsTYySDXZvBHON10-EQRftV-OSCWTKMsUfOtg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3293D455@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Nov 2014 17:21:40 -0800
Message-ID: <CALCETrVLwzhQVMbu2c=NCzAfEBWa8=SOpfu5gPoxpuTBcNngRA@mail.gmail.com>
Subject: Re: Request for help: what did I do wrong with idtentry?
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 4:52 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> causes Tony's MCE stress test to fail, presumably when some CPU either
>> becomes permanently non-interruptable or otherwise wanders off into
>> the weeds.
>
> It might be that recent "improvements" I made to my test harness have
> messed things up.  I trimmed one delay (between injection and consumption),
> but it turns out the other delay in the code never get executed (because we
> take a SIGBUS on consumption and then longjmp).  So my test that used
> to pause a bit between iterations were running almost back to back
> consumption and injection of next error.

Hmm.

Am I right that the timeout code in mce.c is overly aggressive, too?

>
> This meant the serial console was a huge bottleneck (especially as my
> development BIOS is also kicking its own debug junk onto the same port).
> Some of the errors pointed obliquely at console.
>
> I've slowed things back down to where they used to be, and things are
> ticking along nicely (with 0.6 second delay between iterations).  Just
> passed the 2800 mark and still going.  I'm leaving it running over the
> weekend - if it makes it into the 50k level I'm willing to call it good.
>

Phew :)

FWIW, I've confirmed that my code survives int3 from userspace, int3
from normal kernel code, and int3 from kernel with user gs.  I'm not
completely thrilled with what it does to double_fault, though.  If we
somehow get a double fault caused by an interrupt hitting userspace
with a bad kernel_stack, then we'll end up page faulting in the
double_fault prologue.  I'm not convinced that this is worth worrying
about.  It would be easy enough to fix, though, even if it would
further uglify the code.

--Andy
