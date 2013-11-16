Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3KPBCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:02:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61239 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KPBCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:02:12 -0500
Date: Sat, 16 Nov 2013 02:02:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf tip: fails to convert comm
Message-ID: <20131116010207.GA18855@localhost.localdomain>
References: <528306F5.8050307@gmail.com>
 <20131113180344.GA28039@localhost.localdomain>
 <52864BFF.20601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52864BFF.20601@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:29:51AM -0700, David Ahern wrote:
> HI Frederic:
> 
> On 11/13/13, 11:03 AM, Frederic Weisbecker wrote:
> >
> >I see. I can reproduce, I'll check and see what happens. It would be nice if
> >we could have an option to dump internal perf events like comm events as well
> >in the perf script stream.
> 
> Any progress on a solution? This is a regression in 3.13.

So the problem is that when a thread overrides its default ":%pid" comm, we forget
to tag the thread comm as overriden. Hence, this overriden comm is not inherited on
future forks.

So here is a fix. Tell me if you see more issue, I'll cook a proper changelog and
resend if everyting looks good.

Thanks.

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index cd8e2f5..49eaf1d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -70,14 +70,13 @@ int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
 		comm__override(curr, str, timestamp);
-		return 0;
+	} else {
+		new = comm__new(str, timestamp);
+		if (!new)
+			return -ENOMEM;
+		list_add(&new->list, &thread->comm_list);
 	}
 
-	new = comm__new(str, timestamp);
-	if (!new)
-		return -ENOMEM;
-
-	list_add(&new->list, &thread->comm_list);
 	thread->comm_set = true;
 
 	return 0;
