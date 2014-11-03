Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaKCVaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:30:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:55620 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaKCV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:29:59 -0500
Date: Mon, 3 Nov 2014 22:29:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Ren Qiaowei <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linux-MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v9 11/12] x86, mpx: cleanup unused bound tables
In-Reply-To: <5457EB67.70904@intel.com>
Message-ID: <alpine.DEB.2.11.1411032205320.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-12-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241451280.5308@nanos> <544DB873.1010207@intel.com> <alpine.DEB.2.11.1410272138540.5308@nanos>
 <5457EB67.70904@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Dave Hansen wrote:
> On 10/27/2014 01:49 PM, Thomas Gleixner wrote:
> > Errm. Before user space can use the bounds table for the new mapping
> > it needs to add the entries, right? So:
> > 
> > CPU 0					CPU 1
> > 
> > down_write(mm->bd_sem);
> > mpx_pre_unmap();
> >    clear bounds directory entries	
> > unmap();
> > 					map()
> > 					write_bounds_entry()
> > 					trap()
> > 					  down_read(mm->bd_sem);
> > mpx_post_unmap(); 
> > up_write(mm->bd_sem);
> > 					  allocate_bounds_table();
> > 
> > That's the whole point of bd_sem.
> 
> This does, indeed, seem to work for the normal munmap() cases.  However,
> take a look at shmdt().  We don't know the size of the segment being
> unmapped until after we acquire mmap_sem for write, so we wouldn't be
> able to do do a mpx_pre_unmap() for those.

That's not really true. You can evaluate that information with
mmap_sem held for read as well. Nothing can change the mappings until
you drop it. So you could do:

   down_write(mm->bd_sem);
   down_read(mm->mmap_sem;
   evaluate_size_of_shm_to_unmap();
   clear_bounds_directory_entries();
   up_read(mm->mmap_sem);
   do_the_real_shm_unmap();
   up_write(mm->bd_sem);

That should still be covered by the above scheme.
 
> mremap() is similar.  We don't know if the area got expanded (and we
> don't need to modify bounds tables) or moved (and we need to free the
> old location's tables) until well after we've taken mmap_sem for write.

See above.
 
> I propose we keep mm->bd_sem.  But, I think we need to keep a list
> during each of the unmapping operations of VMAs that got unmapped, and
> then keep them on a list without freeing then.  At up_write() time, we
> look at the list, if it is empty, we just do an up_write() and we are done.
> 
> If *not* empty, downgrade_write(mm->mmap_sem), and do the work you
> spelled out in mpx_pre_unmap() above: clear the bounds directory entries
> and gather the VMAs while still holding mm->bd_sem for write.
> 
> Here's the other wrinkle: This would invert the ->bd_sem vs. ->mmap_sem
> ordering (bd_sem nests outside mmap_sem with the above scheme).  We
> _could_ always acquire bd_sem for write whenever mmap_sem is acquired,
> although that seems a bit heavyweight.  I can't think of anything better
> at the moment, though.

That works as well. If it makes stuff simpler I'm all for it. But then
we should really replace down_write(mmap_sem) with a helper function
and add something to checkpatch.pl and to the coccinelle scripts to
catch new instances of open coded 'down_write(mmap_sem)'.

Thanks,

	tglx

