Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3KLRzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:55:10 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36319 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3KLRzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:55:05 -0500
Date: Tue, 12 Nov 2013 10:55:01 -0700
From: jerry.hoemann@hp.com
To: Pekka Enberg <penberg@kernel.org>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Message-ID: <20131112175500.GA22363@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:37:29PM +0200, Pekka Enberg wrote:
> On Tue, Nov 12, 2013 at 4:15 AM, Jerry Hoemann <jerry.hoemann@hp.com> wrote:
> > Some platform have firmware that violates UEFI spec and access boot service
> > code or data segments after the system has called Exit Boot Services.
> > The call to efi_reserve_boot_services in setup_arch is a work around to
> > avoid using boot service memory until after the kernel has done
> > Set Virtual Map.
> >
> > However, this reservation fragments memory which can cause
> > large allocations early in boot (e.g. crash kernel) to fail.
> 
> What is the exact problem you're trying to solve here?

Pekka,

My primary motivation is fixing an issue that can causes kdump
to be disabled on a system.


Sequence of events:

1. The kernel calls efi_reserve_boot_services during setup_arch.

2. efi_reserve_boot_services reserves memory regions of type
   EFI_BOOT_SERVICES_CODE & EFI_BOOT_SERVICES_DATA.

3. setup_arch calls reserve_crashkernel().

4. start_kernel calls efi_free_boot_services which frees up the
   memory reserved by efi_reserve_boot_services().


The problem is that dependent upon the size of the crash kernel reservation,
the layout of the memory, and the location of the Boot Service Code and
Data segments,  reserve_crashkernel could fail where it would have
succeeded if the call to efi_reserve_boot_services hadn't been
made.

When reserve_crashkernel fails, kdump will be disabled.

The problem is made more apparent as large servers need large crash
kernel allocations.

The UEFI spec states that BS Code and Data segments are free
to be reused by an operating system after call to Exit Boot
Services.   Unfortunately,  some platforms apparently violate this 
portion of the spec and will use these segments as part of
the call to Set Virtual Map.  This can cause the system to crash
if Linux changed the content of the memory.

Hence,  the call to efi_reserve_boot_services was added as
a work around to platforms that violated this portion of the
UEFI spec.

Unfortunately,  the work around causes problems as described above.



For more background on efi_reserve_boot_services, please consult the thread:
https://lkml.org/lkml/2013/7/31/553



> How will the 
> problem be fixed for platforms that break the UEFI specification?
> 
>                         Pekka

My change does not address platforms that have misbehaving firmware.
It just allows platforms that don't have this issue to avoid issues
that the call to efi_reserve_boot_services presents.


Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

