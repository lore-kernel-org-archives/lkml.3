Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaLPWeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:34:03 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45325 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLPWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:34:00 -0500
Date: Tue, 16 Dec 2014 14:33:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Chintan Pandya <cpandya@codeaurora.org>, hannes@cmpxchg.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
In-Reply-To: <20141216133935.GK22914@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.10.1412161430040.5142@chino.kir.corp.google.com>
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org> <20141216133935.GK22914@dhcp22.suse.cz>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Michal Hocko wrote:

> > We may want to use memcg to limit the total memory
> > footprint of all the processes within the one group.
> > This may lead to a situation where any arbitrary
> > process cannot get migrated to that one  memcg
> > because its limits will be breached. Or, process can
> > get migrated but even being most recently used
> > process, it can get killed by in-cgroup OOM. To
> > avoid such scenarios, provide a convenient knob
> > by which we can forcefully trigger OOM and make
> > a room for upcoming process.
> > 
> > To trigger force OOM,
> > $ echo 1 > /<memcg_path>/memory.force_oom
> 
> What would prevent another task deplete that memory shortly after you
> triggered OOM and end up in the same situation? E.g. while the moving
> task is migrating its charges to the new group...
> 
> Why cannot you simply disable OOM killer in that memcg and handle it
> from userspace properly?
> 

The patch is introducing a mechanism to induce a kernel oom kill for a 
memcg hierarchy to make room for it in the new memcg, not disable the oom 
killer so the migration fails due to the lower limits.

It doesn't have any basis since a SIGKILL coming from userspace should be 
considered the same as a kernel oom kill from the memcg perspective, i.e. 
the fatal_signal_pending() checks that allow charge bypass instead of a 
strict reliance on TIF_MEMDIE being set.

It seems to be proposed as a shortcut so that the kernel will determine 
the best process to kill.  That information is available to userspace so 
it should be able to just SIGKILL the desired process (either in the 
destination memcg or in the source memcg to allow deletion), so this 
functionality isn't needed in the kernel.
