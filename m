Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170Ab3EGQjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758776Ab3EGQjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:39:21 -0400
Date: Tue, 7 May 2013 12:37:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH 0/4] kdump: Allow ELF header creation in new kernel
Message-ID: <20130507163701.GA14403@redhat.com>
References: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 03:09:55PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> For s390 we want to use /proc/vmcore for our SCSI stand-alone
> dump (zfcpdump). We have support where the first HSA_SIZE bytes are
> saved into a hypervisor owned memory area (HSA) before the kdump
> kernel is booted. When the kdump kernel starts, it is restricted
> to use only HSA_SIZE bytes.
> 

Hi Michael,

Hatayama is changing /proc/vmcore interface to support mmap(). Can you
please rebase your changes on top of those patches.

http://thread.gmane.org/gmane.linux.kernel/1477622

Secondly, I think /proc/vmcore does not have to know whether elf
headers are in old memory or new memory. Given that s390 is taking
a deviation, so it now becomes an arch specific detail. Can't we
just create few arch specific helper functions to retrieve and free
elf headers.

- arch_get_crash_headers()
	- All arch except return elfcorehdr_add except s390.
- arch_read_crash_header_data()
	- All arch just call into read_from_oldmem() except s390. We
  	  can provide a generic implementation in /proc/vmcore.c so
	  all other arch can use that generic implementation.  Or
	  use symbol override trick.
- arch_free_crash_headers()
	- All arch do nothing except s390 which can reclaim the memory
 	  for elf headers prepared. Generic code has parsed/copied the
	  headers by now.

What do you think? Above 3 calls should solve the problem and allow
arch to handle elf headers differently. And generic implementation
still keeps common logic for processing headers.

Thanks
Vivek
