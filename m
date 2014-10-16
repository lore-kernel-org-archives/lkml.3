Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaJPHXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:23:51 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48149 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaJPHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:23:47 -0400
Date: Thu, 16 Oct 2014 09:23:38 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v1 07/10] vmcore: Remove "weak" from function
 declarations
Message-ID: <20141016092338.2d3bc32b@mschwide>
In-Reply-To: <CAErSpo5f_HgiyKS3Ho1DHbdvBo200RSFokEw3wmQ7k-1FuNzkw@mail.gmail.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<20141015170631.4063.50854.stgit@bhelgaas-glaptop2.roam.corp.google.com>
	<CAErSpo7zzofNsoGHuzfgfSEODyfkRs2FmyU-r3GjGDnNUF_0gw@mail.gmail.com>
	<CAErSpo5f_HgiyKS3Ho1DHbdvBo200RSFokEw3wmQ7k-1FuNzkw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101607-0025-0000-0000-000001E86A3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014 17:44:29 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> [+cc Martin, Heiko, linux-s390, since s390 could see issues from this.
> Sorry for all the spam; I should have gotten this right the first
> time.]
> 
> On Wed, Oct 15, 2014 at 5:31 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > [+cc Michael, Vivek; sorry, I botched my "stg mail" so you weren't
> > included the first time]
> >
> > On Wed, Oct 15, 2014 at 11:06 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> For the following functions:
> >>
> >>   elfcorehdr_alloc()
> >>   elfcorehdr_free()
> >>   elfcorehdr_read()
> >>   elfcorehdr_read_notes()
> >>   remap_oldmem_pfn_range()
> >>
> >> fs/proc/vmcore.c provides default definitions explicitly marked "weak".
> >> arch/s390 provides its own definitions intended to override the default
> >> ones, but the "weak" attribute on the declarations applied to the s390
> >> definitions as well, so the linker chose one based on link order (see
> >> 10629d711ed7 ("PCI: Remove __weak annotation from pcibios_get_phb_of_node
> >> decl")).
> >>
> >> Remove the "weak" attribute from the declarations so we always prefer a
> >> non-weak definition over the weak one, independent of link order.
> >>
> >> Fixes: be8a8d069e50 ("vmcore: introduce ELF header in new memory feature")
> >> Fixes: 9cb218131de1 ("vmcore: introduce remap_oldmem_pfn_range()")
> >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> >> CC: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> >> CC: Vivek Goyal <vgoyal@redhat.com>
> >> ---
> >>  include/linux/crash_dump.h |   15 +++++++--------
> >>  1 file changed, 7 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
> >> index 72ab536ad3de..3849fce7ecfe 100644
> >> --- a/include/linux/crash_dump.h
> >> +++ b/include/linux/crash_dump.h
> >> @@ -14,14 +14,13 @@
> >>  extern unsigned long long elfcorehdr_addr;
> >>  extern unsigned long long elfcorehdr_size;
> >>
> >> -extern int __weak elfcorehdr_alloc(unsigned long long *addr,
> >> -                                  unsigned long long *size);
> >> -extern void __weak elfcorehdr_free(unsigned long long addr);
> >> -extern ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos);
> >> -extern ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
> >> -extern int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
> >> -                                        unsigned long from, unsigned long pfn,
> >> -                                        unsigned long size, pgprot_t prot);
> >> +extern int elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size);
> >> +extern void elfcorehdr_free(unsigned long long addr);
> >> +extern ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos);
> >> +extern ssize_t elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos);
> >> +extern int remap_oldmem_pfn_range(struct vm_area_struct *vma,
> >> +                                 unsigned long from, unsigned long pfn,
> >> +                                 unsigned long size, pgprot_t prot);
> >>
> >>  extern ssize_t copy_oldmem_page(unsigned long, char *, size_t,
> >>                                                 unsigned long, int);
> >>
 
These __weak attributes can be removed as well without ill effect for s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

