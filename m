Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaAVExM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:53:12 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:42289 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAVExL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:53:11 -0500
Date: Tue, 21 Jan 2014 20:53:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: oom_kill: revert 3% system memory bonus for privileged
 tasks
In-Reply-To: <20140116070709.GM6963@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
References: <20140115234308.GB4407@cmpxchg.org> <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com> <20140116070709.GM6963@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Johannes Weiner wrote:

> > Unfortunately, I think this could potentially be too much of a bonus.  On 
> > your same 32GB machine, if a root process is using 18GB and a user process 
> > is using 14GB, the user process ends up getting selected while the current 
> > discount of 3% still selects the root process.
> > 
> > I do like the idea of scaling this bonus depending on points, however.  I 
> > think it would be better if we could scale the discount but also limit it 
> > to some sane value.
> 
> I just reverted to the /= 4 because we had that for a long time and it
> seemed to work.  I don't really mind either way as long as we get rid
> of that -3%.  Do you have a suggestion?
> 

How about simply using 3% of the root process's points so that root 
processes get some bonus compared to non-root processes with the same 
memory usage and it's scaled to the usage rather than amount of available 
memory?

So rather than points /= 4, we do

	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
		points -= (points * 3) / 100;

instead.  Sound good?
