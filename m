Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaBSCwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:52:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbaBSCwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:52:02 -0500
Date: Tue, 18 Feb 2014 21:51:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 10/21] perf, c2c: Add stats to track data source bits and
 cpu to node maps
Message-ID: <20140219025157.GN25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-11-git-send-email-dzickus@redhat.com>
 <20140218130530.GJ4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218130530.GJ4343@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:05:31PM +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 12:29:05PM -0500, Don Zickus wrote:
> > This patch adds a bunch of stats that will be used later in post-processing
> > to determine where and with what frequency the HITMs are coming from.
> > 
> > Most of the stats are decoded from the data source response.  Another
> > piece of the stats is tracking which cpu the record came in on.
> > 
> > In order to properly build a cpu map to map where interesting events are coming
> > from, I shamelessly copy-n-pasted the cpu->NUMA node code from builtin-kmem.c.
> > 
> > As HITMs are most expensive when going across NUMA nodes, it only made sense
> > to create a quick cpu->NUMA lookup for when processing the records.
> > 
> > Credit to Dick Fowles for determining which bits are important and how to
> > properly track them.  Ported to perf by me.
> > 
> > Original-by: Dick Fowles <rfowles@redhat.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> 
> SNIP
> 
> > +
> > +static int setup_cpunode_map(void)
> > +{
> > +	struct dirent *dent1, *dent2;
> > +	DIR *dir1, *dir2;
> > +	unsigned int cpu, mem;
> > +	char buf[PATH_MAX];
> > +
> > +	/* initialize globals */
> > +	if (init_cpunode_map())
> > +		return -1;
> > +
> > +	dir1 = opendir(PATH_SYS_NODE);
> > +	if (!dir1)
> > +		return 0;
> > +
> > +	/* walk tree and setup map */
> > +	while ((dent1 = readdir(dir1)) != NULL) {
> > +		if (dent1->d_type != DT_DIR ||
> > +		    sscanf(dent1->d_name, "node%u", &mem) < 1)
> > +			continue;
> > +
> > +		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
> > +		dir2 = opendir(buf);
> > +		if (!dir2)
> > +			continue;
> > +		while ((dent2 = readdir(dir2)) != NULL) {
> > +			if (dent2->d_type != DT_LNK ||
> > +			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
> > +				continue;
> > +			cpunode_map[cpu] = mem;
> > +		}
> > +		closedir(dir2);
> > +	}
> > +	closedir(dir1);
> > +	return 0;
> > +}
> 
> 
> There's already setup_cpunode_map interface in builtin-kmem.c
> Please make it global (maybe place in separate object?)
> and use this one.

Heh, where do you think I got this from? :-)  Though I did tweak it for my
needs, namely I used 'possible' cpus as opposed to 'online' cpus to deal
with hotplug.

I also ran into a bug here, where this code populating an array based on
what is on the running system, not the system where the data was
collected.  Is it possible to have perf-archive add this info?

I try to make this function global on the next version.

Cheers,
Don

> 
> jirka
