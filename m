Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaHUQDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:03:45 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58038 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaHUQDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140812190726.GC13996@laptop.dumpdata.com>
References: <53E4B281.5050302@canonical.com>
	<53E4C5D5.2090103@citrix.com>
	<53E4E042.1070300@canonical.com>
	<CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>
	<53EA5782.1080301@canonical.com>
	<CAGXu5jJXHd9WqWs+FHQsRZdJNv1n075q7rwm20EwwXBdVgaVsA@mail.gmail.com>
	<20140812190726.GC13996@laptop.dumpdata.com>
Date: Thu, 21 Aug 2014 11:03:40 -0500
X-Google-Sender-Auth: RkqpVRMbqrHSvl5reVlP1vs7lQk
Message-ID: <CAGXu5jJFkdgaSs=5eWczWW5f3Gbr_-GLf3r_VXHq4z3rULVo_A@mail.gmail.com>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel 3.16)
From: Kees Cook <keescook@chromium.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:07 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Aug 12, 2014 at 11:53:03AM -0700, Kees Cook wrote:
>> On Tue, Aug 12, 2014 at 11:05 AM, Stefan Bader
>> <stefan.bader@canonical.com> wrote:
>> > On 12.08.2014 19:28, Kees Cook wrote:
>> >> On Fri, Aug 8, 2014 at 7:35 AM, Stefan Bader <stefan.bader@canonical.com> wrote:
>> >>> On 08.08.2014 14:43, David Vrabel wrote:
>> >>>> On 08/08/14 12:20, Stefan Bader wrote:
>> >>>>> Unfortunately I have not yet figured out why this happens, but can confirm by
>> >>>>> compiling with or without CONFIG_RANDOMIZE_BASE being set that without KASLR all
>> >>>>> is ok, but with it enabled there are issues (actually a dom0 does not even boot
>> >>>>> as a follow up error).
>> >>>>>
>> >>>>> Details can be seen in [1] but basically this is always some portion of a
>> >>>>> vmalloc allocation failing after hitting a freshly allocated PTE space not being
>> >>>>> PTE_NONE (usually from a module load triggered by systemd-udevd). In the
>> >>>>> non-dom0 case this repeats many times but ends in a guest that allows login. In
>> >>>>> the dom0 case there is a more fatal error at some point causing a crash.
>> >>>>>
>> >>>>> I have not tried this for a normal PV guest but for dom0 it also does not help
>> >>>>> to add "nokaslr" to the kernel command-line.
>> >>>>
>> >>>> Maybe it's overlapping with regions of the virtual address space
>> >>>> reserved for Xen?  What the the VA that fails?
>> >>>>
>> >>>> David
>> >>>>
>> >>> Yeah, there is some code to avoid some regions of memory (like initrd). Maybe
>> >>> missing p2m tables? I probably need to add debugging to find the failing VA (iow
>> >>> not sure whether it might be somewhere in the stacktraces in the report).
>> >>>
>> >>> The kernel-command line does not seem to be looked at. It should put something
>> >>> into dmesg and that never shows up. Also today's random feature is other PV
>> >>> guests crashing after a bit somewhere in the check_for_corruption area...
>> >>
>> >> Right now, the kaslr code just deals with initrd, cmdline, etc. If
>> >> there are other reserved regions that aren't listed in the e820, it'll
>> >> need to locate and skip them.
>> >>
>> >> -Kees
>> >>
>> > Making my little steps towards more understanding I figured out that it isn't
>> > the code that does the relocation. Even with that completely disabled there were
>> > the vmalloc issues. What causes it seems to be the default of the upper limit
>> > and that this changes the split between kernel and modules to 1G+1G instead of
>> > 512M+1.5G. That is the reason why nokaslr has no effect.
>>
>> Oh! That's very interesting. There must be some assumption in Xen
>> about the kernel VM layout then?
>
> No. I think most of the changes that look at PTE and PMDs are are all
> in arch/x86/xen/mmu.c. I wonder if this is xen_cleanhighmap being
> too aggressive

(Sorry I had to cut our chat short at Kernel Summit!)

I sounded like there was another region of memory that Xen was setting
aside for page tables? But Stefan's investigation seems to show this
isn't about layout at boot (since the kaslr=0 case means no relocation
is done). Sounds more like the split between kernel and modules area,
so I'm not sure how the memory area after the initrd would be part of
this. What should next steps be, do you think?

-Kees


>>
>> -Kees
>>
>> --
>> Kees Cook
>> Chrome OS Security
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org
>> http://lists.xen.org/xen-devel



-- 
Kees Cook
Chrome OS Security
