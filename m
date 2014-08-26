Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaHZQBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:01:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22081 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaHZQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:01:13 -0400
Date: Tue, 26 Aug 2014 12:01:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Kees Cook <keescook@chromium.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Xen PV domain regression with KASLR enabled (kernel
 3.16)
Message-ID: <20140826160100.GA14835@laptop.dumpdata.com>
References: <53E4B281.5050302@canonical.com>
 <53E4C5D5.2090103@citrix.com>
 <53E4E042.1070300@canonical.com>
 <CAGXu5jJ+FTqgYpLH5x0VBm9QMND-b0Sze6q6pc=tRe2oFMu5uA@mail.gmail.com>
 <53EA5782.1080301@canonical.com>
 <CAGXu5jJXHd9WqWs+FHQsRZdJNv1n075q7rwm20EwwXBdVgaVsA@mail.gmail.com>
 <20140812190726.GC13996@laptop.dumpdata.com>
 <CAGXu5jJFkdgaSs=5eWczWW5f3Gbr_-GLf3r_VXHq4z3rULVo_A@mail.gmail.com>
 <53F70B72.7030407@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F70B72.7030407@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:20:50AM +0200, Stefan Bader wrote:
> On 21.08.2014 18:03, Kees Cook wrote:
> > On Tue, Aug 12, 2014 at 2:07 PM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> >> On Tue, Aug 12, 2014 at 11:53:03AM -0700, Kees Cook wrote:
> >>> On Tue, Aug 12, 2014 at 11:05 AM, Stefan Bader
> >>> <stefan.bader@canonical.com> wrote:
> >>>> On 12.08.2014 19:28, Kees Cook wrote:
> >>>>> On Fri, Aug 8, 2014 at 7:35 AM, Stefan Bader <stefan.bader@canonical.com> wrote:
> >>>>>> On 08.08.2014 14:43, David Vrabel wrote:
> >>>>>>> On 08/08/14 12:20, Stefan Bader wrote:
> >>>>>>>> Unfortunately I have not yet figured out why this happens, but can confirm by
> >>>>>>>> compiling with or without CONFIG_RANDOMIZE_BASE being set that without KASLR all
> >>>>>>>> is ok, but with it enabled there are issues (actually a dom0 does not even boot
> >>>>>>>> as a follow up error).
> >>>>>>>>
> >>>>>>>> Details can be seen in [1] but basically this is always some portion of a
> >>>>>>>> vmalloc allocation failing after hitting a freshly allocated PTE space not being
> >>>>>>>> PTE_NONE (usually from a module load triggered by systemd-udevd). In the
> >>>>>>>> non-dom0 case this repeats many times but ends in a guest that allows login. In
> >>>>>>>> the dom0 case there is a more fatal error at some point causing a crash.
> >>>>>>>>
> >>>>>>>> I have not tried this for a normal PV guest but for dom0 it also does not help
> >>>>>>>> to add "nokaslr" to the kernel command-line.
> >>>>>>>
> >>>>>>> Maybe it's overlapping with regions of the virtual address space
> >>>>>>> reserved for Xen?  What the the VA that fails?
> >>>>>>>
> >>>>>>> David
> >>>>>>>
> >>>>>> Yeah, there is some code to avoid some regions of memory (like initrd). Maybe
> >>>>>> missing p2m tables? I probably need to add debugging to find the failing VA (iow
> >>>>>> not sure whether it might be somewhere in the stacktraces in the report).
> >>>>>>
> >>>>>> The kernel-command line does not seem to be looked at. It should put something
> >>>>>> into dmesg and that never shows up. Also today's random feature is other PV
> >>>>>> guests crashing after a bit somewhere in the check_for_corruption area...
> >>>>>
> >>>>> Right now, the kaslr code just deals with initrd, cmdline, etc. If
> >>>>> there are other reserved regions that aren't listed in the e820, it'll
> >>>>> need to locate and skip them.
> >>>>>
> >>>>> -Kees
> >>>>>
> >>>> Making my little steps towards more understanding I figured out that it isn't
> >>>> the code that does the relocation. Even with that completely disabled there were
> >>>> the vmalloc issues. What causes it seems to be the default of the upper limit
> >>>> and that this changes the split between kernel and modules to 1G+1G instead of
> >>>> 512M+1.5G. That is the reason why nokaslr has no effect.
> >>>
> >>> Oh! That's very interesting. There must be some assumption in Xen
> >>> about the kernel VM layout then?
> >>
> >> No. I think most of the changes that look at PTE and PMDs are are all
> >> in arch/x86/xen/mmu.c. I wonder if this is xen_cleanhighmap being
> >> too aggressive
> > 
> > (Sorry I had to cut our chat short at Kernel Summit!)
> > 
> > I sounded like there was another region of memory that Xen was setting
> > aside for page tables? But Stefan's investigation seems to show this
> > isn't about layout at boot (since the kaslr=0 case means no relocation
> > is done). Sounds more like the split between kernel and modules area,
> > so I'm not sure how the memory area after the initrd would be part of
> > this. What should next steps be, do you think?
> 
> Maybe layout, but not about placement of the kernel. Basically leaving KASLR
> enabled but shrink the possible range back to the original kernel/module split
> is fine as well.
> 
> I am bouncing between feeling close to understand to being confused. Konrad
> suggested xen_cleanhighmap being overly aggressive. But maybe its the other way
> round. The warning that occurs first indicates that PTE that was obtained for
> some vmalloc mapping is not unused (0) as it is expected. So it feels rather
> like some cleanup has *not* been done.
> 
> Let me think aloud a bit... What seems to cause this, is the change of the
> kernel/module split from 512M:1.5G to 1G:1G (not exactly since there is 8M
> vsyscalls and 2M hole at the end). Which in vaddr terms means:
> 
> Before:
> ffffffff80000000 - ffffffff9fffffff (=512 MB)  kernel text mapping, from phys 0
> ffffffffa0000000 - ffffffffff5fffff (=1526 MB) module mapping space
> 
> After:
> ffffffff80000000 - ffffffffbfffffff (=1024 MB) kernel text mapping, from phys 0
> ffffffffc0000000 - ffffffffff5fffff (=1014 MB) module mapping space
> 
> Now, *if* I got this right, this means the kernel starts on a vaddr that is
> pointed at by:
> 
> PGD[510]->PUD[510]->PMD[0]->PTE[0]
> 
> In the old layout the module vaddr area would start in the same PUD area, but
> with the change the kernel would cover PUD[510] and the module vaddr + vsyscalls
> and the hole would cover PUD[511].

