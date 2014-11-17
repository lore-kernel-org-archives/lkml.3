Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaKQFTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 00:19:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56514 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaKQFTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 00:19:08 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Date: Mon, 17 Nov 2014 14:22:01 +0900 (JST)
Message-Id: <20141117.142201.925196285497025607.d.hatayama@jp.fujitsu.com>
To: ptesarik@suse.cz
Cc: vgoyal@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com,
        kexec@lists.infradead.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20141114133610.0e370d26@hananiah.suse.cz>
References: <20141114093145.746c7efe@hananiah.suse.cz>
	<20141114.185423.380949544673818300.d.hatayama@jp.fujitsu.com>
	<20141114133610.0e370d26@hananiah.suse.cz>
X-Mailer: Mew version 6.6 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
Date: Fri, 14 Nov 2014 13:36:10 +0100

> On Fri, 14 Nov 2014 18:54:23 +0900 (JST)
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
> 
>> From: Petr Tesarik <ptesarik@suse.cz>
>> Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
>> Date: Fri, 14 Nov 2014 09:31:45 +0100
>> 
>> > On Fri, 14 Nov 2014 10:42:35 +0900 (JST)
>> > HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>> > 
>> >> From: Petr Tesarik <ptesarik@suse.cz>
>> >> Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
>> >> Date: Thu, 13 Nov 2014 15:48:10 +0100
>> >> 
>> >> > On Thu, 13 Nov 2014 09:25:48 -0500
>> >> > Vivek Goyal <vgoyal@redhat.com> wrote:
>> >> > 
>> >> >> On Thu, Nov 13, 2014 at 05:30:21PM +0900, HATAYAMA, Daisuke wrote:
>> >> >> > 
>> >> >> > (2014/11/13 17:06), Petr Tesarik wrote:
>> >> >> > >On Thu, 13 Nov 2014 09:17:09 +0900 (JST)
>> >> >> > >HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>> >> >> > >
>> >> >> > >>From: Vivek Goyal <vgoyal@redhat.com>
>> >> >> > >>Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
>> >> >> > >>Date: Wed, 12 Nov 2014 17:12:05 -0500
>> >> >> > >>
>> >> >> > >>>On Wed, Nov 12, 2014 at 03:40:42PM +0900, HATAYAMA Daisuke wrote:
>> >> >> > >>>>Currently, VMCOREINFO note information reports the virtual address of
>> >> >> > >>>>phys_base that is assigned to symbol phys_base. But this doesn't make
>> >> >> > >>>>sense because to refer to value of the phys_base, it's necessary to
>> >> >> > >>>>get the value of phys_base itself we are now about to refer to.
>> >> >> > >>>>
>> >> >> > >>>
>> >> >> > >>>Hi Hatayama,
>> >> >> > >>>
>> >> >> > >>>/proc/vmcore ELF headers have virtual address information and using
>> >> >> > >>>that you should be able to read actual value of phys_base. gdb deals
>> >> >> > >>>with virtual addresses all the time and can read value of any symbol
>> >> >> > >>>using those headers.
>> >> >> > >>>
>> >> >> > >>>So I am not sure what's the need for exporting actual value of
>> >> >> > >>>phys_base.
>> >> >> > >>>
>> >> >> > >>
>> >> >> > >>Sorry, my logic in the patch description was wrong. For /proc/vmcore,
>> >> >> > >>there's enough information for makedumpdile to get phys_base. It's
>> >> >> > >>correct. The problem here is that other crash dump mechanisms that run
>> >> >> > >>outside Linux kernel independently don't have information to get
>> >> >> > >>phys_base.
>> >> >> > >
>> >> >> > >Yes, but these mechanisms won't be able to read VMCOREINFO either, will
>> >> >> > >they?
>> >> >> > >
>> >> >> > 
>> >> >> > I don't intend such sophisticated function only by VMCOREINFO.
>> >> >> > Search vmcore for VMCOREINFO using strings + grep before opening it by crash.
>> >> >> > I intend that only here.
>> >> >> 
>> >> >> I think this is very crude and not proper way to get to vmcoreinfo.
>> >> > 
>> >> > Same here. If VMCOREINFO must be locatable without communicating any
>> >> > information to the hypervisor, then I would rather go for something
>> >> > similar to what s390(x) folks do - a well-known location in physical
>> >> > memory that contains a pointer to a checksummed OS info structure,
>> >> > which in turn contains the VMCOREINFO pointers.
>> >> > 
>> >> > I'm a bit surprised such mechanism is not needed by Fujitsu SADUMP.
>> >> > Or is that part of the current plan, Daisuke?
>> >> > 
>> >> 
>> >> It's useful if there is. I don't plan now. For now, the idea of this
>> >> patch is enough for me.
>> >> 
>> >> BTW, for the above idea, I suspect that if the location in the
>> >> physical memory is unique, it cannot deal with the kdump 2nd kernel
>> >> case.
>> > 
>> > No, not at all. The low 640K are copied away to a pre-allocated area by
>> > kexec purgatory code on x86_64, so it's safe to overwrite any location
>> > in there. The copy is needed, because BIOS already uses some hardcoded
>> > addresses in that range. I think the Linux kernel may safely use part of
>> > PFN 0 starting at physical address 0x0500. This area was originally
>> > used by MS-DOS, so chances are high that no broken BIOS out there
>> > corrupts this part of RAM...
>> > 
>> 
>> In fact, I didn't consider in such deep way... I had forgot back up
>> region at all. But it's hard to use the low 640K area. Then, it's hard
>> to get phys_base of the kdump 1st kernel that is assumed to be saved
>> in thw low 640K now. Because externally running mechanism can run
>> after kdump 2nd kernel has booted up, crash utility needs to convert a
>> read request to the low 640K area into the corresponding part of the
>> pre-allocated area. See kdump_backup_region_init() in crash utility,
>> which tries to find the pre-allocated area via ELF header, where
>> symbol kexec_crash_image is read to find ELF header. This means we
>> need phys_base to find the pre-allocated area.
> 
> Wrong again, I'm afraid.
> 
> So, first of all, an admin should make up your mind if you want to use
> kexec-based dumping, or stand-alone dumping. OK, you seem to address
> a corner case when s/he configures both. But in that case, the

