Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaBLVu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:50:26 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44995 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaBLVuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:50:22 -0500
Date: Wed, 12 Feb 2014 13:50:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "roland@kernel.org" <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
Message-ID: <20140212215017.GF4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140212003511.GA27242@linux.vnet.ibm.com>
 <32E1700B9017364D9B60AED9960492BC211F3D24@FMSMSX107.amr.corp.intel.com>
 <20140212145543.GY4250@linux.vnet.ibm.com>
 <32E1700B9017364D9B60AED9960492BC211F3D75@FMSMSX107.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211F3D75@FMSMSX107.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021221-3532-0000-0000-0000058DEF29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 02:57:14PM +0000, Marciniszyn, Mike wrote:
> BTW, I am considering eliminating the atomic_inc() in favor of widening the scope of the rcu lock expanse.

As long as the newly included code doesn't block, that should work fine.
(If it does block, another option is SRCU.)

							Thanx, Paul

> Mike
> 
> > -----Original Message-----
> > From: Paul E. McKenney [mailto:paulmck@linux.vnet.ibm.com]
> > Sent: Wednesday, February 12, 2014 9:56 AM
> > To: Marciniszyn, Mike
> > Cc: roland@kernel.org; Hefty, Sean; hal.rosenstock@gmail.com; linux-
> > rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
> > 
> > On Wed, Feb 12, 2014 at 01:59:30PM +0000, Marciniszyn, Mike wrote:
> > > > So what am I missing here?
> > > >
> > >
> > > The atomic increment of a reference count:
> > 
> > Got it, thank you, apologies for the noise!
> > 
> > 							Thanx, Paul
> > 
> > > struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn) {
> > >         struct qib_qp *qp = NULL;
> > >
> > >         rcu_read_lock();
> > >         if (unlikely(qpn <= 1)) {
> > >                 if (qpn == 0)
> > >                         qp = rcu_dereference(ibp->qp0);
> > >                 else
> > >                         qp = rcu_dereference(ibp->qp1);
> > >                 if (qp)
> > >                         atomic_inc(&qp->refcount); <--------------------------
> > >         } else {
> > >                 struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
> > >                 unsigned n = qpn_hash(dev, qpn);
> > >
> > >                 for (qp = rcu_dereference(dev->qp_table[n]); qp;
> > >                         qp = rcu_dereference(qp->next))
> > >                         if (qp->ibqp.qp_num == qpn) {
> > >                                 atomic_inc(&qp->refcount); <---------------------
> > >                                 break;
> > >                         }
> > >         }
> > >         rcu_read_unlock();
> > >         return qp;
> > > }
> > >
> > > Mike
> > >
> 

