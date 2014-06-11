Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaFKQTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:19:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57384 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaFKQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:19:03 -0400
Date: Wed, 11 Jun 2014 09:18:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: chiluk@canonical.com
Cc: Rafael Tinoco <rafael.tinoco@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, ebiederm@xmission.com,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
Message-ID: <20140611161857.GC4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
 <20140611133919.GZ4581@linux.vnet.ibm.com>
 <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
 <539879B8.4010204@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539879B8.4010204@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061116-6688-0000-0000-0000027F8942
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
> On 06/11/2014 10:17 AM, Rafael Tinoco wrote:
> > This script simulates a failure on a cloud infrastructure, for ex. As soon as
> > one virtualization host fails all its network namespaces have to be migrated
> > to other node. Creating thousands of netns in the shortest time possible
> > is the objective here. This regression was observed trying to migrate from
> > v3.5 to v3.8+.
> > 
> > Script creates up to 3000/4000 thousands network namespaces and places
> > links on them. Every 250 mark (netns already created) we have a throughput
> > average (how many were created per second up from last mark to this one).
> 
> Here's a little more background, and the "why it matters".

Thank you, this is quite helpful.

> In an openstack cloud, neutron *(openstack's networking framework) keeps
> all customers of the cloud separated via network namespaces.  On each
> compute node this is not a big deal, since each compute node can only
> handle at most a few hundred VMs.  However in order for neutron to route
> a customer's network traffic between disparate compute hosts, it uses
> the concept of a neutron gateway.  In order for customer A's vm on host
> 1 to talk to customer A's vm on host 2, it must first go through a gre
> tunnel to the neutron gateway.  The Neutron gateay then turns around and
> routes the network traffic over another gre tunnel to host 2.  The
> neutron gateway is where the problem is.
> 
> The neutron gateway must have a network namespace for every net
> namespace in the cloud.  Granted this collection can be split up by
> increasing the number of neutron gateways *(scaling out), but some
> clouds have decided to run these gateways on very beefy machines.  As
> you can see by the graph, there is a software limitation that prevents
> these machines from hosting any more than a few thousand namespaces.
> This makes the gateway's hardware severely under-utilized.
> 
> Now think about what happens when a gateway goes down, the namespaces
> need to be migrated, or a new machine needs to be brought up to replace
> it.  When we're talking about 3000 namespaces, the amount of time it
> takes simply to recreate the namespaces becomes very significant.
> 
> The script is a stripped down example of what exactly is being done on
> the neutron gateway in order to create namespaces.

Are the namespaces torn down and recreated one at a time, or is there some
syscall, ioctl(), or whatever that allows bulk tear down and recreating?

							Thanx, Paul

