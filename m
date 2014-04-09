Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbaDICRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:17:47 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61632 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbaDICRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:17:45 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 2/6] perf: Update mmap2 interface with protection and flag bits
References: <1395689676-214799-1-git-send-email-dzickus@redhat.com>
	<1395689676-214799-3-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 11:17:44 +0900
In-Reply-To: <1395689676-214799-3-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:34:32 -0400")
Message-ID: <871tx7utyv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:34:32 -0400, Don Zickus wrote:
> The kernel piece passes more info now.  Update the perf tool to reflect
> that and adjust the synthesized maps to play along.
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/event.c   | 23 +++++++++++++++++++++--
>  tools/perf/util/event.h   |  2 ++
>  tools/perf/util/machine.c |  4 +++-
>  tools/perf/util/map.c     |  4 +++-
>  tools/perf/util/map.h     |  4 +++-
>  5 files changed, 32 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 9d12aa6..6b8646c 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -1,4 +1,5 @@
>  #include <linux/types.h>
> +#include <sys/mman.h>
>  #include "event.h"
>  #include "debug.h"
>  #include "hist.h"
> @@ -212,6 +213,21 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  		else
>  			event->header.misc = PERF_RECORD_MISC_GUEST_USER;
>  
> +		/* map protection and flags bits */
> +		event->mmap2.prot = 0;
> +		event->mmap2.flags = 0;
> +		if (prot[0] == 'r')
> +			event->mmap2.prot |= PROT_READ;
> +		if (prot[1] == 'w')
> +			event->mmap2.prot |= PROT_WRITE;
> +		if (prot[2] == 'x')
> +			event->mmap2.prot |= PROT_EXEC;
> +
> +		if (prot[3] == 's')
> +			event->mmap2.flags |= MAP_SHARED;
> +		else
> +			event->mmap2.flags |= MAP_PRIVATE;
> +

So you need to synthesize a PERF_RECORD_MMAP2 event then.  The
mmap_event and mmap2_event shares same fields util ->pgoff only.  So
copying to mmap.filename will overwrite other bits in mmap2.

Thanks,
Namhyung
