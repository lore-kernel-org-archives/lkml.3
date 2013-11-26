Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab3KZN5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:57:16 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:39677 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3KZN5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:57:15 -0500
Date: Tue, 26 Nov 2013 10:57:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131126135709.GB14838@ghostprotocols.net>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
 <20131126110536.GC3388@stfomichev-desktop>
 <20131126121026.GD27323@ghostprotocols.net>
 <20131126134755.GD3388@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126134755.GD3388@stfomichev-desktop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 26, 2013 at 05:47:55PM +0400, Stanislav Fomichev escreveu:
> > Se above, if before this patch the format_field info was obtained from
> > the perf.data file, why should it now get it from the local machine?

> Yes, sorry for confusion, I didn't know that we can obtain trace events
> format from the perf.data. I hence have no concerns regarding your
> implementation :-)
> 
> > Please try. There should be no limitations.

> It does not work because lock_depth and common_pid are common fields,
> while perf_evsel__field looks in non-common fields. And even if we find

Oh, I thought they were linked, my bad, so that makes the implementation
even easier :-)

> lock_depth/common_pid common field we can't do field->next, because
> common and non-common fields are not linked and ->next in the last common
> field is NULL (this is what I got when I tried to use pevent_find_any_field
> instead of pevent_find_field in perf_evsel__field).
> 
> I slightly modified timechart__set_payload_offset from you patch to look
> for the first non-common field and use its offset, but it looks kinda ugly:
> 
> static int timechart__set_payload_offset(struct perf_evlist *evlist)
> {
>        struct perf_evsel *evsel = perf_evlist__first(evlist);
>        struct format_field *field = evsel->tp_format->format.fields;
> 
>        if (!field)
>                return -1;
> 
>        payload_offset = field->offset;
>        return 0;
> }
> 
> Maybe we can add some helper routine which returns first non-common
> field, like:

Humm, I think the above is enough but then having a a helper doesn't
hurt, but I would prefer it to instead be:

struct format_field *perf_evsel__fields(struct perf_evsel *evsel)
{
	return evsel->tp_format->format.fields;
}

The "name" parameter is not needed, and in essence getting "all the
fields" and the "first field" is the same operation, right? We can use
the shorter form.

In the evlist class we need this:

static inline
struct perf_evsel *perf_evlist__first(struct perf_evlist *evlist)
{
        return list_entry(evlist->entries.next, struct perf_evsel, node);
}

Because the open coded equivalent is long, as we use list_head to
maintain that list, but format.fields is a singly linked list.

Can you send a respinned patch with all we discussed, please?

- Arnaldo

> 
> struct format_field *perf_evsel__first_field(struct perf_evsel *evsel, const char *name)
> {
> 	return evsel->tp_format->format.fields;
> }
> 
> and call it in timechart__set_payload_offset?
