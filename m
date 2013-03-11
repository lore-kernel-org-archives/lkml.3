Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3CKKAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:00:00 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37650
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753751Ab3CKJ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:59:58 -0400
Message-ID: <1362995984.14933.0.camel@laptop>
Subject: Re: [PATCH 1/2] perf: Reset detached siblings' group_flags
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 11 Mar 2013 10:59:44 +0100
In-Reply-To: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
References: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 13:19 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Currently if a group_leader event is deleted, the sibling events are
> upgraded to singleton events of a same group list.  At this time, the
> siblings inherit the leader's group_flags.
> 
> However, if the group has mixed hw/sw events the leader's group_flag
> does not contain PERF_GROUP_SOFTWARE so sibling sw events will miss
> the flag also.  Fix it.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/events/core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 5c75791d7269..007dfe846d4d 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1107,8 +1107,9 @@ static void perf_group_detach(struct perf_event *event)
>  			list_move_tail(&sibling->group_entry, list);
>  		sibling->group_leader = sibling;
>  
> -		/* Inherit group flags from the previous leader */
> -		sibling->group_flags = event->group_flags;
> +		/* Reset group flags for each siblings */
> +		sibling->group_flags = is_software_event(sibling) ?
> +						PERF_GROUP_SOFTWARE : 0;
>  	}


In such a case, does the event not continue to live on the hw pmu? That
is, after this patch we'll have a software event on the hardware pmu
list with PERF_GROUP_SOFTWARE set, right? Seems odd.

