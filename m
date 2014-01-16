Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaAPASx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:18:53 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:48764 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaAPASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:18:50 -0500
Date: Wed, 15 Jan 2014 16:18:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: oom_kill: revert 3% system memory bonus for privileged
 tasks
In-Reply-To: <20140115234308.GB4407@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com>
References: <20140115234308.GB4407@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014, Johannes Weiner wrote:

> With a63d83f427fb ("oom: badness heuristic rewrite"), the OOM killer
> tries to avoid killing privileged tasks by subtracting 3% of overall
> memory (system or cgroup) from their per-task consumption.  But as a
> result, all root tasks that consume less than 3% of overall memory are
> considered equal, and so it only takes 33+ privileged tasks pushing
> the system out of memory for the OOM killer to do something stupid and
> kill sshd or dhclient.  For example, on a 32G machine it can't tell
> the difference between the 1M agetty and the 10G fork bomb member.
> 
> The changelog describes this 3% boost as the equivalent to the global
> overcommit limit being 3% higher for privileged tasks, but this is not
> the same as discounting 3% of overall memory from _every privileged
> task individually_ during OOM selection.
> 
> Revert back to the old priority boost of pretending root tasks are
> only a quarter of their actual size.
> 

Unfortunately, I think this could potentially be too much of a bonus.  On 
your same 32GB machine, if a root process is using 18GB and a user process 
is using 14GB, the user process ends up getting selected while the current 
discount of 3% still selects the root process.

I do like the idea of scaling this bonus depending on points, however.  I 
think it would be better if we could scale the discount but also limit it 
to some sane value.
