Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaLVOhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:37:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbaLVOhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:37:53 -0500
Date: Mon, 22 Dec 2014 15:37:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 1/4] tools/perf: support parsing parameterized events
Message-ID: <20141222143710.GA29096@krava.brq.redhat.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234567-22784-2-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419234567-22784-2-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:49:24PM -0800, Sukadev Bhattiprolu wrote:

SNIP

> +	}
>  
>  	switch (format->value) {
>  	case PERF_PMU_FORMAT_VALUE_CONFIG:
> @@ -592,11 +629,16 @@ static int pmu_config_term(struct list_head *formats,
>  	}
>  
>  	/*
> -	 * XXX If we ever decide to go with string values for
> -	 * non-hardcoded terms, here's the place to translate
> -	 * them into value.
> +	 * Either directly use a numeric term, or try to translate string terms
> +	 * using event parameters.
>  	 */
> -	pmu_format_value(format->bits, term->val.num, vp, zero);
> +	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
> +		val = term->val.num;
> +	else
> +		if (pmu_resolve_param_term(term, head_terms, &val))
> +			return -EINVAL;
> +

I'm ok with the change logic, but I'm missing here check for the 'term'
string value to be '?', so we force subst terms to have '?' as value..
I believe thats what we decided in the previous set discussion, right?

I guess the it'd be nice to parse it directly in the bison code like
below (could be done later), but I'd be ok with simple check on this
place for now.

thanks,
jirka


---
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 93c4c9fbc922..7e021c64d5cc 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -484,6 +484,14 @@ PE_TERM '=' PE_VALUE
 	$$ = term;
 }
 |
+PE_TERM '=' PE_SUBST
+{
+	struct parse_events_term *term;
+
+	ABORT_ON(parse_events_term__subst(&term, (int)$1, NULL, NULL));
+	$$ = term;
+}
+|
 PE_TERM
 {
 	struct parse_events_term *term;
