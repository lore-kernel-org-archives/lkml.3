Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBSC5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:57:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaBSC46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:56:58 -0500
Date: Tue, 18 Feb 2014 21:56:52 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 17/21] perf, c2c: Add symbol count table
Message-ID: <20140219025652.GP25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-18-git-send-email-dzickus@redhat.com>
 <20140218130929.GL4343@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218130929.GL4343@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:09:29PM +0100, Jiri Olsa wrote:
> On Mon, Feb 10, 2014 at 12:29:12PM -0500, Don Zickus wrote:
> > Just another table that displays the referenced symbols in the analysis
> > report.  The table lists the most frequently used symbols first.
> > 
> > It is just another way to look at similar data to figure out who
> > is causing the most contention (based on the workload used).
> > 
> > Originally done by Dick Fowles and ported by me.
> > 
> > Suggested-by: Joe Mario <jmario@redhat.com>
> > Original-by: Dick Fowles <rfowles@redhat.com>
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  tools/perf/builtin-c2c.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 99 insertions(+)
> > 
> > diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> > index 32c2319..979187f 100644
> > --- a/tools/perf/builtin-c2c.c
> > +++ b/tools/perf/builtin-c2c.c
> > @@ -950,6 +950,104 @@ static void c2c_hit__update_stats(struct c2c_stats *new,
> >  	new->total_period	+= old->total_period;
> >  }
> >  
> > +LIST_HEAD(ref_tree);
> > +LIST_HEAD(ref_tree_sorted);
> > +struct refs {
> > +	struct list_head	list;
> > +	int			nr;
> > +	const char		*name;
> > +	char			*long_name;
> > +};
> > +
> > +static int update_ref_tree(struct c2c_entry *entry)
> > +{
> > +	struct refs *p;
> > +	struct dso *dso = entry->mi->iaddr.map->dso;
> > +	const char *name = dso->short_name;
> > +
> > +	list_for_each_entry(p, &ref_tree, list) {
> > +		if (!strcmp(p->name, name))
> > +			goto found;
> > +	}
> > +
> > +	p = zalloc(sizeof(struct refs));
> > +	if (!p)
> > +		return -1;
> > +	p->name = name;
> > +	p->long_name = dso->long_name;
> > +	list_add_tail(&p->list, &ref_tree);
> 
> so this is a tree, which is actually a list ;-)

It used to be a tree, now it is a stick. :-)

Old code that needs to be renamed.  I can update that.

Cheers,
Don