It's a never corner case. We usually use both. There's difference in
data reliability between kdump and others in that kdump can do cleanup
in kernel logic level at the end of the kdump 1st kernel prior to
kdump 2nd kernel, and difference in dumping feature that there's
makedumpfile that can filter memory to size of crash dump. OTOH,
external dump can still possibly work well even if kdump doesn't but
could generate less reliable data and has less features. After all,
it's best to use both.

> stand-alone dump can be used to look at _BOTH_ kernels, and the default
> should indeed be the one that was currently running. After all, I have
> already debugged the _SECONDARY_ kernel environment several times...
> 
> However, it even works. If somebody wants to see the crashed kernel
> from the same dump, they can use the second kernel's internal
> structures to locate the corresponding phys_base and pass that as an
> option to crash.
> 
> Let me illustrate the situation:
> 
>   +-------------------+
>   | secondary kernel  | <--- low 640K
>   | private pointers -+--\
>   |                   |  |  (1)
>   |                   |  |
>   +-------------------+<-+-----\
>   |                   |  |     |
>   | primary kernel    |  |     |
>   Z                   Z  |     |
>   |                   |  |     |
>   +-------------------+<-/     |  (3)
>   | secondary kernel  |        |
>   | (contains pointer |        |
>   |  to backup area) -+--\     |
>   +-------------------+  | (2) |
>   | backup area       |<-/     |
>   |                  -+--------/
>   +-------------------+
>   |                   |
>   | 1st kernel again  |
>   Z                   Z
>   +-------------------+
> 
> The information is nicely chained in this diagram:
> 
>   (1)  Low 640K allows you to find the currently running kernel
>        (here it is the kdump kernel).
>   (2)  This kernel knows where to find the backup area (otherwise it
>        couldn't correctly map them in /proc/vmcore).
>   (3)  The backup area allows yoou to find the previously runnning
>        kernel (the 1st kernel).
> 
> I really don't see any issues with the concept, although I haven't
> tried it in practice (yet).
> 
> Petr T

I'm not assuming that you intend to implement this logic in external
crash dump mechanisms such as qemu; this is too specific to Linux
kernel.

I still think the idea of my patch is simple and practical enough.

--
Thanks.
HATAYAMA, Daisuke

