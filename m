Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab3GCOvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3GCOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:51:54 -0400
Date: Wed, 3 Jul 2013 10:50:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 2/5] s390/vmcore: Use ELF header in new memory feature
Message-ID: <20130703145020.GD1460@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <1372707159-10425-3-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130702162322.GD22603@redhat.com>
 <20130703095913.6f6d145d@holzheu>
 <20130703141529.GB1460@redhat.com>
 <20130703163944.70319e0a@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130703163944.70319e0a@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:39:44PM +0200, Michael Holzheu wrote:
> On Wed, 3 Jul 2013 10:15:29 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Wed, Jul 03, 2013 at 09:59:13AM +0200, Michael Holzheu wrote:
> > > On Tue, 2 Jul 2013 12:23:23 -0400
> > > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > 
> > > > On Mon, Jul 01, 2013 at 09:32:36PM +0200, Michael Holzheu wrote:
> > > > 
> > > > [..]
> > > > > +ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
> > > > > +{
> > > > > +	void *src = (void *)(unsigned long)*ppos;
> > > > > +
> > > > > +	src = elfcorehdr_newmem ? src : src - OLDMEM_BASE;
> > > > 
> > > > Seriously, we need to get rid of all this OLDMEM_BASE logic in s390
> > > > specific code. For regular kdump, it is no different than x86. Only
> > > > special handling required for zfcpdump for HSA region.
> > > > 
> > > > Why do we need above. Is it to cover the case where elfcorehdr have
> > > > been prepared by user space? Are elf headers initially stored in
> > > > reserved region and then swapped. Why do we need to swap these or
> > > > why kexec-tools could not take care of swapping it.
> > > 
> > > I know it is confusing. The "src - OLDMEM_BASE" term is currently
> > > needed because of the swap issue that we have discussed already. We
> > > load the ELF header into reserved memory
> > > [OLDMEM_BASE, OLDMEM_BASE + OLDMEM_SIZE] that is swapped with
> > > [0, OLDMEM_SIZE]. So the ELF header address has to be adjusted.
> > 
> > Can't kexec-tools could easily do this swapping and modify elfcorehdr=
> > command line accordingly so that second kernel does not have to do
> > swapping for ELF headers.
> > 
> > And for PT_LOAD segment swapping, we could use ELF header swapping trick
> > (again in kexec-tools).
> > 
> > After above two changes I think all the OLD_MEMBASE magic will go away
> > from s390 code and only HSA region special handling will remain.
> > 
> > This brings it inline with x86 code and it becomes easier to understand
> > the s390 code. Otherwise there so may special corner cases that it is
> > easy to get lost.
> 
> Right, I agree that it is possible to do the swap in the kexec tool.
> Then we would load in the kexec tool the ELF header to address
> "OLDMEM_BASE + addr" (or "crashkernel base + addr") and would specify
> the kernel parameter as "elfcorehdr=addr".

Exactly. purgatory does swap and kexec-tools prepares the purgatory and 
it knows that swap will take place so it can pass elfcorehdr=addr,
instead of elfcorehdr=OLDMEM_BASE.

Hardcoding this knowledge in second kernel is not a very good idea.

Thanks
Vivek
