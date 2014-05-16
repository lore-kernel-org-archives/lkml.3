Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaEPGTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:19:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51308 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaEPGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:19:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 04/20] perf tools: Support event grouping in hpp ->sort()
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-5-git-send-email-namhyung@kernel.org>
	<20140515114315.GB4009@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:19:19 +0900
In-Reply-To: <20140515114315.GB4009@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 15 May 2014 13:43:15 +0200")
Message-ID: <87mweikzyw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 15 May 2014 13:43:15 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:37PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +static int __hpp__sort(struct hist_entry *a, struct hist_entry *b,
>> +		       hpp_field_fn get_field)
>> +{
>> +	s64 ret;
>> +	int i, nr_members;
>> +	struct perf_evsel *evsel;
>> +	struct hist_entry *pair;
>> +	u64 *fields_a, *fields_b;
>> +
>> +	ret = field_cmp(get_field(a), get_field(b));
>> +	if (ret || !symbol_conf.event_group)
>> +		return ret;
>> +
>> +	evsel = hists_to_evsel(a->hists);
>> +	if (!perf_evsel__is_group_event(evsel))
>> +		return ret;
>> +
>> +	nr_members = evsel->nr_members;
>> +	fields_a = calloc(sizeof(*fields_a), nr_members);
>> +	fields_b = calloc(sizeof(*fields_b), nr_members);
>> +
>> +	if (!fields_a || !fields_b)
>> +		goto out;
>> +
>> +	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
>> +		evsel = hists_to_evsel(pair->hists);
>> +		fields_a[perf_evsel__group_idx(evsel)] = get_field(pair);
>> +	}
>> +
>> +	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
>> +		evsel = hists_to_evsel(pair->hists);
>> +		fields_b[perf_evsel__group_idx(evsel)] = get_field(pair);
>> +	}
>> +
>> +	for (i = 1; i < nr_members; i++) {
>> +		ret = fields_a[i] - fields_b[i];
>
> should we call here ^^^call  field_cmp ?

Right!  Will fix.

Thanks,
Namhyung
