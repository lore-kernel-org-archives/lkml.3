Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaEEWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:51:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:45827 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756715AbaEEWvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="506369479"
Subject: Re: [tip:locking/core] rwsem: Add comments to explain the meaning
 of the rwsem's count field
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        peter@hurleysoftware.com, jason.low2@hp.com, riel@redhat.com,
        alex.shi@linaro.org, paulmck@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, walken@google.com,
        davidlohr@hp.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20140505182750.GA14826@gmail.com>
References: <1399060437.2970.146.camel@schen9-DESK>
	 <tip-3cf2f34e1a3d4d5ff209d087925cf950e52f4805@git.kernel.org>
	 <1399305808.2970.186.camel@schen9-DESK> <20140505172611.GA7154@gmail.com>
	 <1399314085.2970.205.camel@schen9-DESK>  <20140505182750.GA14826@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 May 2014 15:51:16 -0700
Message-ID: <1399330276.2970.207.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 20:27 +0200, Ingo Molnar wrote:

> > Ingo,
> > 
> > The delta patch is included below.  Thinking a bit more,
> > the state diagram approach is not necessarily less verbose
> > because the state is a tuple (count, wait queue state).
> > After enumerating the states, we may wind up with very similar
> > to what I have.
> 
> Could we at least try with one diagram and see how it goes?
> 

I've tried (see below).  But I don't like how it came out :(

Tim


---

Events:
	(1) Attempt read lock (+ACTIVE_BIAS)
	(2) Attempt write lock (+ACTIVE_WRITE_BIAS)
	(3) Abort read lock or read unlock  (-ACTIVE_BIAS)
	(4) Abort write lock or write unlock  (-ACTIVE_WRITE_BIAS)
	(5) Put reader/writer on queue after read/write lock attempt has been aborted
			  (+WAITING_BIAS if queue empty)
	(6) Pull reader/writer from head of queue
			  (-WAITING_BIAS if queue becomes empty)

State	Event	Next-State
-----   -----   ----------
(A)	count > 0 (0x0000000X), queue empty  

	1 => 	(A)
	2 => 	(C.0) 
	3 => 	(A if count > 1, B if count =1)
	4 not applicable
	5 => 	(C.0)
	6 not applicable

(B)	count = 0 (0x00000000), queue empty   

	1 => 	(A)
	2 => 	(C.0) 
	3, 4 not applicable
	5 =>	(E.0)
	6 not applicable

(C.0)	0 > count > WAITING_BIAS (0xffff000X), queue empty

	1 => 	(C.0)
	2 => 	(E.0)
	3 => 	(count=0xffff0001 implies 1 writer, no readers to abort, C.0 if count > 0xffff0001)
	4 => 	(B if count=0xffff0001, A if count > 0xffff0001)
	5 => 	(E.1)
	6 not applicable

(C.1)	0 > count > WAITING_BIAS (0xffff000X), queue non-empty

	1 => 	(C.1) 
	2 => 	(E.1)
	3 => 	(D if count=0xffff0001, C.1 if count > 0xffff0001)
	4 => 	(B if count=0xffff0001, A if count > 0xffff0001)
	5 => 	(E.1)
	6 =>	(A or B if queue becomes empty, C.1 if queue remains non-empty)
	     
(D)	count = WAITING_BIAS (0xffff0000), queue non-empty

	1 =>	(C.0)
	2 =>	(E.0)
	3,4 not applicable
	5 =>	(D)
	6 =>	(A if queue becomes empty, D otherwise)

(E.0)	count < WAITING_BIAS, queue empty

	1 =>	(E.0)
	2 =>	(E.0)
	3 =>	(E.0)
	4 =>	(C.0 if count > 2*WAITING_BIAS  E.0 otherwise)
	5 => 	(E.1)
	6 not applicable 

(E.1)	count < WAITING_BIAS, queue non-empty   

	1 =>	(E.1)
	2 =>	(E.1)
	3 =>	(E.1)
	4 =>	(C.1 if count < 2*WAITING_BIAS,  E.1 otherwise)
	5 => 	(E.1)
	6 =>	(D if count = 2*WAITING_BIAS, E.1 otherwise, queue remains non-empty) or
		E.0 otherwise 


