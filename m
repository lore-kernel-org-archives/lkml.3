Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaEBMDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:03:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaEBMDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:03:10 -0400
Date: Fri, 2 May 2014 14:03:08 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140502120308.GH3446@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <20140430145238.4215f914f7ad025da4db5470@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430145238.4215f914f7ad025da4db5470@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-04-14 14:52:38, Andrew Morton wrote:
> On Mon, 28 Apr 2014 14:26:41 +0200 Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hi,
> > previous discussions have shown that soft limits cannot be reformed
> > (http://lwn.net/Articles/555249/). This series introduces an alternative
> > approach for protecting memory allocated to processes executing within
> > a memory cgroup controller. It is based on a new tunable that was
> > discussed with Johannes and Tejun held during the kernel summit 2013 and
> > at LSF 2014.
> > 
> > This patchset introduces such low limit that is functionally similar
> > to a minimum guarantee. Memcgs which are under their lowlimit are not
> > considered eligible for the reclaim (both global and hardlimit) unless
> > all groups under the reclaimed hierarchy are below the low limit when
> > all of them are considered eligible.
> 
> Permitting containers to avoid global reclaim sounds rather worrisome. 
> 
> Fairness: won't it permit processes to completely protect their memory
> while everything else in the system is getting utterly pounded?  We
> need to consider global-vs-memcg fairness as well as memcg-vs-memgc.
> 
> Security: can this feature be used to DoS the machine?  Set up enough
> hierarchies which are below their low limit and we risk memory
> exhaustion and swap-thrashing and oom-killings for other processes.

Johannes has already pointed out that setting the low limit is really
supposed to be a privileged operation. And, in principle, this is not any
different from any other guarantee.
 
> All of that being said, your statement doesn't appear to be true ;)

"
Memcgs which are under their lowlimit are ignored during the reclaim
(both global and hardlimit) unless all groups under the reclaimed
hierarchy are below the low limit. Low limit will be ignored in this
case for all groups in the hierarchy.
"

Better?

> > +static void shrink_zone(struct zone *zone, struct scan_control *sc)
> > +{
> > +	if (!__shrink_zone(zone, sc, true)) {
> > +		/*
> > +		 * First round of reclaim didn't find anything to reclaim
> > +		 * because of low limit protection so try again and ignore
> > +		 * the low limit this time.
> > +		 */
> > +		__shrink_zone(zone, sc, false);
> > +	}
> >  }
> `

-- 
Michal Hocko
SUSE Labs
