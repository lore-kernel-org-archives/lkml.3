Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaCDTCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:02:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17613 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaCDTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:02:06 -0500
Message-ID: <1393959679.15574.0.camel@concerto>
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
From: Khalid Aziz <khalid.aziz@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, akpm@linux-foundation.org,
        andi.kleen@intel.com, rob@landley.net, venki@google.com,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 12:01:19 -0700
In-Reply-To: <20140304183857.GU18016@ZenIV.linux.org.uk>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	 <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com>
	 <20140304183857.GU18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 18:38 +0000, Al Viro wrote:
> On Tue, Mar 04, 2014 at 10:44:54AM -0700, Khalid Aziz wrote:
> 
> > do_exit() unmaps mmap_state->uaddr, and frees up mmap_state->kaddr
> > and mmap_state. mmap_state should not be NULL after unmap. vfree()
> > and kfree() are tolerant of pointers that have already been freed.
> 
> Huh?  Double free() is a bug, plain and simple.  Never do that - not
> in userland and especially not in the kernel.  Think what happens if
> some code gets executed between those two and asks to allocate something.
> If it gets the area you'd just freed, your second free will leave it
> with all kinds of nasty surprises.  Starting with "who the hell has
> started to modify the object I'd allocated and hadn't freed?"
> 
> A:	p = alloc();
> A:	free(p);
> B:	q = alloc();	/* q == p now */
> B:	*q = 0;		/* *q is zero */
> A:	free(p);	/* same as free(q) */
> C:	r = alloc();	/* r == q now */
> C:	*r = 1;		/* *q is one */
> B:	if (*q != 0) panic("somebody's buggering my memory");
> 
> It's always a bug, whether the implementation catches it or not.

Agreed, you are right. I will fix it.

--
Khalid



