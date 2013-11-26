Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3KZNsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:48:06 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:47873 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab3KZNsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:48:04 -0500
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Tue, 26 Nov 2013 17:47:55 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: remove lock_depth from trace_entry
Message-ID: <20131126134755.GD3388@stfomichev-desktop>
References: <1381128514-16279-1-git-send-email-olvaffe@gmail.com>
 <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
 <20131126110536.GC3388@stfomichev-desktop>
 <20131126121026.GD27323@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126121026.GD27323@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Se above, if before this patch the format_field info was obtained from
> the perf.data file, why should it now get it from the local machine?
Yes, sorry for confusion, I didn't know that we can obtain trace events
format from the perf.data. I hence have no concerns regarding your
implementation :-)

> Please try. There should be no limitations.
It does not work because lock_depth and common_pid are common fields,
while perf_evsel__field looks in non-common fields. And even if we find
lock_depth/common_pid common field we can't do field->next, because
common and non-common fields are not linked and ->next in the last common
field is NULL (this is what I got when I tried to use pevent_find_any_field
instead of pevent_find_field in perf_evsel__field).

I slightly modified timechart__set_payload_offset from you patch to look
for the first non-common field and use its offset, but it looks kinda ugly:

static int timechart__set_payload_offset(struct perf_evlist *evlist)
{
       struct perf_evsel *evsel = perf_evlist__first(evlist);
       struct format_field *field = evsel->tp_format->format.fields;

       if (!field)
               return -1;

       payload_offset = field->offset;
       return 0;
}

Maybe we can add some helper routine which returns first non-common
field, like:

struct format_field *perf_evsel__first_field(struct perf_evsel *evsel, const char *name)
{
	return evsel->tp_format->format.fields;
}

and call it in timechart__set_payload_offset?
