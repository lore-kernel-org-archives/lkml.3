Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3KXIy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 03:54:26 -0500
Received: from ra.se.axis.com ([195.60.68.13]:35768 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3KXIyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 03:54:24 -0500
Date: Sun, 24 Nov 2013 09:54:21 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Jesper Nilsson <jespern@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] ipc,shm: Correct error return value in shmctl
 (SHM_UNLOCK)
Message-ID: <20131124085420.GQ15831@axis.com>
References: <20131120104411.GA15831@axis.com>
 <1385276864.5320.14.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385276864.5320.14.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 08:07:44AM +0100, Mike Galbraith wrote:
> This patch (commit: 3a72660b07) is only slated for stable 3.12, but
> should go to 3.10/11 as well, no?

Yes, you're right, both 3.10 and 3.11 seem to have the restructuring
patch included (3.10.17 and 3.11.6 respectively), and so should have
this patch also.

> On Wed, 2013-11-20 at 11:44 +0100, Jesper Nilsson wrote: 
> > Commit 2caacaa82a51b78fc0c800e206473874094287ed restructured
> > the ipc shm to shorten critical region, but introduced a path
> > where the return value could be -EPERM, even if the operation
> > actually was performed.
> > 
> > Before the commit, the err return value was reset by the return value
> > from security_shm_shmctl() after the if (!ns_capable(...)) statement.
> > 
> > Now, we still exit the if statement with err set to -EPERM,
> > and in the case of SHM_UNLOCK, it is not reset at all,
> > and used as the return value from shmctl.
> > 
> > To fix this, we only set err when errors occur, leaving the
> > fallthrough case alone.
> > 
> > Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Davidlohr Bueso <davidlohr@hp.com>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Michel Lespinasse <walken@google.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: stable@vger.kernel.org
> > ---
> >  ipc/shm.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index d697396..4076f9e 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -974,12 +974,15 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
> >  		ipc_lock_object(&shp->shm_perm);
> >  		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
> >  			kuid_t euid = current_euid();
> > -			err = -EPERM;
> >  			if (!uid_eq(euid, shp->shm_perm.uid) &&
> > -			    !uid_eq(euid, shp->shm_perm.cuid))
> > +			    !uid_eq(euid, shp->shm_perm.cuid)) {
> > +				err = -EPERM;
> >  				goto out_unlock0;
> > -			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
> > +			}
> > +			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK)) {
> > +				err = -EPERM;
> >  				goto out_unlock0;
> > +			}
> >  		}
> >  
> >  		shm_file = shp->shm_file;
> > -- 
> > 1.8.4
> > 
> > 
> > /^JN - Jesper Nilsson
> 
> 

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
