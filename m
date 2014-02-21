Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaBUCqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:46:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaBUCp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:45:59 -0500
Date: Thu, 20 Feb 2014 21:45:53 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 09/21] perf, c2c: Add rbtree sorted on mmap2 data
Message-ID: <20140221024553.GZ25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-10-git-send-email-dzickus@redhat.com>
 <20140218130405.GI4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218130405.GI4343@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:04:05PM +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 12:29:04PM -0500, Don Zickus wrote:
> > In order for the c2c tool to work correctly, it needs to properly
> > sort all the records on uniquely identifiable data addresses.  These
> > unique addresses are converted from virtual addresses provided by the
> > hardware into a kernel address using an mmap2 record as the decoder.
> > 
> 
> SNIP
> 
> > +static int physid_cmp(struct c2c_entry *left, struct c2c_entry *right)
> > +{
> > +	u64 l, r;
> > +	struct map *l_map = left->mi->daddr.map;
> > +	struct map *r_map = right->mi->daddr.map;
> > +
> > +	/* group event types together */
> > +	if (left->cpumode > right->cpumode) return 1;
> > +	if (left->cpumode < right->cpumode) return -1;
> > +
> > +	if (l_map->maj > r_map->maj) return 1;
> > +	if (l_map->maj < r_map->maj) return -1;
> > +
> > +	if (l_map->min > r_map->min) return 1;
> > +	if (l_map->min < r_map->min) return -1;
> > +
> > +	if (l_map->ino > r_map->ino) return 1;
> > +	if (l_map->ino < r_map->ino) return -1;
> > +
> > +	if (l_map->ino_generation > r_map->ino_generation) return 1;
> > +	if (l_map->ino_generation < r_map->ino_generation) return -1;
> > +
> > +	/*
> > +	 * Addresses with no major/minor numbers are assumed to be
> > +	 * anonymous in userspace.  Sort those on pid then address.
> > +	 *
> > +	 * The kernel and non-zero major/minor mapped areas are
> > +	 * assumed to be unity mapped.  Sort those on address then pid.
> > +	 */
> > +
> > +	/* al_addr does all the right addr - start + offset calculations */
> > +	l = left->mi->daddr.al_addr;
> > +	r = right->mi->daddr.al_addr;
> > +
> > +	if (l_map->maj || l_map->min) {
> > +		/* mmapped areas */
> > +
> > +		/* hack to mark similar regions, 'right' is new entry */
> > +		/* entries with same maj/min/ino/inogen are in same address space */
> > +		right->color = REGION_SAME;
> > +
> > +		if (l > r) return 1;
> > +		if (l < r) return -1;
> > +
> > +		/* sorting by iaddr makes calculations easier later */
> > +		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
> > +		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
> > +
> > +		if (left->thread->pid_ > right->thread->pid_) return 1;
> > +		if (left->thread->pid_ < right->thread->pid_) return -1;
> > +
> > +		if (left->thread->tid > right->thread->tid) return 1;
> > +		if (left->thread->tid < right->thread->tid) return -1;
> > +	} else if (left->cpumode == PERF_RECORD_MISC_KERNEL) {
> > +		/* kernel mapped areas where 'start' doesn't matter */
> > +
> > +		/* hack to mark similar regions, 'right' is new entry */
> > +		/* whole kernel region is in the same address space */
> > +		right->color = REGION_SAME;
> > +
> > +		if (l > r) return 1;
> > +		if (l < r) return -1;
> > +
> > +		/* sorting by iaddr makes calculations easier later */
> > +		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
> > +		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
> > +
> > +		if (left->thread->pid_ > right->thread->pid_) return 1;
> > +		if (left->thread->pid_ < right->thread->pid_) return -1;
> > +
> > +		if (left->thread->tid > right->thread->tid) return 1;
> > +		if (left->thread->tid < right->thread->tid) return -1;
> > +	} else {
> > +		/* userspace anonymous */
> > +		if (left->thread->pid_ > right->thread->pid_) return 1;
> > +		if (left->thread->pid_ < right->thread->pid_) return -1;
> > +
> > +		if (left->thread->tid > right->thread->tid) return 1;
> > +		if (left->thread->tid < right->thread->tid) return -1;
> > +
> > +		/* hack to mark similar regions, 'right' is new entry */
> > +		/* userspace anonymous address space is contained within pid */
> > +		right->color = REGION_SAME;
> > +
> > +		if (l > r) return 1;
> > +		if (l < r) return -1;
> > +
> > +		/* sorting by iaddr makes calculations easier later */
> > +		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
> > +		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> there's sort object doing exatly this over hist_entry's
> 
> Is there any reason not to use hist_entries?

So looking over hist_entry, I realize, what do I gain?  I implemented it
and realized I had to add, 'cpumode', 'tid' and a 'private' field to
struct hist_entry.  Then because I have my own report implementation, I
still have to copy and paste a ton of stuff from builtin-report over to
here (including callchain support).

Not unless you are expecting me to add giant chunks of code to
builtin-report.c?

Cheers,
Don
