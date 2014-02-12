Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaBLO5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 09:57:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:4128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaBLO5Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 09:57:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,832,1384329600"; 
   d="scan'208";a="480284427"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
CC: "roland@kernel.org" <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: qib_lookup_qpn() appears to leak pointer out of
 rcu_read_unlock()
Thread-Topic: qib_lookup_qpn() appears to leak pointer out of
 rcu_read_unlock()
Thread-Index: AQHPJ4pjFcrhoLEfzEOnJavhYKoyFZqxpd4wgACWKoD//3oOQA==
Date: Wed, 12 Feb 2014 14:57:14 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F3D75@FMSMSX107.amr.corp.intel.com>
References: <20140212003511.GA27242@linux.vnet.ibm.com>
 <32E1700B9017364D9B60AED9960492BC211F3D24@FMSMSX107.amr.corp.intel.com>
 <20140212145543.GY4250@linux.vnet.ibm.com>
In-Reply-To: <20140212145543.GY4250@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, I am considering eliminating the atomic_inc() in favor of widening the scope of the rcu lock expanse.

Mike

> -----Original Message-----
> From: Paul E. McKenney [mailto:paulmck@linux.vnet.ibm.com]
> Sent: Wednesday, February 12, 2014 9:56 AM
> To: Marciniszyn, Mike
> Cc: roland@kernel.org; Hefty, Sean; hal.rosenstock@gmail.com; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: qib_lookup_qpn() appears to leak pointer out of rcu_read_unlock()
> 
> On Wed, Feb 12, 2014 at 01:59:30PM +0000, Marciniszyn, Mike wrote:
> > > So what am I missing here?
> > >
> >
> > The atomic increment of a reference count:
> 
> Got it, thank you, apologies for the noise!
> 
> 							Thanx, Paul
> 
> > struct qib_qp *qib_lookup_qpn(struct qib_ibport *ibp, u32 qpn) {
> >         struct qib_qp *qp = NULL;
> >
> >         rcu_read_lock();
> >         if (unlikely(qpn <= 1)) {
> >                 if (qpn == 0)
> >                         qp = rcu_dereference(ibp->qp0);
> >                 else
> >                         qp = rcu_dereference(ibp->qp1);
> >                 if (qp)
> >                         atomic_inc(&qp->refcount); <--------------------------
> >         } else {
> >                 struct qib_ibdev *dev = &ppd_from_ibp(ibp)->dd->verbs_dev;
> >                 unsigned n = qpn_hash(dev, qpn);
> >
> >                 for (qp = rcu_dereference(dev->qp_table[n]); qp;
> >                         qp = rcu_dereference(qp->next))
> >                         if (qp->ibqp.qp_num == qpn) {
> >                                 atomic_inc(&qp->refcount); <---------------------
> >                                 break;
> >                         }
> >         }
> >         rcu_read_unlock();
> >         return qp;
> > }
> >
> > Mike
> >

