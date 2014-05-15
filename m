Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaEOLno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 07:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbaEOLnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 07:43:42 -0400
Date: Thu, 15 May 2014 13:43:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 04/20] perf tools: Support event grouping in hpp ->sort()
Message-ID: <20140515114315.GB4009@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:37PM +0900, Namhyung Kim wrote:

SNIP

> +static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
> +		       hpp_field_fn get_field)
> +{
> +	s64 ret;
> +	int i, nr_members;
> +	struct perf_evsel *evsel;
> +	struct hist_entry *pair;
> +	u64 *fields_a, *fields_b;
> +
> +	ret = field_cmp(get_field(a), get_field(b));
> +	if (ret || !symbol_conf.event_group)
> +		return ret;
> +
> +	evsel = hists_to_evsel(a->hists);
> +	if (!perf_evsel__is_group_event(evsel))
> +		return ret;
> +
> +	nr_members = evsel->nr_members;
> +	fields_a = calloc(sizeof(*fields_a), nr_members);
> +	fields_b = calloc(sizeof(*fields_b), nr_members);
> +
> +	if (!fields_a || !fields_b)
> +		goto out;
> +
> +	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
> +		evsel = hists_to_evsel(pair->hists);
> +		fields_a[perf_evsel__group_idx(evsel)] = get_field(pair);
> +	}
> +
> +	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
> +		evsel = hists_to_evsel(pair->hists);
> +		fields_b[perf_evsel__group_idx(evsel)] = get_field(pair);
> +	}
> +
> +	for (i = 1; i < nr_members; i++) {
> +		ret = fields_a[i] - fields_b[i];

should we call here ^^^call  field_cmp ?

jirka
