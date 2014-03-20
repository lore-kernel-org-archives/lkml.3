Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbaCTPCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:02:49 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60039 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbaCTPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:02:47 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1403201328520.18573@ionos.tec.linutronix.de>
References: <1395301511-5908-1-git-send-email-stefani@seibold.net>
 <alpine.DEB.2.02.1403201039400.18573@ionos.tec.linutronix.de>
 <1395315494.1127.3.camel@vger.seibold.net> <alpine.DEB.2.02.1403201328520.18573@ionos.tec.linutronix.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Mar 2014 08:02:26 -0700
Message-ID: <CALCETrVgC7yKsu0KM0=TfUuX9msn9ru_nG=Fv6Mz6PKDTnWGnQ@mail.gmail.com>
Subject: Re: [PATCH] x86, vdso32: fix out of memory handling setup vDSO
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 5:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 20 Mar 2014, Stefani Seibold wrote:
>> Am Donnerstag, den 20.03.2014, 10:53 +0100 schrieb Thomas Gleixner:
>> > On Thu, 20 Mar 2014, Stefani Seibold wrote:
>> >
>> > > This patch add a correct out of memory handling for setup a 32 bit vDSO.
>> > >
>> > > The patch is against tip commit 4e40112c4ff6a577dd06d92b2a54cdf06265bf74
>> > >
>> > > Signed-off-by: Stefani Seibold <stefani@seibold.net>
>> > > ---
>> > >  arch/x86/vdso/vdso32-setup.c | 17 ++++++++++++++++-
>> > >  1 file changed, 16 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
>> > > index 0bc363a..e1171c2 100644
>> > > --- a/arch/x86/vdso/vdso32-setup.c
>> > > +++ b/arch/x86/vdso/vdso32-setup.c
>> > > @@ -134,8 +134,14 @@ int __init sysenter_setup(void)
>> > >   }
>> > >
>> > >   vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
>> > > - vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC);
>> > > +
>> > > + vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC);
>> >
>> > Why is this GFP_ATOMIC and not GFP_ATOMIC ?
>> >
>> > That code is called either from identify_boot_cpu(), where GFP_KERNEL
>> > is perfectly valid and from subsys_initcall(sysenter_setup) which is
>> > way late in the boot process where GFP_KERNEL is the RightThing.
>> >
>> > Aside of that, why do we need to call it early for X86_32 and late for
>> > X86_64?
>> >
>> > We need the vdso before we head off to user space, but not in the
>> > early boot process.
>> >
>>
>> All complains are design decisions not made by me. I will send a patch
>> for the GFP_ATOMIC thing. For the other one it would be the best to ask
>> Andy for the reason.
>
> I'm not saying it's your fault, but if we rework code, then we really
> should question such things. What happens if you remove the x32 call
> and make the x64 subsys thing valid for both cases?
>

It's not just that.  The x86_64 and x32 vdso page arrays are *far*
cleaner than the 32-bit variant.  They manage to do the entire vdso
setup dance without any allocation at all.  This avoids silly
questions about error handling and GFP_KERNEL :)

See vdso/vdso.S for the rather small amount of magic needed.

--Andy
