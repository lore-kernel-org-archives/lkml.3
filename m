Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaHLIJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:09:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53959 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaHLIJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:09:19 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [BUG] perf top: -z option does not work
References: <CABPqkBRqqz6dEYuFvJL4M+p2h-m0P09h4fDVq6-f8fZJq6NSCA@mail.gmail.com>
Date: Tue, 12 Aug 2014 17:09:17 +0900
In-Reply-To: <CABPqkBRqqz6dEYuFvJL4M+p2h-m0P09h4fDVq6-f8fZJq6NSCA@mail.gmail.com>
	(Stephane Eranian's message of "Tue, 12 Aug 2014 06:44:34 +0200")
Message-ID: <878umuf7te.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Tue, 12 Aug 2014 06:44:34 +0200, Stephane Eranian wrote:
> Hi,
>
>
> My understanding is that the -z option is used to only print a profile
> since the last refresh. So if I have a refresh of 5s, then it prints the profile
> based on the samples accumulated over the last 5 seconds.

Yep, that's what I understand about the -z behavior too.

>
> The Z mode used to be available interactively. Nowadays, it seems only
> avail from the cmdline. But it does not work.

Hmm.. it seems the stdio supports 'z' key but TUI don't.

>
> I run a simple test.
> $ sudo perf top -z
>
> Then for 5s I run a cycle-burning noploop program.
> It shows up at the top. But when it terminates, the program  still stays
> at the top of the profile for a long time. This is not what I'd expect.
> The noploop line should disappear in the next couple of refreshes after
> the program has terminated.
>
> I am using tip.git and seeing the problem. But it seems, it's been there for a
> long time.
>
> Any idea what's wrong?

Looking at the code, it only zero out the annotation info but hist
entries.  I guess we need to check the flag and throw out existing
entries instead of decaying.

Also I wonder about the order of decaying - shouldn't it be decayed
before processing current entries?  It seems current code processes
current entries first and then decays...

I'll prepare patches for this soon.

Thanks,
Namhyung
