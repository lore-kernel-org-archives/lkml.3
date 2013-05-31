Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3EaOVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:21:43 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:58762 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3EaOVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:21:35 -0400
Date: Fri, 31 May 2013 16:21:27 +0200
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
Message-ID: <20130531162127.6d512233@holzheu>
In-Reply-To: <20130530203847.GB5968@redhat.com>
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
	<20130530203847.GB5968@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053114-6892-0000-0000-0000054D93C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 16:38:47 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, May 29, 2013 at 01:51:44PM +0200, Michael Holzheu wrote:
> 
> [..]
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
> 
> Hi Michael,
> 
> Few more questions.
> 
> - What's the difference between zfcpdump and kdump. I thought zfcpdump
>   just boots specific kernel from fixed drive? If yes, why can't that
>   kernel prepare headers in similar way as regular kdump kernel does
>   and gain from kdump kernel swap trick?

Correct, the zfcpdump kernel is booted from a fixed disk drive. The
difference is that the zfcpdump HSA memory is not mapped into real
memory. It is accessed using a read memory interface "memcpy_hsa()"
that copies memory from the hypervisor owned HSA memory into the Linux
memory.

So it looks like the following:

+----------+                 +------------+
|          |   memcpy_hsa()  |            |
| zfcpdump | <-------------- | HSA memory |
|          |                 |            |
+----------+                 +------------+
|          |
| old mem  |
|          |
+----------+

In the copy_oldmem_page() function for zfcpdump we do the following:

copy_oldmem_page_zfcpdump(...)
{
	if (src < ZFCPDUMP_HSA_SIZE) {
		if (memcpy_hsa(buf, src, csize, userbuf) < 0)
			return -EINVAL;
	} else {
		if (userbuf)
			copy_to_user_real((buf, src, csize);
		else
			memcpy_real(buf, src, csize);
	}
}

So I think for zfcpdump we only can use the read() interface
of /proc/vmcore. But this is sufficient for us since we also provide
the s390 specific zfcpdump user space that copies /proc/vmcore.

> Also, we are accessing the contents of elf headers using physical
> address. If that's the case, does it make a difference if data is
> in old kernel's memory or new kernel's memory. We will use the
> physical address and create a temporary mapping and it should not
> make a difference whether same physical page is already mapped in
> current kernel or not.
>
> Only restriction this places is that all ELF header needs to be
> contiguous. I see that s390 code already creates elf headers using
> kzalloc_panic(). So memory allocated should by physically contiguous.
> 
> So can't we just put __pa(elfcorebuf) in elfcorehdr_addr. And same
> is true for p_offset fields in PT_NOTE headers and everything should
> work fine?
> 
> Only problem we can face is that at some point of time kzalloc() might
> not be able to contiguous memory request. We can handle that once s390
> runs into those issues. You are anyway allocating memory using
> kzalloc().
> 
> And if this works for s390 kdump, it should work for zfcpdump too?

So your suggestion is that copy_oldmem_page() should also be used for
copying memory from the new kernel, correct?

For kdump on s390 I think this will work with the new "ELF header swap"
patch. With that patch access to [0, OLDMEM_SIZE] will uniquely identify
an address in the new kernel and access to [OLDMEM_BASE, OLDMEM_BASE +
OLDMEM_SIZE] will identify an address in the old kernel.

For zfcpdump currently we add a load from [0, HSA_SIZE] where p_offset
equals p_paddr. Therefore we can't distinguish in copy_oldmem_page() if
we read from oldmem (HSA) or newmem. The range [0, HSA_SIZE] is used
twice. As a workaroun we could use an artificial p_offset for the HSA
memory chunk that is not used by the 1st kernel physical memory. This
is not really beautiful, but probably doable.

When I tried to implement this for kdump, I noticed another problem
with the vmcore mmap patches. Our copy_oldmem_page() function uses
memcpy_real() to access the old 1st kernel memory. This function
switches to real mode and therefore does not require any page tables.
But as a side effect of that we can't copy to vmalloc memory. The mmap
patches use vmalloc memory for "notes_buf". So currently using our
copy_oldmem_page() fails here.

If copy_oldmem_page() now also must be able to copy to vmalloc memory,
we would have to add new code for that:

* oldmem -> newmem (real): Use direct memcpy_real()
* oldmem -> newmem (vmalloc): Use intermediate buffer with memcpy_real()
* newmem -> newmem: Use memcpy()

What do you think?

Best Regards,
Michael

