Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaINNZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaINNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:25:10 -0400
Date: Sun, 14 Sep 2014 15:24:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] perf kvm stat live: cache mmap()ed events
Message-ID: <20140914132423.GF1731@krava.redhat.com>
References: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 08:27:43PM +0400, Alexander Yarygin wrote:

SNIP

> +
> +	list_for_each_safe(p, p2, &cache->list) {
> +		struct events_cache *entry;
> +
> +		entry = list_entry(p, struct events_cache, list);
> +
> +		if (&entry->event == event) {
> +			list_del(&entry->list);
> +			free(entry);
> +
> +			break;
> +		}
> +	}
> +}
> +
> +static void clear_events_cache(struct events_cache *cache)
> +{
> +	struct list_head *p, *p2;
> +
> +	list_for_each_safe(p, p2, &cache->list) {
> +		struct event_cache *entry;

s/event_cache/events_cache/ ? does not compile for me otherwise

> +
> +		entry = list_entry(p, struct events_cache, list);
> +		list_del(&entry->list);
> +		free(entry);
> +	}
> +	free(cache);
> +}

SNIP

>  }
> 
>  static int cpu_isa_config(struct perf_kvm_stat *kvm)
> @@ -732,15 +800,15 @@ static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
>  			return -1;
>  		}
> 
> -		err = perf_session_queue_event(kvm->session, event, &sample, 0);
> -		/*
> -		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
> -		 *        point to it, and it'll get possibly overwritten by the kernel.
> -		 */
> +		event = alloc_event_cache(kvm->cache, event);
> +
>  		perf_evlist__mmap_consume(kvm->evlist, idx);
> 
> +		err = perf_session_queue_event(kvm->session, event, &sample, 0);

got conflict here, this got recently changed.. needs to have tool param:

-               err = perf_session_queue_event(kvm->session, event, &sample, 0);
+               err = perf_session_queue_event(kvm->session, event, &kvm->tool, &sample, 0);

jirka
