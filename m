Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3CLQJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:09:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45825
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216Ab3CLQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:09:53 -0400
Message-ID: <1363104578.24558.9.camel@laptop>
Subject: Re: [PATCH] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 12 Mar 2013 17:09:38 +0100
In-Reply-To: <20130312154341.GB18852@kroah.com>
References: <513ECCFE.3070201@huawei.com>
	 <20130312101555.GB30758@dhcp22.suse.cz>
	 <20130312110750.GC30758@dhcp22.suse.cz>
	 <20130312130504.GD30758@dhcp22.suse.cz> <1363102105.24558.4.camel@laptop>
	 <20130312154341.GB18852@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-12 at 08:43 -0700, Greg Kroah-Hartman wrote:
> On Tue, Mar 12, 2013 at 04:28:25PM +0100, Peter Zijlstra wrote:
> > On Tue, 2013-03-12 at 14:05 +0100, Michal Hocko wrote:
> > > @@ -111,17 +111,17 @@ struct bus_type {
> > >         struct iommu_ops *iommu_ops;
> > >  
> > >         struct subsys_private *p;
> > > +       struct lock_class_key __key;
> > >  };
> > 
> > Is struct bus_type constrained to static storage or can people go an
> > allocate this stuff dynamically? If so, this patch is broken.
> 
> I don't think anyone is creating this dynamically, it should be static.
> Why does this matter, does the lockdep code care about where the
> variable is declared (heap vs. static)?

Yeah, lockdep needs keys to be in static storage since its data
structures are append-only. Dynamic stuff would require being able to
remove everything related to a key so that we can re-purpose it for the
next allocation etc.

Lockdep will in fact warn (and disable itself) if you try and feed it
dynamic addresses, so using it like this will effectively check your
bus_type static storage 'requirement'.

