Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbaESJbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbaESJbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:31:36 -0400
Date: Mon, 19 May 2014 11:30:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Sharp <dhsharp@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, namhyung@kernel.org
Subject: Re: perf: TRACING_DATA header.size is invalid
Message-ID: <20140519093058.GB2089@krava.brq.redhat.com>
References: <CAJL_eksGD+-8it08wOrKtFsXovk0Bz7OoxtqiJbTBacOr7xpyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJL_eksGD+-8it08wOrKtFsXovk0Bz7OoxtqiJbTBacOr7xpyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:40:23PM -0700, David Sharp wrote:
> We ran into an issue recently where a parser we have for perf.data
> could not handle TRACING_DATA events. It has a default behaviour of
> skipping event types it does not understand by using the header.size,
> since that seems to be how perf.data files are formatted.
> 
> However, for TRACING_DATA events, header.size is set to
> sizeof(ev.tracing_data), even though all of the tracing data
> immediately follows the event.
> 
> The simple fix would seem to be to set header.size to the size of the
> tracing data (plus sizeof ev.tracing_data). However, header.size is
> only 16 bits, and I imagine TRACING_DATA often exceeds UINT16_MAX,
> which is probably why the (u32) size was added outside the header.

yep, you're right..

(gdb) p event->tracing_data
$5 = {header = {type = 66, misc = 0, size = 12}, size = 4563912}

> 
> So I'm not sure we can fix this for real.
> 
> But, I do have an idea to mitigate damage: set header.size to zero.
> This will cause one of a few things to happen to a parser that doesn't
> understand TRACING_DATA events:
> - Ideally: It will realize that a zero size is nonsense and bail.
> - It will try to advance by zero bytes and enter an infinite loop
> (this happened to our parser after it skipped around some bogus data
> and happened upon some data that had zero where size would be). I
> argue this is better than reading garbage.
> - I can also imagine an implementation that read()s only
> sizeof(header), then extends the read() by (header.size -
> sizeof(header)) additional bytes, and this would end up overflowing
> the unsigned values, and that could also cause bugs, but hopefully by
> reading to EOF.

so in a current perf.data parser we have following code:

        if ((skip = perf_session__process_event(session, event, tool, head)) < 0) {
                pr_err("%#" PRIx64 " [%#x]: failed to process type: %d\n",
                       head, event->header.size, event->header.type);
                err = -EINVAL;
                goto out_err;
        }

        head += size;

        if (skip > 0)
                head += skip;


so skip is added to the header->size if needed.. and this skip makes
sure we could handle this case, because the TRACING_DATA handler
perf_event__process_tracing_data returns this number

> 
> Any better ideas?
> 
> A more difficult solution would be to split TRACING_DATA into
> UINT16_MAX-sized chunks, but would this needlessly break older readers
> of data produced by newer perf, even if they already know how to read
> TRACING_DATA correctly?

hm, I understand the solution we have is not very nice (generic enough)

so given that PERF_RECORD_HEADER_TRACING_DATA for pipe mode is now
'broken' anyway, I guess we could introduce PERF_RECORD_HEADER_TRACING_DATA2,
which would break down the tracing data into UINT16_MAX-sized chunks
and its related process report callback would be able to handle that

jirka
