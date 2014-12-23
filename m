Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaLWJzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:55:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaLWJzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:55:44 -0500
Date: Tue, 23 Dec 2014 10:55:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 1/4] tools/perf: support parsing parameterized events
Message-ID: <20141223095506.GB22265@krava.brq.redhat.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141222143710.GA29096@krava.brq.redhat.com>
 <20141222193045.GA19784@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222193045.GA19784@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:30:45AM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Sun, Dec 21, 2014 at 11:49:24PM -0800, Sukadev Bhattiprolu wrote:
> | 
> | SNIP
> | 
> | > +	}
> | >  
> | >  	switch (format->value) {
> | >  	case PERF_PMU_FORMAT_VALUE_CONFIG:
> | > @@ -592,11 +629,16 @@ static int pmu_config_term(struct list_head *formats,
> | >  	}
> | >  
> | >  	/*
> | > -	 * XXX If we ever decide to go with string values for
> | > -	 * non-hardcoded terms, here's the place to translate
> | > -	 * them into value.
> | > +	 * Either directly use a numeric term, or try to translate string terms
> | > +	 * using event parameters.
> | >  	 */
> | > -	pmu_format_value(format->bits, term->val.num, vp, zero);
> | > +	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
> | > +		val = term->val.num;
> | > +	else
> | > +		if (pmu_resolve_param_term(term, head_terms, &val))
> | > +			return -EINVAL;
> | > +
> | 
> | I'm ok with the change logic, but I'm missing here check for the 'term'
> | string value to be '?', so we force subst terms to have '?' as value..
> | I believe thats what we decided in the previous set discussion, right?
> 
> The =? is not a user input, so I did not think of validating that.
> 
> perf tool expects kernel/sysfs to show entries like 'core=?'. Are you
> saying that we should error out if kernel mistakenly displays 'core=$val'
> or 'core=?val' ? 

I think the we should at least try to have interface unambiguous
from the beginning

> If a required parameter is missing, we catch that in pmu_resolve_param_term().
> If a bogus parameter is specified we catch that above in pmu_config_term().

but the value of that param is unspecified, and if we later want to
add another type of string values we would be screwed.. as I described
in the previous reply for your other patch.

jirka
