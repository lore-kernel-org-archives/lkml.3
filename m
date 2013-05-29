Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127Ab3E2RNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:13:09 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56653 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410Ab3E2RM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:12:58 -0400
Date: Wed, 29 May 2013 19:12:49 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130529191249.19a235be@holzheu>
In-Reply-To: <20130529162325.GD22146@redhat.com>
References: <20130524143644.GD18218@redhat.com>
	<20130524170626.2ac06efe@holzheu>
	<20130524152849.GF18218@redhat.com>
	<87mwrkatgu.fsf@xmission.com>
	<51A006CF.90105@gmail.com>
	<87k3mnahkf.fsf@xmission.com>
	<51A076FE.3060604@gmail.com>
	<20130525145217.0549138a@holzheu>
	<20130528135500.GC7088@redhat.com>
	<20130529135144.7f95c4c0@holzheu>
	<20130529162325.GD22146@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052917-0542-0000-0000-000005660AF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 12:23:26 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, May 29, 2013 at 01:51:44PM +0200, Michael Holzheu wrote:
> > On Tue, 28 May 2013 09:55:01 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Sat, May 25, 2013 at 02:52:17PM +0200, Michael Holzheu wrote:
> > 
> > [snip]
> > 
> > > > Besides of the newmem mechanism, for completeness, we also
> > > > implemented the oldmem ELF header mechansim in kexec. But this
> > > > is disabled by default.
> > > > 
> > > > See: "#ifdef WITH_ELF_HEADER" in
> > > > kexec/arch/s390/crashdump-s390.c
> > > > 
> > > > Currently no distribution uses the oldmem mechanism.
> > > 
> > > Hi Michael,
> > > 
> > > Mechanism to read from newmem is not there yet (your patches are
> > > still being reviewed) and you mentioned that no distribution is
> > > building kexec-tools with WITH_ELF_HEADER on s390. So how things
> > > are currently working for kdump on s390?
> > 
> > Hello Vivek,
> > 
> > On s390, if we do not get the ELF header from the 1st kernel with
> > "elfcorehdr=", we build the ELF header in the 2nd kernel. This is
> > currently the default because WITH_ELF_HEADER is not defined for
> > kexec tools.
> > 
> > >>> START QUOTE
> > 
> > [PATCH v3 1/3] kdump: Introduce ELF header in new memory feature
> > 
> > Currently for s390 we create the ELF core header in the 2nd kernel
> > with a small trick. We relocate the addresses in the ELF header in
> > a way that for the /proc/vmcore code it seems to be in the 1st
> > kernel (old) memory and the read_from_oldmem() returns the correct
> > data. This allows the /proc/vmcore code to use the ELF header in
> > the 2nd kernel.
> > 
> > >>> END QUOTE
> > 
> > For our current zfcpdump project (see "[PATCH 3/3]s390/kdump: Use
> > vmcore for zfcpdump") we could no longer use this trick. Therefore
> > we sent you the patches to get a clean interface for ELF header
> > creation in the 2nd kernel.
> > 
> > > > 
> > > > Therefore, if necessary, IMHO we can switch to the ELF header
> > > > memory swap mechanism for s390 in the kernel. Of course we
> > > > would then also have to adjust the (disabled) kexec code.
> > > 
> > > So are you saying that s390 is ready to switch to mechanism of
> > > creating ELF headers in first kernel by kexec-tools and new kernel
> > > does not have to preare ELF headers?
> > 
> > No, I meant that currently nobody is using the kexec tools ELF
> > header creation in the 1st kernel on s390. We create the ELF header
> > in the 2nd kernel (mainly because of our cpuplugd issue).
> > 
> > Therefore, I think, we can safely change the ELF header creation in
> > 2nd kernel to use your p_offset swap trick *and* we remove the swap
> > code in the copy_oldmem_page() implementation (same kernel).
> 
> Ok. Got it. So s390 can fix it in kernel without creating any backward
> compatibility issues (given the fact that nobody sees to be using
> kexec-tools to build headers).
> 
> So please go ahead and fix it and that should solve your mmap() issue
> too. Also please fix kexec-tools and that change will not be backward
> compatible. 

Ok, I will do this.

I think we should add this "swap in ELF header" patch to the "kdump:
Allow ELF header creation in new kernel" patch series (on top of the
mmap patch series). Because when I remove the swap code from
copy_oldmem_page(), the old trick to access the ELF header in the first
kernel memory will no longer work.

Is that ok for you?

Michael

