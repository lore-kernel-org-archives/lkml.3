Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3EYMw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:52:27 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52225 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3EYMwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:52:24 -0400
Date: Sat, 25 May 2013 14:52:17 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130525145217.0549138a@holzheu>
In-Reply-To: <51A076FE.3060604@gmail.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130524143644.GD18218@redhat.com>
	<20130524170626.2ac06efe@holzheu>
	<20130524152849.GF18218@redhat.com>
	<87mwrkatgu.fsf@xmission.com>
	<51A006CF.90105@gmail.com>
	<87k3mnahkf.fsf@xmission.com>
	<51A076FE.3060604@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052512-0342-0000-0000-00000521EBE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 May 2013 16:31:58 +0800
Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

[snip]

> For s390, if we put swap info into the elf header, This will
> change /sbin/kexec. But at this point, copy_oldmem_page is still
> doing the swap when we try to read the pages among [0 - OLDMEM_SIZE]
> and [OLDMEM_BASE - OLDMEM_BASE + OLDMEM_SIZE]. So removing the swap
> in copy_oldmem_page should be done at the same time. New kexec with
> old kernels would fail and old kexec with new kernels would fail too.
> 
> So could you please explain more about the ""backwards compatible".
> And please correct me if I am wrong.

Hello all,

I think Zhang is right and in theory we are not backwards compatible
because with the ELF header fix old kexec tools would no longer work
with new kernels.

But:

For s390 we normally do *not* create the ELF header in the old
kernel with kexec. Instead the new kernel does all the memory and CPU
detection and creates the ELF header in the new memory.

See also our current discussion with Vivek:
https://lkml.org/lkml/2013/5/24/164

The main reason why we did this for s390 was that we can have many
CPU hotplug events because of a s390 specific daemon called
"cpuplugd" (s390-tools). We wanted to avoid the kdump reloading with
kexec triggered by CPU and memory hotplug events. For s390 distributions
the kexec udev rules are disabled.

Besides of the newmem mechanism, for completeness, we also implemented
the oldmem ELF header mechansim in kexec. But this is disabled
by default.

See: "#ifdef WITH_ELF_HEADER" in kexec/arch/s390/crashdump-s390.c

Currently no distribution uses the oldmem mechanism.

Therefore, if necessary, IMHO we can switch to the ELF header memory
swap mechanism for s390 in the kernel. Of course we would then also
have to adjust the (disabled) kexec code.

Best Regards,
Michael

