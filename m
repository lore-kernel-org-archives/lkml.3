Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaIKWPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:15:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaIKWPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:15:41 -0400
Date: Fri, 12 Sep 2014 00:15:37 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Put each per-cpu kdump ELF notes into a single page
Message-ID: <20140912001537.5f877fe7@hananiah.suse.cz>
In-Reply-To: <20140911211637.GF17140@redhat.com>
References: <20140905183314.23690175@hananiah.suse.cz>
	<20140911200110.GA24699@redhat.com>
	<20140911224330.0cec9b4c@hananiah.suse.cz>
	<20140911211637.GF17140@redhat.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 17:16:37 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Sep 11, 2014 at 10:43:30PM +0200, Petr Tesarik wrote:
> > On Thu, 11 Sep 2014 16:01:10 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Fri, Sep 05, 2014 at 06:33:14PM +0200, Petr Tesarik wrote:
> > > > On architectures that use percpu-vm, the percpu region is not guaranteed
> > > > to be contiguous in physical space.
> > > 
> > > Petr,
> > > 
> > > Which are those arches?
> > 
> > All except nommu. Actually, percpu-km will be used instead even on MMU
> > if SMP is disabled, but since SMP is pretty standard now, I guess the
> > vast majority of all kernels out there is affected. ;-)
> 
> Hi Petr,
> 
> To make sure I understand it correctly I will just summarize what you
> said.
> 
> alloc_percpu() code does not guarantee that an object will be on physically
> contiguous pages if object crosses page boundary. That's why we are forcing
> allocation of object aligned to nearest higher power of two boundary of
> object size and that way object will always be on same page (as long as object
> is not bigger than a page).
> 
> Is that a fair summary?

Yes. I might add a note why physically contiguous memory is needed
here, but maybe it's obvious to anyone dealing with kdump.

Thanks,
Petr Tesarik

> Thanks
> Vivek
>  
> > 
> > > > However, fs/proc/vmcore.c expects
> > > > all ELF notes to be contiguous. If the ELF note happens to occupy
> > > > two non-adjacent physical pages, part of the note may be read from an
> > > > incorrect memory location by the kdump kernel, resulting in failure to
> > > > initialize /proc/vmcore (if the content of the following physical page,
> > > > incorrectly interpreted as an ELF note specifies a large number), wrong
> > > > register values or other apparent random memory corruption.
> > > > 
> > > > There is currently no mechanism to pass the virtual-to-physical mapping
> > > > of the percpu allocation to the kdump kernel. So, instead, I'm changing
> > > > the alignment of the ELF note buffer. Since sizeof(note_buf_t) is less
> > > > than PAGE_SIZE, aligning the buffer to the nearest higher power of 2
> > > > is enough to make sure that the buffer cannot cross a page boundary,
> > > > effectively ensuring that the whole buffer is contiguous in physical
> > > > space.
> > > > 
> > > > Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> > > > ---
> > > >  kernel/kexec.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > > > index 2bee072..cdab59d 100644
> > > > --- a/kernel/kexec.c
> > > > +++ b/kernel/kexec.c
> > > > @@ -1610,7 +1610,8 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
> > > >  static int __init crash_notes_memory_init(void)
> > > >  {
> > > >  	/* Allocate memory for saving cpu registers. */
> > > > -	crash_notes = alloc_percpu(note_buf_t);
> > > > +	crash_notes = __alloc_percpu(sizeof(note_buf_t),
> > > > +				     roundup_pow_of_two(sizeof(note_buf_t)));
> > > 
> > > I think some of the changelog should show up here as comment in short
> > > form. I don't think it is obvious that why we are using __alloc_percpu()
> > > and why aligning to nearst higher power of 2 is needed here. Please also
> > > mention here which arches run into issues.
> > 
> > OK, I'll add it as a comment in the code. I'll see if I can make it
> > short but still understandable.
> > 
> > Thanks,
> > Petr Tesarik
> > 
> > > Thanks
> > > Vivek
> > > 
> > > >  	if (!crash_notes) {
> > > >  		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
> > > >  		return -ENOMEM;
> > > > -- 
> > > > 1.8.4.5
> > > > 
> > > > _______________________________________________
> > > > kexec mailing list
> > > > kexec@lists.infradead.org
> > > > http://lists.infradead.org/mailman/listinfo/kexec
> > > 
> > > _______________________________________________
> > > kexec mailing list
> > > kexec@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/kexec
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec

