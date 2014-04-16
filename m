Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaDPNA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:00:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbaDPNAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:00:53 -0400
Date: Wed, 16 Apr 2014 15:00:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PULL 1/2] perf/tool: Fix usage of trace events with '-' in
 trace system name.
Message-ID: <20140416130008.GA6087@krava.brq.redhat.com>
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com>
 <1397053319-2130-2-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397053319-2130-2-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:21:58PM +0200, Christian Borntraeger wrote:
> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> 
> Trace events potentially can have a '-' in their trace system name,
> e.g. kvm on s390 defines kvm-s390:* tracepoints.
> tools/perf could not parse them, because there was no rule for this:
> $ sudo ./perf top -e "kvm-s390:*"
> invalid or unsupported event: 'kvm-s390:*'
> 
> This patch allows '-' to be a part of PE_NAME token, so tracepoints
> with '-' can be parsed by the event_legacy_tracepoint rule.
> Without the patch, perf will not accept such tracepoints in the -e
> option.
> 
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  tools/perf/util/parse-events.l |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 3432995..ca20da7 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -199,7 +199,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
>  {num_hex}		{ return value(yyscanner, 16); }
>  
>  {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
> -{name}			{ return str(yyscanner, PE_NAME); }
> +{name_minus}			{ return str(yyscanner, PE_NAME); }
>  "/"			{ BEGIN(config); return '/'; }
>  -			{ return '-'; }
>  ,			{ BEGIN(event); return ','; }

this breaks parsing of cache events like:

  $ perf record -e 'L1-dcache-loads' ls

also test 10 (same issue):
  $ ./perf test 10
  10: roundtrip evsel->name check                            : FAILED!


it might be little tricky to fix, let me know if you
have any troubles with that, I could look on it

thanks,
jirka
