Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3E3Uj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab3E3UjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:39:21 -0400
Date: Thu, 30 May 2013 16:38:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130530203847.GB5968@redhat.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529135144.7f95c4c0@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 01:51:44PM +0200, Michael Holzheu wrote:

[..]
> >>> START QUOTE
> 
> [PATCH v3 1/3] kdump: Introduce ELF header in new memory feature
> 
> Currently for s390 we create the ELF core header in the 2nd kernel with
> a small trick. We relocate the addresses in the ELF header in a way
> that for the /proc/vmcore code it seems to be in the 1st kernel (old)
> memory and the read_from_oldmem() returns the correct data. This allows
> the /proc/vmcore code to use the ELF header in the 2nd kernel.
> 
> >>> END QUOTE
> 
> For our current zfcpdump project (see "[PATCH 3/3]s390/kdump: Use
> vmcore for zfcpdump") we could no longer use this trick. Therefore we
> sent you the patches to get a clean interface for ELF header creation
> in the 2nd kernel.

Hi Michael,

Few more questions.

- What's the difference between zfcpdump and kdump. I thought zfcpdump
  just boots specific kernel from fixed drive? If yes, why can't that
  kernel prepare headers in similar way as regular kdump kernel does
  and gain from kdump kernel swap trick?

Also, we are accessing the contents of elf headers using physical
address. If that's the case, does it make a difference if data is
in old kernel's memory or new kernel's memory. We will use the physical
address and create a temporary mapping and it should not make a difference
whether same physical page is already mapped in current kernel or not.

Only restriction this places is that all ELF header needs to be
contiguous. I see that s390 code already creates elf headers using
kzalloc_panic(). So memory allocated should by physically contiguous.

So can't we just put __pa(elfcorebuf) in elfcorehdr_addr. And same
is true for p_offset fields in PT_NOTE headers and everything should
work fine?

Only problem we can face is that at some point of time kzalloc() might
not be able to contiguous memory request. We can handle that once s390
runs into those issues. You are anyway allocating memory using kzalloc().

And if this works for s390 kdump, it should work for zfcpdump too?

Thanks
Vivek
