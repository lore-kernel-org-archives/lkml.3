Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3C0OOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3C0OOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:14:41 -0400
Date: Wed, 27 Mar 2013 15:14:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
Message-ID: <20130327141425.GC1092@krava.brq.redhat.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-12-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359040242-8269-12-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 04:10:35PM +0100, Stephane Eranian wrote:

SNIP

>  
> +static void ip__resolve_data(struct machine *self, struct thread *thread,
> +			     u8 m,
> +			    struct addr_map_symbol *ams,
> +			    u64 addr)
> +{
> +	struct addr_location al;
> +
> +	memset(&al, 0, sizeof(al));
> +
> +	thread__find_addr_location(thread, self, m, MAP__VARIABLE, addr, &al,
> +				   NULL);
> +	ams->addr = addr;
> +	ams->al_addr = al.addr;
> +	ams->sym = al.sym;
> +	ams->map = al.map;
> +}
> +
> +struct mem_info *machine__resolve_mem(struct machine *self,
> +				      struct thread *thr,
> +				      struct perf_sample *sample,
> +				      u8 cpumode)
> +{
> +	struct mem_info *mi;
> +
> +	mi = calloc(1, sizeof(struct mem_info));
> +	if (!mi)
> +		return NULL;
> +
> +	ip__resolve_ams(self, thr, &mi->iaddr, sample->ip);
> +	ip__resolve_data(self, thr, cpumode, &mi->daddr, sample->addr);

question, should this be the other way around?  like:

	ip__resolve_ams(machine, thr, &mi->daddr, sample->addr);
	ip__resolve_data(machine, thr, cpumode, &mi->iaddr, sample->ip);

we have correct cpumode for sample->ip, but I think it's the
PEBS->dla (sample->addr) where we need to guess.. right?

that makes me think that we could probably use ip__resolve_data
for both.. hummm.. but we could access data cross the user/kernel
boundary, so cpumode would be different for ip and accessed data

thanks,
jirka
