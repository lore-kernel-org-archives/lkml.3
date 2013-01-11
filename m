Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3AKNhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:37:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21085 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AKNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:37:28 -0500
Date: Fri, 11 Jan 2013 14:36:51 +0100
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, hpa@zytor.com, konrad.wilk@oracle.com,
        andrew.cooper3@citrix.com, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xen.org>,
        mingo@redhat.com, ebiederm@xmission.com, maxim.uvarov@oracle.com,
        tglx@linutronix.de, virtualization@lists.linux-foundation.org,
        vgoyal@redhat.com
Subject: Re: [Xen-devel] [PATCH v3 02/11] x86/kexec: Add extra pointers to
 transition page table PGD, PUD, PMD and PTE
Message-ID: <20130111133651.GC5150@host-192-168-1-59.local.net-space.pl>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
 <1356574740-6806-3-git-send-email-daniel.kiper@oracle.com>
 <50E55ECF02000078000B2A13@nat28.tlf.novell.com>
 <20130104151542.GD3346@host-192-168-1-59.local.net-space.pl>
 <50EECB23.4090603@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EECB23.4090603@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 02:07:31PM +0000, David Vrabel wrote:
> On 04/01/13 15:15, Daniel Kiper wrote:
> > On Thu, Jan 03, 2013 at 09:34:55AM +0000, Jan Beulich wrote:
> >>>>> On 27.12.12 at 03:18, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> >>> Some implementations (e.g. Xen PVOPS) could not use part of identity page table
> >>> to construct transition page table. It means that they require separate PUDs,
> >>> PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
> >>> requirement add extra pointer to PGD, PUD, PMD and PTE and align existing
> >>> code.
> >>
> >> So you keep posting this despite it having got pointed out on each
> >> earlier submission that this is unnecessary, proven by the fact that
> >> the non-pvops Xen kernels can get away without it. Why?
> >
> > Sorry but I forgot to reply for your email last time.
> >
> > I am still not convinced. I have tested SUSE kernel itself and it does not work.
> > Maybe I missed something but... Please check arch/x86/kernel/machine_kexec_64.c:init_transition_pgtable()
> >
> > I can see:
> >
> > vaddr = (unsigned long)relocate_kernel;
> >
> > and later:
> >
> > pgd += pgd_index(vaddr);
> > ...
> >
> > It is wrong. relocate_kernel() virtual address in Xen is different
> > than its virtual address in Linux Kernel. That is why transition
> > page table could not be established in Linux Kernel and so on...
> > How does this work in SUSE? I do not have an idea.
>
> The real problem here is attempting to transition from the Xen page
> tables to an identity mapping set of page tables by using some
> trampoline code and page tables provided by the dom0 kernel.
>
> This works[*] with PV because the page tables from the PV dom0 have
> machine addresses and get mapped into the fixmap on kexec load, but it's
> completely broken for a PVH dom0.
>
> I shall be ditching this (bizarre) method and putting the trampoline and
> transition/identity map page tables into Xen.

Great... Maybe I am boring but please look into
linux/arch/x86/kernel/{machine_kexec_$(BITS).c,relocate_kernel_$(BITS).c}
You could find there a lot of things which could be useful.

> David
>
> [*] Works for us in our old classic kernels, YMMV.

Ha... It works because virtual mapping of control page in transtition page table
is established in relocate_kernel() which sits during kexec/kdump execution
in control page. If you did not change something...

Daniel
