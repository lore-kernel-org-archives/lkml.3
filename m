Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935856Ab3DKCm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:42:26 -0400
Received: from relay2.sgi.com ([192.48.179.30]:51753 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934841Ab3DKCmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:42:25 -0400
Date: Wed, 10 Apr 2013 21:42:23 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH] Sys V shared memory limited to 8TiB.
Message-ID: <20130411024223.GM3658@sgi.com>
References: <20130410023924.GX3658@sgi.com>
 <20130410161507.b12128ee3df446eb9b86d8cf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410161507.b12128ee3df446eb9b86d8cf@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:15:07PM -0700, Andrew Morton wrote:
> On Tue, 9 Apr 2013 21:39:24 -0500 Robin Holt <holt@sgi.com> wrote:
> 
> > Trying to run an application which was trying to put data into half
> > of memory using shmget(), we found that having a shmall value below
> > 8EiB-8TiB would prevent us from using anything more than 8TiB.  By setting
> > kernel.shmall greater that 8EiB-8TiB would make the job work.
> > 
> > In the newseg() function, ns->shm_tot which, at 8TiB is INT_MAX.
> 
> You have way too much memory.
> 
> > ipc/shm.c:
> >  458 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
> >  459 {
> > ...
> >  465         int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
> > ...
> >  474         if (ns->shm_tot + numpages > ns->shm_ctlall)
> >  475                 return -ENOSPC;
> >
> > ...
> >
> > --- a/include/linux/ipc_namespace.h
> > +++ b/include/linux/ipc_namespace.h
> > @@ -43,8 +43,8 @@ struct ipc_namespace {
> >  
> >  	size_t		shm_ctlmax;
> >  	size_t		shm_ctlall;
> > +	unsigned long	shm_tot;
> >  	int		shm_ctlmni;
> > -	int		shm_tot;
> >  	/*
> >  	 * Defines whether IPC_RMID is forced for _all_ shm segments regardless
> >  	 * of shmctl()
> 
> I reviewed everything for fallout from this and don't see any obvious
> issues.
> 
> I do wonder about the appropriateness of the unsigned long type.  Most
> (but by no means all) code in this area uses size_t, and the
> above-quoted ns->shm_ctlall is size_t.

The only reason I went with unsigned long instead of size_t was most
places in the kernel track stuff I recalled that was tracking stuff
in pages used unsigned longs.  Also, I found shm_tot field in shm_info
structure was an unsigned long so this felt like a natural fit.  I would
happily changed to size_t.  Whatever you feel is right.

> And the above-quoted num_pages is `int'.  Both the size and signedness
> of `int' make no sense - what happens if the incoming ipc_params.u.size
> is >2G?
> 
> So I'll add this, and ask whether ipc_namespace.shm_tot should be size_t?
> 
> --- a/ipc/shm.c~ipc-sysv-shared-memory-limited-to-8tib-fix
> +++ a/ipc/shm.c
> @@ -462,7 +462,7 @@ static int newseg(struct ipc_namespace *
>  	size_t size = params->u.size;
>  	int error;
>  	struct shmid_kernel *shp;
> -	int numpages = (size + PAGE_SIZE -1) >> PAGE_SHIFT;
> +	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;

I was holding off from that change only because I was asking for this
to go to stable and this doubles the size of the patch. ;)

>  	struct file * file;
>  	char name[13];
>  	int id;
> _

Thank you,
Robin
