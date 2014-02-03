Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBCHnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:43:53 -0500
Received: from www84.your-server.de ([213.133.104.84]:56242 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaBCHnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:43:52 -0500
Message-ID: <1391413467.965.21.camel@wall-e.seibold.net>
Subject: Re: [PATCH 7/8] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
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
Date: Mon, 03 Feb 2014 08:44:27 +0100
In-Reply-To: <CALCETrX2K6DeGO7v+8Qed03xbKd0dcsoWVPg6fp6+KNGHnC+eA@mail.gmail.com>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net>
	 <1391340435-5130-8-git-send-email-stefani@seibold.net>
	 <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
	 <1391377190.9266.6.camel@wall-e.seibold.net>
	 <CALCETrX2K6DeGO7v+8Qed03xbKd0dcsoWVPg6fp6+KNGHnC+eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 02.02.2014, 16:12 -0800 schrieb Andy Lutomirski:
> On Sun, Feb 2, 2014 at 1:39 PM, Stefani Seibold <stefani@seibold.net> wrote:
> > Am Sonntag, den 02.02.2014, 08:46 -0800 schrieb Andy Lutomirski:
> >> On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> >> > From: Stefani Seibold <stefani@seibold.net>
> >> >
> >> > This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
> >>
> >> [...]
> >>
> >> Can you address the review comments from last time around?  For
> >> example, this still seems to have redundant vvar and hpet mappings, it
> >> doesn't use the VVAR macro, it moves the 32-bit compat vDSO, etc.
> >>
> >
> > I will address the compat VDSO issue.
> >
> > But the VVAR macro will be not a part of this patch set. If you depend
> > on this, feel free to create one. From my point of view this is not
> > feasible without a macro hacking, because the address accessing the vvar
> > area differs in kernel and VDSO user mode.
> 
> Sorry, but "I will make the code messier for no apparent reason and I
> will not offer to fix it in the same series" gets my NAK.
> 
> Hint: I'm talking about two or three lines of code in vvar.h.
> 

A hint back: if you threat me with a NAK for a requested code sequence
which currently no user, this is far away from professional. I am not
your trainee.

BTW: If it is so easy, send me the two or three lines and i will merge
it ;-)

> >
> > I also see no redundant mapping. There are two modes, one is the map of
> > the kernel area the other maps the VDSO into the user space area. This
> > is exactly the behaviour of the origin VDSO implementation.
> 
> No.
> 
> In your series there are *three* mappings.  There are:
> 
>  - The linear mapping that the kernel loader sets up (the writable
> mapping used in the kernel).  This is implicit and, of course, fine.
>  - There's the fixmap page, which aliases the normal kernel mapping at
> a fixed address with the user, ro, and nx attributes.  The 64-bit vDSO
> uses that mapping.  See vdso.h -- it's all arranged pretty clearly.
> Your code, for no discernible reason, sets up a fixmap entry on
> *32-bit* kernels.
>  - The vma that you're setting up adjacent to the actual vdso text.
> This is what you are using.
> 
> Please choose *one* user-readable mapping for the 32-bit vdso and
> stick with it.  If the 64-bit vdso can use it to and userspace doesn't
> break, even better.  But a pointless set of extra fixmap entries is
> not okay.
> 

Again: I wrote that there are two modes for a 32 bit kernel and
therefore there are two mappings at the same time. Since there are both
ways available in a 32 bit kernel via the vdso32= kernel parameter, both
must be supported.

Due the lack of a real fixmap for a 32 bit kernel (FIXADDR_TOP is a
variable), the HPET and VVAR Page can only relative addressed. So this
pages must located before or after the VDSO. 

This is why i need to setup this pages into the fixmap area, this is the
compat mode "vdso32=2".

For "vdso32=1" i need to map the VDSO Page together with the HPET and
VVAR into the user space.

For compability reasons both mappings are required.

There is only one binary for the VDSO page, regardless of the vdso=
kernel parameter and this code can only do a relative addressing.

A 64 bit kernel can do it in an other way, because there is a real
fixmap area, so this special handling is not needed.

- Stefani


