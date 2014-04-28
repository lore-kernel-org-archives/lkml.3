Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaD1H2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:28:05 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35976 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaD1H2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:28:02 -0400
Message-ID: <535E02FA.9050909@de.ibm.com>
Date: Mon, 28 Apr 2014 09:27:54 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf tools: parse tracepooints with '-' in system
 name
References: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com> <1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042807-8372-0000-0000-0000097C32AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 17:34, Alexander Yarygin wrote:
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
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Jiri, please review and handle via your tree if ok.

I gave the other two patches also a quick test on my s390 box. Seems to work fine.



> ---
>  tools/perf/util/parse-events.y |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
> index 4eb67ec..ac9db9f 100644
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
> +	char sys_name[128];
> +	snprintf(&sys_name, 128, "%s-%s", $1, $3);
> +
> +	ALLOC_LIST(list);
> +	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
> +	$$ = list;
> +}
> +|
>  PE_NAME ':' PE_NAME
>  {
>  	struct parse_events_evlist *data = _data;
> 

