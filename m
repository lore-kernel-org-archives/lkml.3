Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab3FSVbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:31:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53920 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934936Ab3FSVbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:31:03 -0400
Date: Wed, 19 Jun 2013 14:30:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch] mm, memcg: add oom killer delay
In-Reply-To: <alpine.DEB.2.02.1306140254590.8780@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1306191429340.13015@chino.kir.corp.google.com>
References: <20130603193147.GC23659@dhcp22.suse.cz> <alpine.DEB.2.02.1306031411380.22083@chino.kir.corp.google.com> <20130604095514.GC31242@dhcp22.suse.cz> <alpine.DEB.2.02.1306042329320.20610@chino.kir.corp.google.com> <20130605093937.GK15997@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306051657001.29626@chino.kir.corp.google.com> <20130610142321.GE5138@dhcp22.suse.cz> <alpine.DEB.2.02.1306111321360.32688@chino.kir.corp.google.com> <20130612202348.GA17282@dhcp22.suse.cz> <alpine.DEB.2.02.1306121408490.24902@chino.kir.corp.google.com>
 <20130613151602.GG23070@dhcp22.suse.cz> <alpine.DEB.2.02.1306131508300.8686@chino.kir.corp.google.com> <51BA6A2A.3060107@jp.fujitsu.com> <alpine.DEB.2.02.1306140254590.8780@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, David Rientjes wrote:

> Even with all of the above (which is not actually that invasive of a 
> patch), I still think we need memory.oom_delay_millisecs.  I probably made 
> a mistake in describing what that is addressing if it seems like it's 
> trying to address any of the above.
> 
> If a userspace oom handler fails to respond even with access to those 
> "memcg reserves", the kernel needs to kill within that memcg.  Do we do 
> that above a set time period (this patch) or when the reserves are 
> completely exhausted?  That's debatable, but if we are to allow it for 
> global oom conditions as well then my opinion was to make it as safe as 
> possible; today, we can't disable the global oom killer from userspace and 
> I don't think we should ever allow it to be disabled.  I think we should 
> allow userspace a reasonable amount of time to respond and then kill if it 
> is exceeded.
> 
> For the global oom case, we want to have a priority-based memcg selection.  
> Select the lowest priority top-level memcg and kill within it.  If it has 
> an oom notifier, send it a signal to kill something.  If it fails to 
> react, kill something after memory.oom_delay_millisecs has elapsed.  If 
> there isn't a userspace oom notifier, kill something within that lowest 
> priority memcg.
> 
> The bottomline with my approach is that I don't believe there is ever a 
> reason for an oom memcg to remain oom indefinitely.  That's why I hate 
> memory.oom_control == 1 and I think for the global notification it would 
> be deemed a nonstarter since you couldn't even login to the machine.
> 

What's the status of this patch?  I'd love to be able to introduce memcg 
reserves so that userspace oom notifications can actually work, but we 
still require a failsafe in the kernel if those reserves are depleted or 
userspace cannot respond.
