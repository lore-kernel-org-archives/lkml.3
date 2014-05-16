Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaEPXkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:40:45 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41566 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaEPXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:40:44 -0400
MIME-Version: 1.0
From: David Sharp <dhsharp@google.com>
Date: Fri, 16 May 2014 16:40:23 -0700
Message-ID: <CAJL_eksGD+-8it08wOrKtFsXovk0Bz7OoxtqiJbTBacOr7xpyw@mail.gmail.com>
Subject: perf: TRACING_DATA header.size is invalid
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Tom Zanussi <tzanussi@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, namhyung@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ran into an issue recently where a parser we have for perf.data
could not handle TRACING_DATA events. It has a default behaviour of
skipping event types it does not understand by using the header.size,
since that seems to be how perf.data files are formatted.

However, for TRACING_DATA events, header.size is set to
sizeof(ev.tracing_data), even though all of the tracing data
immediately follows the event.

The simple fix would seem to be to set header.size to the size of the
tracing data (plus sizeof ev.tracing_data). However, header.size is
only 16 bits, and I imagine TRACING_DATA often exceeds UINT16_MAX,
which is probably why the (u32) size was added outside the header.

So I'm not sure we can fix this for real.

But, I do have an idea to mitigate damage: set header.size to zero.
This will cause one of a few things to happen to a parser that doesn't
understand TRACING_DATA events:
- Ideally: It will realize that a zero size is nonsense and bail.
- It will try to advance by zero bytes and enter an infinite loop
(this happened to our parser after it skipped around some bogus data
and happened upon some data that had zero where size would be). I
argue this is better than reading garbage.
- I can also imagine an implementation that read()s only
sizeof(header), then extends the read() by (header.size -
sizeof(header)) additional bytes, and this would end up overflowing
the unsigned values, and that could also cause bugs, but hopefully by
reading to EOF.

Any better ideas?

A more difficult solution would be to split TRACING_DATA into
UINT16_MAX-sized chunks, but would this needlessly break older readers
of data produced by newer perf, even if they already know how to read
TRACING_DATA correctly?

Thanks,
d#
