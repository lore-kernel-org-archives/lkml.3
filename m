Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3KANob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:44:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3KANo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:44:29 -0400
Date: Fri, 1 Nov 2013 13:44:24 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: peterz@infradead.org, mingo@kernel.org, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
Message-ID: <20131101134424.GA32685@suse.de>
References: <20131031163144.0fd27457@annuminas.surriel.com>
 <20131101110825.GX2400@suse.de>
 <52739244.3060209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52739244.3060209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 07:36:36AM -0400, Rik van Riel wrote:
> On 11/01/2013 07:08 AM, Mel Gorman wrote:
> > On Thu, Oct 31, 2013 at 04:31:44PM -0400, Rik van Riel wrote:
> >> There is a race between stop_two_cpus, and the global stop_cpus.
> >>
> > 
> > What was the trigger for this? I want to see what was missing from my own
> > testing. I'm going to go out on a limb and guess that CPU hotplug was also
> > running in the background to specifically stress this sort of rare condition.
> > Something like running a standard test with the monitors/watch-cpuoffline.sh
> > from mmtests running in parallel.
> 
> AFAIK the trigger was a test that continuously loads and
> unloads kernel modules, while doing other stuff.
> 

ok, thanks.

> >> + wait_for_global:
> >> +	/* If a global stop_cpus is queuing up stoppers, wait. */
> >> +	while (unlikely(stop_cpus_queueing))
> >> +		cpu_relax();
> >> +
> > 
> > This partially serialises callers to migrate_swap() while it is checked
> > if the pair of CPUs are being affected at the moment. It's two-stage
> 
> Not really. This only serializes migrate_swap if there is a global
> stop_cpus underway.
> 

Ok, I see your point now but still wonder if this is too specialised
for what we are trying to do.  Could it have been done with a read-write
semaphore with the global stop_cpus taking it for write and stop_two_cpus
taking it for read?

-- 
Mel Gorman
SUSE Labs
