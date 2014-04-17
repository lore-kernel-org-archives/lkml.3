Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaDQOlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaDQOk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:40:56 -0400
Date: Thu, 17 Apr 2014 16:40:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
Message-ID: <20140417144019.GF7422@krava.brq.redhat.com>
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 09:49:00PM +0100, Christian Borntraeger wrote:
> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> 
> Trace events potentially can have a '-' in their trace system name,
> e.g. kvm on s390 defines kvm-s390:* tracepoints.
> tools/perf could not parse them, because there was no rule for this:
> $ sudo ./perf top -e "kvm-s390:*"
> invalid or unsupported event: 'kvm-s390:*'
> 
> This patch adds an extra rule to event_legacy_tracepoint which handles
> those cases. Without the patch, perf will not accept such tracepoints in
> the -e option.
> 
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  tools/perf/util/parse-events.y | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> index 4eb67ec..dbbb01c 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -299,6 +299,18 @@ PE_PREFIX_MEM PE_VALUE sep_dc
>  }
>  
>  event_legacy_tracepoint:
> +PE_NAME '-' PE_NAME ':' PE_NAME
> +{
> +	struct parse_events_evlist *data = _data;
> +	struct list_head *list;
> +	char sys_name[strlen($1) + strlen($3) + 2];

hum, could you limit the size of sys_name array with some
sane value? those strlens make me nervous :-\

thanks,
jirka

> +	sprintf(&sys_name, "%s-%s", $1, $3);
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
> +	$$ = list;
> +}
> +|
>  PE_NAME ':' PE_NAME
>  {
>  	struct parse_events_evlist *data = _data;
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
