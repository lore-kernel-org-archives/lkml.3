Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab3E1Nzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759087Ab3E1Nzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:55:40 -0400
Date: Tue, 28 May 2013 09:55:01 -0400
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
Message-ID: <20130528135500.GC7088@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130524143644.GD18218@redhat.com>
 <20130524170626.2ac06efe@holzheu>
 <20130524152849.GF18218@redhat.com>
 <87mwrkatgu.fsf@xmission.com>
 <51A006CF.90105@gmail.com>
 <87k3mnahkf.fsf@xmission.com>
 <51A076FE.3060604@gmail.com>
 <20130525145217.0549138a@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130525145217.0549138a@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 02:52:17PM +0200, Michael Holzheu wrote:
> On Sat, 25 May 2013 16:31:58 +0800
> Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> 
> [snip]
> 
> > For s390, if we put swap info into the elf header, This will
> > change /sbin/kexec. But at this point, copy_oldmem_page is still
> > doing the swap when we try to read the pages among [0 - OLDMEM_SIZE]
> > and [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]. So removing the swap
> > in copy_oldmem_page should be done at the same time. New kexec with
> > old kernels would fail and old kexec with new kernels would fail too.
> > 
> > So could you please explain more about the ""backwards compatible".
> > And please correct me if I am wrong.
> 
> Hello all,
> 
> I think Zhang is right and in theory we are not backwards compatible
> because with the ELF header fix old kexec tools would no longer work
> with new kernels.
> 
> But:
> 
> For s390 we normally do *not* create the ELF header in the old
> kernel with kexec. Instead the new kernel does all the memory and CPU
> detection and creates the ELF header in the new memory.
> 
> See also our current discussion with Vivek:
> https://lkml.org/lkml/2013/5/24/164
> 
> The main reason why we did this for s390 was that we can have many
> CPU hotplug events because of a s390 specific daemon called
> "cpuplugd" (s390-tools). We wanted to avoid the kdump reloading with
> kexec triggered by CPU and memory hotplug events. For s390 distributions
> the kexec udev rules are disabled.
> 
> Besides of the newmem mechanism, for completeness, we also implemented
> the oldmem ELF header mechansim in kexec. But this is disabled
> by default.
> 
> See: "#ifdef WITH_ELF_HEADER" in kexec/arch/s390/crashdump-s390.c
> 
> Currently no distribution uses the oldmem mechanism.

Hi Michael,

Mechanism to read from newmem is not there yet (your patches are still
being reviewed) and you mentioned that no distribution is building
kexec-tools with WITH_ELF_HEADER on s390. So how things are currently
working for kdump on s390?

> 
> Therefore, if necessary, IMHO we can switch to the ELF header memory
> swap mechanism for s390 in the kernel. Of course we would then also
> have to adjust the (disabled) kexec code.

So are you saying that s390 is ready to switch to mechanism of creating
ELF headers in first kernel by kexec-tools and new kernel does not
have to preare ELF headers?

Thanks
Vivek
