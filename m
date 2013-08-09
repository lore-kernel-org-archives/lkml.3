Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967881Ab3HINxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:53:19 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:47212 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967825Ab3HINxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:53:18 -0400
Date: Fri, 9 Aug 2013 10:53:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/19] perf top: Use new idle_sym check
Message-ID: <20130809135308.GA2104@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-8-git-send-email-dsahern@gmail.com>
 <20130808150647.GB6102@ghostprotocols.net>
 <520458B4.90003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520458B4.90003@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 08, 2013 at 10:49:24PM -0400, David Ahern escreveu:
> On 8/8/13 11:06 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, Aug 07, 2013 at 10:50:49PM -0400, David Ahern escreveu:
> >>Avoids strcmp processing each sample.
> >
> >How so? This is done just when loading a DSO, when then each symbol is
> >checked against this list.
> 
> hmmm.... see that now, yes. The timehist command wants to know idle
> times, not just filter them out like perf-top does.

'perf top' shouldn't just discard idle symbols, but group them in a
special hist_entry, that should be displayed at the top, etc, but this
is another issue, what matters here is that it doesn't "filters" in the
sense of symbol_filter_t, it returns 0 if the symbol name matches one of
the entries in that skip_list, which marks symbol->ignore, but it is
still in the rb_tree. Being "discarded" only later, when processing the
sample.

The only thing it really filters out are these symtab entries:
 
        if (!strcmp(name, "_text") ||
            !strcmp(name, "_etext") ||
            !strcmp(name, "_sinittext") ||
            !strncmp("init_module", name, 11) ||
            !strncmp("cleanup_module", name, 14) ||
            strstr(name, "_text_start") ||
            strstr(name, "_text_end"))
                return 1;

Those I think could be pruned somehow in dso__load_{kallsyms|kernel}*(),
like some other symbols are already (SyS_).

With this in mind, would using the same scheme Ok for you?

- Arnaldo
