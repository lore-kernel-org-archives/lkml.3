Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3EARBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:01:50 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34895 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3EARBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:01:44 -0400
Date: Wed, 1 May 2013 10:01:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
cc: xfs@oss.sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: deadlock on vmap_area_lock
In-Reply-To: <20130501164406.GC2404@BohrerMBP.rgmadvisors.com>
Message-ID: <alpine.DEB.2.02.1305010959070.16591@chino.kir.corp.google.com>
References: <20130501144341.GA2404@BohrerMBP.rgmadvisors.com> <alpine.DEB.2.02.1305010855440.4547@chino.kir.corp.google.com> <20130501164406.GC2404@BohrerMBP.rgmadvisors.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Shawn Bohrer wrote:

> Correct it doesn't and I can't prove the find command is not making
> progress, however these finds normally complete in under 15 min and
> we've let the stuck ones run for days.  Additionally if this was just
> contention I'd expect to see multiple threads/CPUs contending and I
> only have a single CPU pegged running find at 99%. I should clarify
> that the perf snippet above was for the entire system.  Profiling just
> the find command shows:
> 
>     82.56%     find  [kernel.kallsyms]  [k] _raw_spin_lock

Couple of options to figure out what spinlock this is: use lockstat (see 
Documentation/lockstat.txt), which will also require a kernel rebuild, 
some human intervention to collect the stats, and the accompanying 
performance degradation, or you could try collecting
/proc/$(pidof find)/stack at regular intervals and figure out which 
spinlock it is.

> > Depending on your 
> > definition of "occassionally", would it be possible to run with 
> > CONFIG_PROVE_LOCKING and CONFIG_LOCKDEP to see if it uncovers any real 
> > deadlock potential?
> 
> Yeah, I can probably enable these on a few machines and hope I get
> lucky.  These machines are used for real work so I'll have to gauge
> what how significant the performance impact is to determine how many
> machines I can sacrifice to the cause.
> 

You'll probably only need to enable it on one machine, if a deadlock 
possibility exists here then lockdep will find it even without hitting it, 
it simply has to exercise the path that leads to it.  It does have a 
performance degradation for that one machine, though.
