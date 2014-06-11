Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaFKTsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:48:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47729 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaFKTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:48:37 -0400
Date: Wed, 11 Jun 2014 12:48:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Rafael Tinoco <rafael.tinoco@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
Message-ID: <20140611194832.GL4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
 <20140611133919.GZ4581@linux.vnet.ibm.com>
 <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
 <539879B8.4010204@canonical.com>
 <20140611161857.GC4581@linux.vnet.ibm.com>
 <53989F7B.6000004@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53989F7B.6000004@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061119-7164-0000-0000-000002625D70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:27:07PM -0500, Dave Chiluk wrote:
> On 06/11/2014 11:18 AM, Paul E. McKenney wrote:
> > On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
> >> Now think about what happens when a gateway goes down, the namespaces
> >> need to be migrated, or a new machine needs to be brought up to replace
> >> it.  When we're talking about 3000 namespaces, the amount of time it
> >> takes simply to recreate the namespaces becomes very significant.
> >>
> >> The script is a stripped down example of what exactly is being done on
> >> the neutron gateway in order to create namespaces.
> > 
> > Are the namespaces torn down and recreated one at a time, or is there some
> > syscall, ioctl(), or whatever that allows bulk tear down and recreating?
> > 
> > 							Thanx, Paul
> 
> In the normal running case, the namespaces are created one at a time, as
> new customers create a new set of VMs on the cloud.
> 
> However, in the case of failover to a new neutron gateway the namespaces
> are created all at once using the ip command (more or less serially).
> 
> As far as I know there is no syscall or ioctl that allows bulk tear down
> and recreation.  if such a beast exists that might be helpful.

The solution might be to create such a beast.  I might be able to shave
a bit of time off of this benchmark, but at the cost of significant
increases in RCU's CPU consumption.  A bulk teardown/recreation API could
reduce the RCU grace-period overhead by several orders of magnitude by
having a single RCU grace period cover a few thousand changes.

This is why other bulk-change syscalls exist.

Just out of curiosity, what syscalls does the ip command use?

							Thanx, Paul