I think there is a fixmap there too?
> 
> xen_cleanhighmap operates only on the kernel_level2_pgt which (speculating a bit
> since I am not sure I understand enough details) I believe is the one PMD
> pointed at by PGD[510]->PUD[510]. That could mean that before the change

That sounds right.

I don't know if you saw:

1248 #ifdef DEBUG                                                                    
1249         /* This is superflous and is not neccessary, but you know what          
1250          * lets do it. The MODULES_VADDR -> MODULES_END should be clear of      
1251          * anything at this stage. */                                           
1252         xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);  
1253 #endif                                                                          
1254 }                                    

Which was me being a bit paranoid and figured it might help in troubleshooting.
If you disable that does it work?

> xen_cleanhighmap may touch some (the initial 512M) of the module vaddr space but
> not after the change. Maybe that also means it always should have covered more
> but this would not be observed as long as modules would not claim more than
> 512M? I still need to check the vaddr ranges for which xen_cleanhighmap is
> actually called. The modules vaddr space would normally not be touched (only
> with DEBUG set). I moved that to be unconditionally done but then this might be
> of no use when it needs to cover a different PMD...

What does the toolstack say in regards to allocating the memory? It is pretty
verbose (domainloginfo..something) in printing out the vaddr of where
it stashes the kernel, ramdisk, P2M, and the pagetables (which of course
need to fit all within the 512MB, now 1GB area).

> 
> Really not sure here. But maybe a starter for others...
> 
> -Stefan
> 
> > 
> > -Kees
> > 
> > 
> >>>
> >>> -Kees
> >>>
> >>> --
> >>> Kees Cook
> >>> Chrome OS Security
> >>>
> >>> _______________________________________________
> >>> Xen-devel mailing list
> >>> Xen-devel@lists.xen.org
> >>> http://lists.xen.org/xen-devel
> > 
> > 
> > 
> 
> 


