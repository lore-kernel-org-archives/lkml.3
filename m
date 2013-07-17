Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab3GQQBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:01:01 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44558 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3GQQA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:00:57 -0400
Date: Wed, 17 Jul 2013 18:00:49 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130717180049.3b9c6ec8@holzheu>
In-Reply-To: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071715-8372-0000-0000-0000069B083B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 16, 2013 at 06:18:10PM +0200, Michael Holzheu wrote:
> > Hello Andrew,
> >
> > Here a new kdump patch series that we have discussed with Vivek and
> > Hatayama during the last months.
> >
> > Besides of the feature described below, this patch series also fixes a
> > regression on s390 that was introduced with the mmap patches for
> > /proc/vmcore (git commit 83086978c63afd7c73e1c).
> >
> > See also:
> > http://lists.infradead.org/pipermail/kexec/2013-July/009287.html
> >
> > Is it somehow possible to integrate this patch series into 3.11?
> 
> Hi Andrew,
> 
> Now /proc/vmcore mmap() patches are in but looks like they will break
> s390 kdump. mmap() patches use vmalloc() to allocate memory for elf
> notes and then use read_from_oldmem() to copy notes data from old
> memory to this newly allocated buffer. read_from_oldmem() in turn
> uses arch dependent copy_from_oldmem() function.
> 
> Look like on s390, copy_from_oldmem() can not copy data to vmalloc()
> space as they drop to real mode.
> 
> As allocating elf notes code is common both for mmap() and read() path,
> it will break kdump on s390.
> 
> Michael has done some cleanups to cope with that but in the process
> he has also stuffed in the support for zfcpdump and how to deal with
> HSA region etc. (I am not very happy about it though now. s390 seems
> to be having so may special case modes and swap logic etc that it
> is becoming hard to keep track what they are doing. I wished s390
> first did some cleanup w.r.t swap logic and deal with mmap() in pure
> kdump mode and then worry about taking care of zfcpdump).
> 
> Is it possible to push this series in 3.11 now? I suspect it is late now.
> Otherwise we might have to revert mmap() patches as in current form
> they will break s390 kdump.
> 
> Michael, Hatayama, in case this series can't go in 3.11, do you have other
> ideas where a small hack fix will allow kdump to work on s390 and we
> don't have to revert the mmap() patches.

Sure, we can somehow change the copy_from_oldmem() function that it
can copy to virtual memory. We have already discussed some options
on how to do that. Not nice but probably doable.

And we could either disable mmap for s390 by removing mmap_vmcore()
from the proc_vmcore_operations or push the also already discussed
ELF header swap trick in 3.11.

But this is all additional effort now and would not be necessary if we
integrate this patch series in 3.11.

Perhaps we should let Andrew decide here.

Michael

