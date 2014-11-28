Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaK1Jnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:43:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaK1Jns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:43:48 -0500
Date: Fri, 28 Nov 2014 10:43:42 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "acme@kernel.org" <acme@kernel.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V5 3/3] perf tool: check buildid for symoff
Message-ID: <20141128094341.GA27703@krava.brq.redhat.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
 <1416844829-26945-3-git-send-email-kan.liang@intel.com>
 <20141125115159.GE30861@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167680F@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770167680F@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 04:10:51PM +0000, Liang, Kan wrote:
> 
> > 
> > On Mon, Nov 24, 2014 at 11:00:29AM -0500, Kan Liang wrote:
> > > From: Kan Liang <kan.liang@intel.com>
> > >
> > > symoff can support both same binaries and different binaries. However,
> > > the offset may be changed for different binaries. This patch checks
> > > the buildid of perf.data. If they are from different binaries, print a
> > > warning to notify the user.
> > >
> > > Signed-off-by: Kan Liang <kan.liang@intel.com>
> > > ---
> > >  tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++++
> > >  tools/perf/util/sort.c    |  3 +++
> > >  tools/perf/util/sort.h    |  1 +
> > >  3 files changed, 29 insertions(+)
> > >
> > > diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> > > index 03a4001..2a8c17a 100644
> > > --- a/tools/perf/builtin-diff.c
> > > +++ b/tools/perf/builtin-diff.c
> > > @@ -678,6 +678,28 @@ static void data__free(struct data__file *d)
> > >  	}
> > >  }
> > >
> > > +static void buildid_check(void)
> > > +{
> > > +	struct dsos *base_k_dsos = &data__files[0].session-
> > >machines.host.kernel_dsos;
> > > +	struct dsos *base_u_dsos = &data__files[0].session-
> > >machines.host.user_dsos;
> > > +	struct dsos *k_dsos_tmp, *u_dsos_tmp;
> > > +	struct data__file *d;
> > > +	int i;
> > > +
> > > +	data__for_each_file_new(i, d) {
> > > +		k_dsos_tmp = &d->session->machines.host.kernel_dsos;
> > > +		u_dsos_tmp = &d->session->machines.host.user_dsos;
> > > +
> > > +		if (!dsos__build_ids_equal(base_k_dsos, k_dsos_tmp))
> > > +			pr_warning("The perf.data come from different
> > kernel. "
> > > +				   "The kernel symbol offset may vary for
> > different kernel.\n");
> > > +
> > > +		if (!dsos__build_ids_equal(base_u_dsos, u_dsos_tmp))
> > > +			pr_warning("The perf.data come from different
> > user binary. "
> > > +				   "The user space symbol offset may vary
> > for different
> > > +binaries.\n");
> > 
> > we dont specify the kernel version or dso path in the warning message,
> > maybe we want to print it out just once? In case there's more than 2 not
> > matching data?
>  
> Could we print the header instead? It should be more informative. 
> Maybe we can print it with --verbose.

IMO one (WARN_ONCE style) warning by default if we see
buildids discrepancy and detailed comparison for --verbose

jirka
