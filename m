Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaCKMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:15:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:45008 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbaCKMPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="489732749"
Date: Tue, 11 Mar 2014 20:14:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140311121456.GA32527@localhost>
References: <20140308065153.GA30311@localhost>
 <20140310125319.GE26334@krava.redhat.com>
 <20140310224023.GA1205@krava.redhat.com>
 <20140311005611.GA1286@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311005611.GA1286@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

It works, thank you!

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 661951a..a53857e 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5423,6 +5423,8 @@ struct swevent_htable {
>  
>  	/* Recursion avoidance in each contexts */
>  	int				recursion[PERF_NR_CONTEXTS];
> +
> +	bool				offline;
>  };
>  
>  static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
> @@ -5669,8 +5671,10 @@ static int perf_swevent_add(struct perf_event *event, int flags)
>  	hwc->state = !(flags & PERF_EF_START);
>  
>  	head = find_swevent_head(swhash, event);
> -	if (WARN_ON_ONCE(!head))
> +	if (!head) {
> +		WARN_ON_ONCE(!swhash->offline);
>  		return -EINVAL;
> +	}
>  
>  	hlist_add_head_rcu(&event->hlist_entry, head);
>  
> @@ -7850,6 +7854,7 @@ static void perf_event_init_cpu(int cpu)
>  	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
>  
>  	mutex_lock(&swhash->hlist_mutex);
> +	swhash->offline = false;
>  	if (swhash->hlist_refcount > 0) {
>  		struct swevent_hlist *hlist;
>  
> @@ -7907,6 +7912,7 @@ static void perf_event_exit_cpu(int cpu)
>  	perf_event_exit_cpu_context(cpu);
>  
>  	mutex_lock(&swhash->hlist_mutex);
> +	swhash->offline = true;
>  	swevent_hlist_release(swhash);
>  	mutex_unlock(&swhash->hlist_mutex);
>  }
