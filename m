Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaJ0UtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:49:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40601 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaJ0UtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:49:13 -0400
Date: Mon, 27 Oct 2014 21:49:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ren Qiaowei <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH v9 11/12] x86, mpx: cleanup unused bound tables
In-Reply-To: <544DB873.1010207@intel.com>
Message-ID: <alpine.DEB.2.11.1410272138540.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-12-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241451280.5308@nanos> <544DB873.1010207@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Ren Qiaowei wrote:
> If so, I guess that there are some questions needed to be considered:
> 
> 1) Almost all palces which call do_munmap() will need to add
> mpx_pre_unmap/post_unmap calls, like vm_munmap(), mremap(), shmdt(), etc..

What's the problem with that?
 
> 2) before mpx_post_unmap() call, it is possible for those bounds tables within
> mm->bd_remove_vmas to be re-used.
>
> In this case, userspace may do new mapping and access one address which will
> cover one of those bounds tables. During this period, HW will check if one
> bounds table exist, if yes one fault won't be produced.

Errm. Before user space can use the bounds table for the new mapping
it needs to add the entries, right? So:

CPU 0					CPU 1

down_write(mm->bd_sem);
mpx_pre_unmap();
   clear bounds directory entries	
unmap();
					map()
					write_bounds_entry()
					trap()
					  down_read(mm->bd_sem);
mpx_post_unmap(); 
up_write(mm->bd_sem);
					  allocate_bounds_table();

That's the whole point of bd_sem.

> 3) According to Dave, those bounds tables related to adjacent VMAs within the
> start and the end possibly don't have to be fully unmmaped, and we only need
> free the part of backing physical memory.

Care to explain why that's a problem?
 
Thanks,

	tglx
