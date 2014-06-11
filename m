Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaFKPqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:46:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbaFKPqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:46:07 -0400
Message-ID: <539879B8.4010204@canonical.com>
Date: Wed, 11 Jun 2014 10:46:00 -0500
From: David Chiluk <dave.chiluk@canonical.com>
Reply-To: chiluk@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rafael Tinoco <rafael.tinoco@canonical.com>, paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, ebiederm@xmission.com,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>	<20140611133919.GZ4581@linux.vnet.ibm.com> <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
In-Reply-To: <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 10:17 AM, Rafael Tinoco wrote:
> This script simulates a failure on a cloud infrastructure, for ex. As soon as
> one virtualization host fails all its network namespaces have to be migrated
> to other node. Creating thousands of netns in the shortest time possible
> is the objective here. This regression was observed trying to migrate from
> v3.5 to v3.8+.
> 
> Script creates up to 3000/4000 thousands network namespaces and places
> links on them. Every 250 mark (netns already created) we have a throughput
> average (how many were created per second up from last mark to this one).

Here's a little more background, and the "why it matters".

In an openstack cloud, neutron *(openstack's networking framework) keeps
all customers of the cloud separated via network namespaces.  On each
compute node this is not a big deal, since each compute node can only
handle at most a few hundred VMs.  However in order for neutron to route
a customer's network traffic between disparate compute hosts, it uses
the concept of a neutron gateway.  In order for customer A's vm on host
1 to talk to customer A's vm on host 2, it must first go through a gre
tunnel to the neutron gateway.  The Neutron gateay then turns around and
routes the network traffic over another gre tunnel to host 2.  The
neutron gateway is where the problem is.

The neutron gateway must have a network namespace for every net
namespace in the cloud.  Granted this collection can be split up by
increasing the number of neutron gateways *(scaling out), but some
clouds have decided to run these gateways on very beefy machines.  As
you can see by the graph, there is a software limitation that prevents
these machines from hosting any more than a few thousand namespaces.
This makes the gateway's hardware severely under-utilized.

Now think about what happens when a gateway goes down, the namespaces
need to be migrated, or a new machine needs to be brought up to replace
it.  When we're talking about 3000 namespaces, the amount of time it
takes simply to recreate the namespaces becomes very significant.

The script is a stripped down example of what exactly is being done on
the neutron gateway in order to create namespaces.

Dave.

