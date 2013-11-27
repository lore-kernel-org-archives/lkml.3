Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3K0Oly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:41:54 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:59434 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3K0Olv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:41:51 -0500
Date: Wed, 27 Nov 2013 11:41:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Chia-I Wu <olvaffe@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf timechart: dynamically determine event data offset
Message-ID: <20131127144144.GB11498@ghostprotocols.net>
References: <20131022103223.GA29489@stfomichev-desktop>
 <20131125182139.GD20168@ghostprotocols.net>
 <20131126110536.GC3388@stfomichev-desktop>
 <20131126121026.GD27323@ghostprotocols.net>
 <20131126134755.GD3388@stfomichev-desktop>
 <20131126135709.GB14838@ghostprotocols.net>
 <20131126145437.GE3388@stfomichev-desktop>
 <87mwkqqlfl.fsf@sejong.aot.lge.com>
 <20131127134434.GA11498@ghostprotocols.net>
 <1385561863.1685.30.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385561863.1685.30.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 27, 2013 at 11:17:43PM +0900, Namhyung Kim escreveu:
> 2013-11-27 (수), 10:44 -0300, Arnaldo Carvalho de Melo:
> > Same signature, 32-bit, 64-bit userland, so whoever wrote timechart, Arjan, I
> > think, made no mistakes at using the kernel exported interface, choosing the
> > most efficient way to extract the data, casting to a struct.

> > Yeah, using the interface that searches for a field name to get the offset and
> > then add it to a pointer to then cast to the type will allow maximum flexibility,
> > but is not really efficient.

> > Doing that for something that is not performance critical (probably) as
> > timechart probably is not a problem, but so is not a problem using the patch
> > that does the cast after finding the offset of the first non-common field.
 
> I'm not sure how it affects the performance really.

Hey, everytime we need to get the value of a field when processing each
tracepoint sample we need to do it via:

struct format_field *pevent_find_field(struct event_format *event, const char *name)
{
        struct format_field *format;

        for (format = event->format.fields; format; format = format->next) {
                if (strcmp(format->name, name) == 0)
                        break;
        }

        return format;
}

I don't think this is optimal, no.

But yeah, for things that don't have performance needs, don't process that many
samples and hey, machines are fast and cheap these days ;-)

> But in most cases, using the libtraceevent would be a better solution IMHO.

It is the one that gives the most flexibily to change the kernel exported
tracepoint interface at will, yes.
 
> > Having said that, I'll take the latest patch, using perf_evsel__intval et all,
> > if Namhyung sees no further problems with it.
 
> Okay, after a quick glance I don't see anymore issue.  You can add my
> Ack there.

Ok, thanks for checking!

- Arnaldo
