Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3KNSFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:05:06 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44998 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3KNSFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:05:01 -0500
Date: Thu, 14 Nov 2013 11:04:55 -0700
From: jerry.hoemann@hp.com
To: Pekka Enberg <penberg@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131114180455.GA32212@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>
 <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 10:24:17AM +0200, Pekka Enberg wrote:
> Hi Jerry,
> 
> On Thu, Nov 14, 2013 at 1:57 AM,  <jerry.hoemann@hp.com> wrote:
> > I will still point out that as currently used, efi_reserve_boot_services
> > is wrong.  A work around for firmware bugs on one platform shouldn't be
> > breaking platforms that don't have that bug.  Its just much less likely
> > to cause problems with higher crash kernel allocation.
> 
> Wrong in what way exactly?


efi_reserve_boot_services can cause reserve_crashkernel to fail.
This breaks kump.

Prior to 3.9, the area for crash dump had to be reserved below 896M.
crash kernel is in one physically contiguous space.

This is still the default way crash kernel is allocated post 3.9.

The size of crash kernel is based upon size of system (memory, cpus, IO)
and can get large.  On one of our new servers we need to allocate crash
kernels of 512MB or larger.   efi_reserve_boot_services reserve boot
service code/data and prevents it from being available to reserve_crashkernel.
When this reservation fragments memory below 896 MB, it breaks the
allocation for reserve_crashkernel.  It breaks kdump.

Distros based upon pre 3.9 kernels and w/ efi_reserve_boot_services
are subject to failure.


Customers who buy large servers want to be supported.  They want to
be able to take crash dumps and have bugs fixed.  This issue makes
crash dump more difficult or impossible dependent upon configuration
and kernel version.



 
> We need efi_reserve_boot_services on _some_ platforms and it's only practical
> to do it on all platforms to be able to boot a generic kernel.  Likewise, it


disagree.

efi_reserve_boot_services is necessary on some platforms, but
it should have been applied as a quirk as its a workaround for
broken firmware.

there are numerous examples in linux of other platform defects being
worked around as quirks.



> would be more practical to fix crashkernel on all platforms instead of adding a
> new code path in the kernel that won't receive as much testing coverage (we
> need to reserve boot services by default).

disagree.

The fix for this issue will have to be back ported across multiple releases
and distros.  A large change will be difficult to back port and debug.
There are kernel/tools rev locks in top of tree crash paths, these
will likely have to be back ported also.

Making this issue a quirk will be a lot more practical.  Its a small, focused
change whose implications are limited and more easily understood.

BTW, we test the crash path a lot.


> 
> And frankly, I don't understand why 'violating the UEFI specification' is even


Its background material to understand why the code is the way it is.
Its the reason that efi_reserve_boot_services was added to the kernel.
Its why we can't just drop efi_reserve_boot_services.


> brought up.  It's shipped firmware that matters here no matter how broken it
> is.  As long as there's a reasonable solution for crashkernel that works on all
> platforms, we should go for it instead of special-casing for 'proper firmware'
> because it makes testing the kernel more difficult.
> 
>                         Pekka

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

