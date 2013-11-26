Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab3KZBga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 20:36:30 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46621 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3KZBg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 20:36:26 -0500
Date: Mon, 25 Nov 2013 17:36:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Vladimir Murzin <murzin.v@gmail.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131121171307.GB16703@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1311251731430.27270@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <20131120172119.GA1848@hp530> <20131120173357.GC18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201937120.7167@chino.kir.corp.google.com>
 <20131121171307.GB16703@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Michal Hocko wrote:

> > It's an interesting idea but unfortunately a non-starter for us because 
> > our users don't have root,
> 
> I wouldn't see this as a problem. You can still have a module which
> exports the notification interface you need. Including timeout
> fallback. That would be trivial to implement and maybe more appropriate
> to very specific environments. Moreover the global OOM handling wouldn't
> be memcg bound.
> 

The memcg userspace oom handlers are effectively system userspace oom 
handlers for everything at that memcg and its descendant memcgs, the 
interface for the system oom handler and the memcg oom handlers would be 
identical.  We could certainly make the hook into a module by defining 
some sort of API that could be exported, but I believe the proposal 
empowers userspace to handle the oom situations in all possible scenarios 
(notification, memory reserve, timeout) that it would stand alone as the 
only user in the kernel of such an API and that API itself makes the code 
unnecessarily complex.

> > we create their memcg tree and then chown it to the user.  They can
> > freely register for oom notifications but cannot load their own kernel
> > modules for their own specific policy.
> 
> yes I see but that requires just a notification interface. It doesn't
> have to be memcg specific, right?

They also need the memory reserve to do anything useful when the oom 
handler wakes up, so you'd need an API exported to modules that allows you 
to define the set of processes allowed to access such a reserve.  So the 
kernel code providing the needed functionality (notification, reserve, 
timeout) remains constant for any possible userspace oom handler.  Unless 
you're thinking of a possible implementation that can't be addressed in 
this way?
