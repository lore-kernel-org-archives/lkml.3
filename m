Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaC0E5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:57:18 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56864 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaC0E5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:57:17 -0400
Message-ID: <1395896233.5512.45.camel@marge.simpson.net>
Subject: Re: [RFC II] Splitting scheduler into two halves
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang du <yuyang.du@intel.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, morten.rasmussen@arm.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com
Date: Thu, 27 Mar 2014 05:57:13 +0100
In-Reply-To: <20140326183721.GC24116@intel.com>
References: <20140326183721.GC24116@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-27 at 02:37 +0800, Yuyang du wrote: 
> Hi all,
> 
> This is continued after the first RFC about splitting the scheduler. Still
> work-in-progress, and call for feedback.
> 
> The question addressed here is how load balance should be changed. And I think
> the question then goes to how to *reuse* common code as much as possible and
> meanwhile be able to serve various objectives.
> 
> So these are the basic semantics needed in current load balance:

I'll probably regret it, but I'm gonna speak my mind.  I think this two
halves concept is fundamentally broken. 

> 1. [ At balance point ] on this_cpu push task on that_cpu to [ third_cpu ]

Load balancing is a necessary part of the fastpath as well as slow path,
you can't just define balance point, and have that mean a point at which
we can separate core functionality from peripheral.  For example, rt
class has push/pull at schedule time, fair class select_idle_sibling()
at wakeup, both in the fastpath, to minimize latency.  It is all load
balancing, is push pull, fastpath does exactly the same things as slow
path, for the exact same reason, only resource investment varies.

I don't think you can separate the scheduler into two halves like this,
load balancing is an integral part and fundamental consequence of being
a multi-queue scheduler.  Scheduling and balancing are not two halves
that make a whole, and can thus be separated, they are one.

-Mike

