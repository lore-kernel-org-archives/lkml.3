Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaLHX5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:57:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:56934 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaLHX5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:57:09 -0500
Date: Mon, 8 Dec 2014 12:47:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v1] CPU hotplug: active_reader not woken up in some cases
 - deadlock
Message-ID: <20141208204716.GT25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418062383-39657-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141208183134.GQ25340@linux.vnet.ibm.com>
 <20141208195814.663007dd@thinkpad-w530>
 <20141208190803.GR25340@linux.vnet.ibm.com>
 <20141208203018.24f23bdb@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208203018.24f23bdb@thinkpad-w530>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120823-0021-0000-0000-000006C739EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 08:30:18PM +0100, David Hildenbrand wrote:
> > > active_writer is cleared while holding cpuhp_lock, so this should be safe,
> > > right?
> > 
> > You lost me on that one.  Don't we get to that piece of code precisely
> > because we don't hold any of the CPU-hotplug locks?  If so, the
> > writer might well hold all the locks it needs, and might well change
> > cpu_hotplug.active_writer out from under us.
> > 
> > What am I missing here?
> > 
> > 							Thanx, Paul
> 
> I was missing that cpuhp_lock_* are simply lockdep anotations ... it's
> getting late :)
> 
> So you're right, we need to verify that we don't get a 0 on the second access.

All you should need to do is to do something like this:

	awp = ACCESS_ONCE(cpu_hotplug.active_writer);
	if (awp)
		wake_up_process(cpu_hotplug.active_writer);

That way you only have one access, and the check and wake_up_process()
are guaranteed to be consistent.

> Will send an updated version soon.

Sounds good!

							Thanx, Paul

