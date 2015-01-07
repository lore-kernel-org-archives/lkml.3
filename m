Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbbAGXml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:42:41 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:56258 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbAGXmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:42:40 -0500
Date: Wed, 7 Jan 2015 15:41:56 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 2/4] tools/perf: extend format_alias() to include
 event parameters
Message-ID: <20150107234156.GA9769@us.ibm.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-3-git-send-email-sukadev@linux.vnet.ibm.com>
 <20150106093910.GA24841@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106093910.GA24841@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010723-0029-0000-0000-000007066B51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:
| On Sun, Dec 21, 2014 at 11:49:25PM -0800, Sukadev Bhattiprolu wrote:
| > From: Cody P Schafer <cody@linux.vnet.ibm.com>
| > 
| > This causes `perf list pmu` to show parameters for parameterized events
| > like:
| > 
| >   pmu/event_name,param1=?,param2=?/ [Kernel PMU event]
| > 
| > An example:
| > 
| >   hv_24x7/HPM_TLBIE__PHYS_CORE,core=?/ [Kernel PMU event]
| > 
| > Changelog[v6]
| > 	[Jir Olsa, Sukadev Bhattiprolu] Drop the '$' sign and go back to
| > 	just printing whatevever sysfs provides (which is '=?') to identify
| > 	required parameters. sysfs also now uses parameters like 'core'
| > 	and 'vcpu' rather than 'starting_index'.
| > 
| > Changelog[v5]
| > 	[Jiri Olsa, Peter Zijlstra] Use '$' to prefix parameterized events.
| > 
| > Changelog[v4]
| > 	[Jiri Olsa] If the parameter for an event in sysfs is 'param=val',
| > 	have perf-list show the event as 'param=?' rather than 'val=?'.
| > 
| > CC: Haren Myneni <hbabu@us.ibm.com>
| > CC: Cody P Schafer <dev@codyps.com>
| > Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
| > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > ---
| >  tools/perf/util/pmu.c | 27 ++++++++++++++++++++++++++-
| >  1 file changed, 26 insertions(+), 1 deletion(-)
| > 
| > diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
| > index cb516dd..d208fef 100644
| > --- a/tools/perf/util/pmu.c
| > +++ b/tools/perf/util/pmu.c
| > @@ -810,10 +810,35 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
| >  		set_bit(b, bits);
| >  }
| >  
| > +static int sub_non_neg(int a, int b)
| > +{
| > +	if (b > a)
| > +		return 0;
| > +	return a - b;
| > +}
| > +
| >  static char *format_alias(char *buf, int len, struct perf_pmu *pmu,
| >  			  struct perf_pmu_alias *alias)
| >  {
| > -	snprintf(buf, len, "%s/%s/", pmu->name, alias->name);
| > +	struct parse_events_term *term;
| > +	int used = snprintf(buf, len, "%s/%s", pmu->name, alias->name);
| > +
| > +	list_for_each_entry(term, &alias->terms, list)
| > +		if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
| > +			used += snprintf(buf + used, sub_non_neg(len, used),
| > +					",%s=%s", term->config,
| > +					term->val.str);
| 
| why not display PARSE_EVENTS__TERM_TYPE_NUM as well?

Well, we are only trying to list the attributes that user needs to specify:

	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,core=?/

We could print the PARSE_EVENTS__TERM_TYPE_NUM terms as well,

	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,domain=2,offset=e0,core=?,lpar=0/

but it would be needlessly verbose. The attributes with numeric values
like domain and offset, have fixed values for the event and user doesn't
need to know. If they do really need to know, they could just look up in
sysfs ?

Sukadev

