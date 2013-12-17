Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3LQWum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:50:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab3LQWul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:50:41 -0500
Date: Tue, 17 Dec 2013 20:50:23 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
Message-ID: <20131217225023.GD31827@localhost.localdomain>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
 <1387315669.2797.21.camel@buesod1.americas.hpqcorp.net>
 <20131217214653.GC31827@localhost.localdomain>
 <1387318682.2797.25.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387318682.2797.25.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 02:18:02PM -0800, Davidlohr Bueso wrote:
> On Tue, 2013-12-17 at 19:46 -0200, Rafael Aquini wrote:
> > On Tue, Dec 17, 2013 at 01:27:49PM -0800, Davidlohr Bueso wrote:
> > > Ccing Manfred.
> > > 
> > > On Tue, 2013-12-17 at 17:03 -0200, Rafael Aquini wrote:
> > > > After the locking semantics for the SysV IPC API got improved, a couple of
> > > > IPC_RMID race windows were opened because we ended up dropping the
> > > > 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> > > > The spotted races got sorted out by re-introducing the old test within
> > > > the racy critical sections.
> > > > 
> > > > This patch introduces ipc_valid_object() to consolidate the way we cope with
> > > > IPC_RMID races by using the same abstraction across the API implementation.
> > > 
> > > This is certainly a good function to have. Some comments below.
> > > 
> [...]
> > > > 
> > > >  		shm_file = shp->shm_file;
> > > > -
> > > > -		/* check if shm_destroy() is tearing down shp */
> > > > -		if (shm_file == NULL) {
> > > > -			err = -EIDRM;
> > > > -			goto out_unlock0;
> > > > -		}
> > > 
> > > Ok, this seems safe, we can always rely on .deleted for validity since
> > > shm_destroy() ends up calling shm_rmid() which sets .deleted. So this
> > > change is really moving what we're checking against just a few
> > > instructions later.
> > >
> > 
> > Yep, I did change it cause it seems that there's no reason to delay the return
> > condition if we raced with shm_destroy(), anyways.
> >  
> 
> Right, but I was referring to moving what we consider as valid.
> 
> static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
> {
> 	struct file *shm_file;
> 
> 	shm_file = shp->shm_file;
> 	shp->shm_file = NULL;   <--- we currently use this.
> 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 	shm_rmid(ns, shp); <--- with your patch we now use this.
> 	shm_unlock(shp);
> 	...
> }
> 
> ... and it makes since since shm was the only one not using .deleted for
> RMID racing checks.
>

Oh, I see. As a matter of fact, what made shm to start using a different check
than kern_ipc_perm.deleted, as you points out, was the follwoing commit:
---8<--
commit a399b29dfbaaaf91162b2dc5a5875dd51bbfa2a1
Author: Greg Thelen <gthelen@google.com>
Date:   Thu Nov 21 14:32:00 2013 -0800

    ipc,shm: fix shm_file deletion races
--->8---

Although it closes the spotted race properly, Greg's commit also implies that (by the
way it works the race around) the race has always been there, which is not true. 
OTOH, I didn't propose reverting Greg's commit because I thought the changes 
it introduced to shm_destroy() might come handy to help one spotting similar races, 
if they eventually pop out in the future.
(a cleanup patch can be sent later, if that hunk is not regarded as useful anymore)

Thanks!
-- Rafael
