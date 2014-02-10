Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaBJMjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:39:05 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:62894 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaBJMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:39:03 -0500
Date: Mon, 10 Feb 2014 09:38:56 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tony Lu <zlu@tilera.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] perf tools: Fix the logic of thread__fork
Message-ID: <20140210123856.GA20833@ghostprotocols.net>
References: <BAB94DBB0E89D8409949BC28AC95914C5D67EA30@USMAExch1.tad.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAB94DBB0E89D8409949BC28AC95914C5D67EA30@USMAExch1.tad.internal.tilera.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 10, 2014 at 04:21:23AM +0000, Tony Lu escreveu:
> Revert the logic of checking the return value of thread__set_comm().
> 
> If thread__set_comm() returns zero without errors, we should not return
> immediately, instead we should finish the rest of the clone work.
> Otherwise, perf report would fail to resolve symbols sampled in forked
> threads.

You should mention against which tree your patch is supposed to be
applied, in this case a fix was made in december:

[acme@ssdandy linux]$ git show 8d00be815c05ed0f0202f606bab4e54f98fd3b30
commit 8d00be815c05ed0f0202f606bab4e54f98fd3b30
Author: David Ahern <dsahern@gmail.com>
Date:   Tue Dec 10 21:35:38 2013 -0700

    perf tools: Fix inverted error verification bug in thread__fork
    
    Commit 1902efe7f for the new comm infra added the wrong check for return
    code on thread__set_comm. err == 0 is normal, so don't return at that
    point unless err != 0.
    
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Link: http://lkml.kernel.org/r/1386736538-23525-1-git-send-email-dsahern@gmail.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Signed-off-by: Zhigang Lu <zlu@tilera.com>
> ---
>  tools/perf/util/thread.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index 49eaf1d..e394861 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -126,7 +126,7 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
>  		if (!comm)
>  			return -ENOMEM;
>  		err = thread__set_comm(thread, comm, timestamp);
> -		if (!err)
> +		if (err)
>  			return err;
>  		thread->comm_set = true;
>  	}
> -- 
> 1.7.1
