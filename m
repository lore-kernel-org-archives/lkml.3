Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaBCANH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 19:13:07 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56723 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaBCANF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 19:13:05 -0500
MIME-Version: 1.0
In-Reply-To: <1391377190.9266.6.camel@wall-e.seibold.net>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net>
 <1391340435-5130-8-git-send-email-stefani@seibold.net> <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
 <1391377190.9266.6.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Feb 2014 16:12:44 -0800
Message-ID: <CALCETrX2K6DeGO7v+8Qed03xbKd0dcsoWVPg6fp6+KNGHnC+eA@mail.gmail.com>
Subject: Re: [PATCH 7/8] Add 32 bit VDSO time support for 32 bit kernel
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 2, 2014 at 1:39 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Sonntag, den 02.02.2014, 08:46 -0800 schrieb Andy Lutomirski:
>> On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
>> > From: Stefani Seibold <stefani@seibold.net>
>> >
>> > This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
>>
>> [...]
>>
>> Can you address the review comments from last time around?  For
>> example, this still seems to have redundant vvar and hpet mappings, it
>> doesn't use the VVAR macro, it moves the 32-bit compat vDSO, etc.
>>
>
> I will address the compat VDSO issue.
>
> But the VVAR macro will be not a part of this patch set. If you depend
> on this, feel free to create one. From my point of view this is not
> feasible without a macro hacking, because the address accessing the vvar
> area differs in kernel and VDSO user mode.

Sorry, but "I will make the code messier for no apparent reason and I
will not offer to fix it in the same series" gets my NAK.

Hint: I'm talking about two or three lines of code in vvar.h.

>
> I also see no redundant mapping. There are two modes, one is the map of
> the kernel area the other maps the VDSO into the user space area. This
> is exactly the behaviour of the origin VDSO implementation.

No.

In your series there are *three* mappings.  There are:

 - The linear mapping that the kernel loader sets up (the writable
mapping used in the kernel).  This is implicit and, of course, fine.
 - There's the fixmap page, which aliases the normal kernel mapping at
a fixed address with the user, ro, and nx attributes.  The 64-bit vDSO
uses that mapping.  See vdso.h -- it's all arranged pretty clearly.
Your code, for no discernible reason, sets up a fixmap entry on
*32-bit* kernels.
 - The vma that you're setting up adjacent to the actual vdso text.
This is what you are using.

Please choose *one* user-readable mapping for the 32-bit vdso and
stick with it.  If the 64-bit vdso can use it to and userspace doesn't
break, even better.  But a pointless set of extra fixmap entries is
not okay.

hpa's right about the symbol versions, BTW -- those are ABI and will
probably break (at least) every new-enough Go binary.

--Andy
