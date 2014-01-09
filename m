Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbaAIVei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:34:38 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:36035 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbaAIVe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:34:28 -0500
Date: Thu, 9 Jan 2014 13:34:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com>
References: <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz> <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014, Andrew Morton wrote:

> I just spent a happy half hour reliving this thread and ended up
> deciding I agreed with everyone!  I appears that many more emails are
> needed so I think I'll drop
> http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
> for now.
> 
> The claim that
> mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch
> will impact existing userspace seems a bit dubious to me.
> 

I'm not sure why this was dropped since it's vitally needed for any sane 
userspace oom handler to be effective.

Without the patch, a userspace oom handler waiting on memory.oom_control 
will be triggered when any process with a pending SIGKILL or in the exit() 
path simply needs access to memory reserves to make forward progress.  The 
kernel oom killer itself is preempted since nothing is actionable other 
than giving current access to memory reserves by setting the TIF_MEMDIE 
bit.  Userspace does not have the privilege to set this bit itself, so in 
such cases there is absolutely nothing actionable for the userspace oom 
handler.

The problem is that the userspace oom handler doesn't know that.

It would be ludicrous to require that a userspace oom handler must wait 
for some arbitrary amount of time to determine if it is actionable or not; 
what is a sane amount of time to wait?  Should we reliably expect that 
multiple oom notifications will be sent over a period of time if we are in 
a situation where current doesn't require memory reserves to make forward 
progress?  How long should the userspace oom handler store this state to 
determine how many times it has woken up?

Userspace oom handling implementations are fragile enough as it is, they 
should be made as trivial as possible to ensure they can do what is needed 
to make memory available, have the smallest memory footprint possible, and 
be as reliable as possible.  Requiring them to determine when a 
notification is actionable is troublesome.

Furthermore, Section 10 of Documentation/cgroups/memory.txt does not imply 
that any of this checking needs to be done and lists possible actions that 
a userspace oom handler can do upon being notified such as raising a limit 
or killing a process itself.  This is what userspace _expects_ to do when 
notified.

Giving current access to memory reserves so that it may make forward 
progress is something only the kernel can do and is a part of both the VM 
and memcg implementations to allow forward progress to be made.  It is not 
something userspace is involved in.

Additionally, you're not losing any functionality by merging the patch, if 
you really want to know simply when the limit has been reached and not 
something actionable as stated by the memcg documentation, you can do so 
with memory thresholds or VMPRESSURE_CRITICAL.

Google relies on this behavior so that userspace oom handlers can be 
implemented to respond to oom conditions and not cause unnecessary oom 
killing.  We'd like to know why you refuse to provide such an interface in 
a responsible and reliable way.

Thanks.
