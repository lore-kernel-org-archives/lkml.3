Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab3LQWSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:18:12 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28380 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3LQWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:18:11 -0500
Message-ID: <1387318682.2797.25.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
From: Davidlohr Bueso <davidlohr@hp.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Date: Tue, 17 Dec 2013 14:18:02 -0800
In-Reply-To: <20131217214653.GC31827@localhost.localdomain>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
	 <1387315669.2797.21.camel@buesod1.americas.hpqcorp.net>
	 <20131217214653.GC31827@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 19:46 -0200, Rafael Aquini wrote:
> On Tue, Dec 17, 2013 at 01:27:49PM -0800, Davidlohr Bueso wrote:
> > Ccing Manfred.
> > 
> > On Tue, 2013-12-17 at 17:03 -0200, Rafael Aquini wrote:
> > > After the locking semantics for the SysV IPC API got improved, a couple of
> > > IPC_RMID race windows were opened because we ended up dropping the
> > > 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> > > The spotted races got sorted out by re-introducing the old test within
> > > the racy critical sections.
> > > 
> > > This patch introduces ipc_valid_object() to consolidate the way we cope with
> > > IPC_RMID races by using the same abstraction across the API implementation.
> > 
> > This is certainly a good function to have. Some comments below.
> > 
[...]
> > > 
> > >  		shm_file = shp->shm_file;
> > > -
> > > -		/* check if shm_destroy() is tearing down shp */
> > > -		if (shm_file == NULL) {
> > > -			err = -EIDRM;
> > > -			goto out_unlock0;
> > > -		}
> > 
> > Ok, this seems safe, we can always rely on .deleted for validity since
> > shm_destroy() ends up calling shm_rmid() which sets .deleted. So this
> > change is really moving what we're checking against just a few
> > instructions later.
> >
> 
> Yep, I did change it cause it seems that there's no reason to delay the return
> condition if we raced with shm_destroy(), anyways.
>  

Right, but I was referring to moving what we consider as valid.

static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
{
	struct file *shm_file;

	shm_file = shp->shm_file;
	shp->shm_file = NULL;   <--- we currently use this.
	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
	shm_rmid(ns, shp); <--- with your patch we now use this.
	shm_unlock(shp);
	...
}

... and it makes since since shm was the only one not using .deleted for
RMID racing checks.

Thanks,
Davidlohr

