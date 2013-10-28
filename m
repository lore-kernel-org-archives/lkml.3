Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3J1MeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:34:21 -0400
Received: from mail-gg0-f171.google.com ([209.85.161.171]:63196 "EHLO
	mail-gg0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3J1MeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:34:20 -0400
Date: Mon, 28 Oct 2013 09:34:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131028123411.GB16948@ghostprotocols.net>
References: <20131026122414.GA25026@gmail.com>
 <20131028082848.GA276@x4>
 <20131028090236.GA274@x4>
 <20131028093430.GB274@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028093430.GB274@x4>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 28, 2013 at 10:34:30AM +0100, Markus Trippelsdorf escreveu:
> On 2013.10.28 at 10:02 +0100, Markus Trippelsdorf wrote:
> > On 2013.10.28 at 09:28 +0100, Markus Trippelsdorf wrote:
> > > On 2013.10.26 at 14:24 +0200, Ingo Molnar wrote:
> > > >  - Reversal of the new 'MMAP2' extended mmap record ABI, introduced 

> > > commit 3090ffb5a2515990182f3f55b0688a7817325488
> > > Author: Stephane Eranian <eranian@google.com>

> > >     perf: Disable PERF_RECORD_MMAP2 support

> The following patch fixes the issue:
 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>  		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
> -		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
> +		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
>  		       &event->mmap.start, &event->mmap.len, prot,
>  		       &event->mmap.pgoff,
>  		       execname);
  
> -		if (n != 8)
> -			continue;
> -

Yeah, this one was added in the patch that introduced MMAP2 support in
the tooling side, it was unrelated to what the patch needed, i.e. should
have come in a separate patch, checking sscanf number of itens
successfully matched/assigned.

And then, when reverting it, Stephane forgot to match the number number
of expected entries to be matched/assigned from 8 to 5, can you try with
the following patch instead?

- Arnaldo

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 63df031fc9c7..49096ea58a15 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -213,7 +213,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		       &event->mmap.pgoff,
 		       execname);
 
-		if (n != 8)
+		if (n != 5)
 			continue;
 
 		if (prot[2] != 'x')
