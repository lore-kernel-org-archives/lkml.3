Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaBLWIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:08:00 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:40221 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaBLWH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:07:59 -0500
Date: Wed, 12 Feb 2014 14:07:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: linuxnfs <linux-nfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question about nfs4_destroy_session()
Message-ID: <20140212220753.GG4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140212214209.GA4136@linux.vnet.ibm.com>
 <5BCC49E0-6F92-49EC-BFCD-17D5CA4D30C7@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5BCC49E0-6F92-49EC-BFCD-17D5CA4D30C7@primarydata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021222-9332-0000-0000-000003161BB2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 04:55:02PM -0500, Trond Myklebust wrote:
> 
> On Feb 12, 2014, at 16:42, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Trond,
> > 
> > In nfs4_destroy_session(), there is an rcu_dereference() that looks to
> > leak the returned pointer out of an RCU read-side critical section.
> > If the pointed-to object might have just now been created, this is a
> > bug because xprt_destroy_backchannel() dereferences this pointer.
> > 
> > So, does xprt_destroy_backchannel() exclude creation-side code?  (If so,
> > no bug -- but a comment might be good.)
> > 
> > 							Thanx, Paul
> > 
> > void nfs4_destroy_session(struct nfs4_session *session)
> > {
> > 	struct rpc_xprt *xprt;
> > 	struct rpc_cred *cred;
> > 
> > 	cred = nfs4_get_clid_cred(session->clp);
> > 	nfs4_proc_destroy_session(session, cred);
> > 	if (cred)
> > 		put_rpccred(cred);
> > 
> > 	rcu_read_lock();
> > 	xprt = rcu_dereference(session->clp->cl_rpcclient->cl_xprt);
> > 	rcu_read_unlock();
> > 	dprintk("%s Destroy backchannel for xprt %p\n",
> > 		__func__, xprt);
> > 	xprt_destroy_backchannel(xprt, NFS41_BC_MIN_CALLBACKS);
> > 	nfs4_destroy_session_slot_tables(session);
> > 	kfree(session);
> > }
> > 
> 
> Hi Paul,
> 
> nfs4_destroy_session() is only called when we’re tearing down the struct nfs_client that owns the cl_rppcclient, and the associated cl_xprt, so the code above should be safe, despite being ugly.
> 
> Is there a better annotation for use in the above kind of situation?

One approach would be to add a comment on the rcu_dereference() stating
that creation-side code is excluded, e.g., via locking or by the data
structures no longer being accessible.  Another approach would be to
move the rcu_read_unlock() to follow the xprt_destroy_backchannel(),
assuming none of the code that would be pulled into the RCU read-side
critical section can block.

The second approach would prevent false positives from the RCU pointer
leak detectors that are being worked on.

							Thanx, Paul

