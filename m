Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaLJDST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:18:19 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:40756 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaLJDSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:18:17 -0500
Date: Tue, 9 Dec 2014 19:18:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Hildenbrand <dahi@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some	cases
 - deadlock
Message-ID: <20141210031809.GO25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141209141903.GB25340@linux.vnet.ibm.com>
 <20141210002619.GB516@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210002619.GB516@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121003-0025-0000-0000-000006CA4811
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 01:26:19AM +0100, Oleg Nesterov wrote:
> On 12/09, Paul E. McKenney wrote:
> >
> > Would wait_event()/wake_up() work for the wakeup-writer case?
> 
> Yes, and in this case we could probably kill this puts_pending logic
> and avoid cpu_hotplug.lock in put_online_cpus() altogether? Can't we
> just make cpu_hotplug.refcount atomic_t?

Seems like that should be possible.  That would certainly simplify the
wakeup logic from put_online_cpus().  It might even be possible to
avoid acquiring cpu_hotplug.lock in put_online_cpus(), though that
would of course require more luck than anyone deserves.

> Anyway, this makes me think again that this code should use percpu_rwsem.
> Perhaps I'll try to make a patch next week...
> 
> (we need down_write_recursive_readers(), and probably rcusync patches).

Careful!  You might end up re-introducing the deadlock that I used
puts_pending to get rid of.  ;-)

							Thanx, Paul

