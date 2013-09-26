Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3IZM1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab3IZM1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:27:20 -0400
Date: Thu, 26 Sep 2013 14:27:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/21] perf: Add event toggle sys_perf_event_open
 interface
Message-ID: <20130926122702.GD1067@krava.brq.redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <1380113447-17144-6-git-send-email-jolsa@redhat.com>
 <20130925223629.GA13425@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925223629.GA13425@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 03:36:29PM -0700, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:

SNIP

> | diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> | index 866e85c..6ede25c 100644
> | --- a/include/linux/perf_event.h
> | +++ b/include/linux/perf_event.h
> | @@ -289,6 +289,12 @@ struct swevent_hlist {
> |  struct perf_cgroup;
> |  struct ring_buffer;
> | 
> | +enum perf_event_toggle_flag {
> | +	PERF_TOGGLE_NONE	= 0,
> | +	PERF_TOGGLE_ON		= 1,
> | +	PERF_TOGGLE_OFF		= 2,
> | +};
> 
> Can we call this 'perf_event_toggle_state' ? it can be confusing with
> PERF_FLAG_TOGGLE* macros below which apply to a different field.

right, 'state' is probably better

> 
> | +
> |  /**
> |   * struct perf_event - performance event kernel representation:
> |   */
> | @@ -414,6 +420,9 @@ struct perf_event {
> |  	int				cgrp_defer_enabled;
> |  #endif
> | 
> | +	struct perf_event		*toggled_event;
> | +	enum perf_event_toggle_flag	toggle_flag;
> 
> s/toggle_flag/toggle_state/ ?
> 
> | +	int				paused;
> 
> There is an 'event->state' field with OFF, INACTIVE, ACTIVE states.
> Can we add a 'PAUSED' state to that instead ?

good idea, I think that's possible

> 
> 
> |  #endif /* CONFIG_PERF_EVENTS */
> |  };
> | 
> | diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> | index ca1d90b..ecb0474 100644
> | --- a/include/uapi/linux/perf_event.h
> | +++ b/include/uapi/linux/perf_event.h
> | @@ -694,6 +694,9 @@ enum perf_callchain_context {
> |  #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
> |  #define PERF_FLAG_FD_OUTPUT		(1U << 1)
> |  #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
> | +#define PERF_FLAG_TOGGLE_ON		(1U << 3)
> | +#define PERF_FLAG_TOGGLE_OFF		(1U << 4)
> | +
> | 

SNIP

> | +	/* It's either ON or OFF. */
> | +	if ((flags & PERF_FLAG_TOGGLE) == PERF_FLAG_TOGGLE)
> | +		return -EINVAL;
> | +
> | +	/* Allow only same cpu, */
> | +	if (toggled_event->cpu != event->cpu)
> | +		return -EINVAL;
> | +
> | +	/* or same task. */
> 
> nit: s/or/and/
> 

ok

thanks,
jirka
