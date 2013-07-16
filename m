Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab3GPRYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:24:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059Ab3GPRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:24:50 -0400
Date: Tue, 16 Jul 2013 13:24:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130716172421.GA7982@redhat.com>
References: <1373991495-47411-1-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373991495-47411-1-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 06:18:10PM +0200, Michael Holzheu wrote:
> Hello Andrew,
> 
> Here a new kdump patch series that we have discussed with Vivek and
> Hatayama during the last months.
> 
> Besides of the feature described below, this patch series also fixes a
> regression on s390 that was introduced with the mmap patches for
> /proc/vmcore (git commit 83086978c63afd7c73e1c).
> 
> See also:
> http://lists.infradead.org/pipermail/kexec/2013-July/009287.html
> 
> Is it somehow possible to integrate this patch series into 3.11?

Hi Andrew,

Now /proc/vmcore mmap() patches are in but looks like they will break
s390 kdump. mmap() patches use vmalloc() to allocate memory for elf
notes and then use read_from_oldmem() to copy notes data from old
memory to this newly allocated buffer. read_from_oldmem() in turn
uses arch dependent copy_from_oldmem() function.

Look like on s390, copy_from_oldmem() can not copy data to vmalloc()
space as they drop to real mode.

As allocating elf notes code is common both for mmap() and read() path,
it will break kdump on s390.

Michael has done some cleanups to cope with that but in the process
he has also stuffed in the support for zfcpdump and how to deal with
HSA region etc. (I am not very happy about it though now. s390 seems
to be having so may special case modes and swap logic etc that it
is becoming hard to keep track what they are doing. I wished s390
first did some cleanup w.r.t swap logic and deal with mmap() in pure
kdump mode and then worry about taking care of zfcpdump).

Is it possible to push this series in 3.11 now? I suspect it is late now.
Otherwise we might have to revert mmap() patches as in current form
they will break s390 kdump.

Michael, Hatayama, in case this series can't go in 3.11, do you have other
ideas where a small hack fix will allow kdump to work on s390 and we
don't have to revert the mmap() patches.

Thanks
Vivek
