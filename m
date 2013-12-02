Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3LBWvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:51:43 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:49018 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3LBWvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:51:41 -0500
Date: Mon, 2 Dec 2013 14:51:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, azurit@pobox.sk,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [merged] mm-memcg-handle-non-error-oom-situations-more-gracefully.patch
 removed from -mm tree
In-Reply-To: <20131202131238.GB18838@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312021443590.13465@chino.kir.corp.google.com>
References: <526028bd.k5qPj2+MDOK1o6ii%akpm@linux-foundation.org> <alpine.DEB.2.02.1311271453270.13682@chino.kir.corp.google.com> <20131127233353.GH3556@cmpxchg.org> <alpine.DEB.2.02.1311271622330.10617@chino.kir.corp.google.com> <20131128021809.GI3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271826001.5120@chino.kir.corp.google.com> <20131128031313.GK3556@cmpxchg.org> <alpine.DEB.2.02.1311271914460.5120@chino.kir.corp.google.com> <20131128100213.GE2761@dhcp22.suse.cz> <alpine.DEB.2.02.1311291600290.22413@chino.kir.corp.google.com>
 <20131202131238.GB18838@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Michal Hocko wrote:

> I guess we need to know how much is significantly less.
> oom_scan_process_thread already aborts on exiting tasks so we do not
> kill anything and then the charge (whole page fault actually) is retried
> when we check for the OOM again so my intuition would say that we gave
> the exiting task quite a lot of time.
> 

That isn't the race, though.  The race occurs when the oom killed process 
exits prior to the process iteration so it's not detected and yet its 
memory has already been freed and the memcg is no longer oom.  In other 
words, a process that has called mem_cgroup_oom_synchronize() at the same 
time that an oom killed process has freed its memory.  The result is an 
unnecessary oom killing and erroneous spam in the kernel log.

We all agree that this race cannot be completely closed (at least without 
synchronization in the uncharge path that we obviously don't want to add).  
We don't know if an oom killed process, or any process, will free its 
memory immediately after the kernel sends the SIGKILL.  However, there's 
absolutely no reason to not have a final check immediately before sending 
the SIGKILL to prevent that unnecessary oom kill.

I'm going to send the patch for review.
