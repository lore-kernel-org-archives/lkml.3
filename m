Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaJNQut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:50:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbaJNQur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:50:47 -0400
Date: Tue, 14 Oct 2014 12:50:27 -0400
From: Dave Jones <davej@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix-fix.patch
Message-ID: <20141014165027.GA26886@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michal Hocko <mhocko@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Sasha Levin <sasha.levin@oracle.com>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
 <1411464279-20158-1-git-send-email-mhocko@suse.cz>
 <20140923112848.GA10046@dhcp22.suse.cz>
 <20140923201204.GB4252@redhat.com>
 <20141013185156.GA1959@redhat.com>
 <20141014115554.GB8727@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014115554.GB8727@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 01:55:54PM +0200, Michal Hocko wrote:

 > > -#ifdef CONFIG_NUMA_BALANCING
 > > -		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
 > > -#endif
 > > -#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_COMPACTION)
 > > -		"tlb_flush_pending %d\n"
 > > -#endif
 > > -		"%s",	/* This is here to hold the comma */
 > > +	char *p = dumpmm_buffer;
 > > +
 > > +	memset(dumpmm_buffer, 0, 4096);
 > 
 > I do not see any locking here. Previously we had internal printk log as
 > a natural synchronization. Now two threads are allowed to scribble over
 > their messages leaving an unusable output in a better case.

That's why I asked in the part of the mail you didn't quote whether
we cared if it wasn't reentrant.  Ok we do. That's 3 lines of change to
add a lock.

 > Besides that the %s with "" trick is not really that ugly and handles
 > the situation quite nicely. So do we really want to make it more
 > complicated?

That hack goes away entirely with this diff.  And by keeping the
parameters with the format string they're associated with, it should be
more maintainable should we decide to add more fields to be output in the future.
The number of ifdefs in the function are halved (which becomes even
bigger deal if we do add more output).

We saw how many times we had to go around to get it right this time.
In its current incarnation, it looks like a matter of time before
someone screws it up again due to missing some CONFIG combination.

	Dave

