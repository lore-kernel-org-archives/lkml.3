Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3LSAme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:42:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab3LSAmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:42:33 -0500
Date: Wed, 18 Dec 2013 22:42:23 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH v3] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
Message-ID: <20131219004222.GC16621@localhost.localdomain>
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com>
 <1fb23e4caf59656e428b27dcc0885ea4be9b76d9.1387398458.git.aquini@redhat.com>
 <1387413504.2797.36.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387413504.2797.36.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:38:24PM -0800, Davidlohr Bueso wrote:
> On Wed, 2013-12-18 at 18:33 -0200, Rafael Aquini wrote:
> > After the locking semantics for the SysV IPC API got improved, a couple of
> > IPC_RMID race windows were opened because we ended up dropping the
> > 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> > The spotted races got sorted out by re-introducing the old test within
> > the racy critical sections.
> > 
> > This patch introduces ipc_valid_object() to consolidate the way we cope with
> > IPC_RMID races by using the same abstraction across the API implementation.
> > 
> > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Acked-by: Greg Thelen <gthelen@google.com>
> 
> Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
> 
> [...]
> 
> > +/*
> > + * ipc_valid_object() - helper to sort out IPC_RMID races for codepaths
> > + * where the respective ipc_ids.rwsem is not being held down.
> > + * Checks whether the ipc object is still around or if it's gone already, as
> > + * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
> > + * Needs to be called with kern_ipc_perm.lock held -- exception made for one
> > + * checkpoint case at sys_semtimedop() as noted in code commentary.
> > + */
> > +static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
> > +{
> > +	return perm->deleted == 0;
> > +}
> 
> I would like to see .deleted being converted to bool while we're at it
> though, that return statement just bugs the hell out of me. Could you
> send a patch for that as well?
>

Sure, as I mentioned earlier the full .deleted conversion from int to bool
it's on my todo list already for a follow-up patch.

Thanks!
-- Rafael 
