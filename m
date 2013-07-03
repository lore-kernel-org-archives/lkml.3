Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab3GCOjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:39:52 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46670 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029Ab3GCOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:39:50 -0400
Date: Wed, 3 Jul 2013 16:39:44 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 2/5] s390/vmcore: Use ELF header in new memory
 feature
Message-ID: <20130703163944.70319e0a@holzheu>
In-Reply-To: <20130703141529.GB1460@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1372707159-10425-3-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130702162322.GD22603@redhat.com>
	<20130703095913.6f6d145d@holzheu>
	<20130703141529.GB1460@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070314-8372-0000-0000-0000067B95A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jul 2013 10:15:29 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Jul 03, 2013 at 09:59:13AM +0200, Michael Holzheu wrote:
> > On Tue, 2 Jul 2013 12:23:23 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Mon, Jul 01, 2013 at 09:32:36PM +0200, Michael Holzheu wrote:
> > > 
> > > [..]
> > > > +ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
> > > > +{
> > > > +	void *src = (void *)(unsigned long)*ppos;
> > > > +
> > > > +	src = elfcorehdr_newmem ? src : src - OLDMEM_BASE;
> > > 
> > > Seriously, we need to get rid of all this OLDMEM_BASE logic in s390
> > > specific code. For regular kdump, it is no different than x86. Only
> > > special handling required for zfcpdump for HSA region.
> > > 
> > > Why do we need above. Is it to cover the case where elfcorehdr have
> > > been prepared by user space? Are elf headers initially stored in
> > > reserved region and then swapped. Why do we need to swap these or
> > > why kexec-tools could not take care of swapping it.
> > 
> > I know it is confusing. The "src - OLDMEM_BASE" term is currently
> > needed because of the swap issue that we have discussed already. We
> > load the ELF header into reserved memory
> > [OLDMEM_BASE, OLDMEM_BASE + OLDMEM_SIZE] that is swapped with
> > [0, OLDMEM_SIZE]. So the ELF header address has to be adjusted.
> 
> Can't kexec-tools could easily do this swapping and modify elfcorehdr=
> command line accordingly so that second kernel does not have to do
> swapping for ELF headers.
> 
> And for PT_LOAD segment swapping, we could use ELF header swapping trick
> (again in kexec-tools).
> 
> After above two changes I think all the OLD_MEMBASE magic will go away
> from s390 code and only HSA region special handling will remain.
> 
> This brings it inline with x86 code and it becomes easier to understand
> the s390 code. Otherwise there so may special corner cases that it is
> easy to get lost.

Right, I agree that it is possible to do the swap in the kexec tool.
Then we would load in the kexec tool the ELF header to address
"OLDMEM_BASE + addr" (or "crashkernel base + addr") and would specify
the kernel parameter as "elfcorehdr=addr".

Currently we specify "elfcorehdr=OLDMEM_BASE + addr" and the kernel
reverses the swap.

Michael

