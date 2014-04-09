Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862AbaDIPKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:10:15 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33050 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538AbaDIPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:10:09 -0400
Message-ID: <534562C9.2010101@gmail.com>
Date: Wed, 09 Apr 2014 08:10:01 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PULL 2/2] perf-kvm: fix of 'Min time' counting in report command
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com> <1397053319-2130-3-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1397053319-2130-3-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/14, 7:21 AM, Christian Borntraeger wrote:
> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>
> Every event in the perf-kvm has a 'stats' structure, which contains
> max/min/average/etc times of handling this event.
> The problem is that the 'perf-kvm stat report' command always shows
> that 'min time' is 0us for every event. Example:
>
>   # perf kvm stat report
> Analyze events for all VCPUs:
>
>      VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time
>      Avg time
> [..]
> 0xB2 MSCH         12     0.07%     0.00%        0us        8us
>      7.31us ( +-   2.11% )
> 0xB2 CHSC         12     0.07%     0.00%        0us       18us
>      9.39us ( +-   9.49% )
> 0xB2 STPX          8     0.05%     0.00%        0us        2us
>      1.88us ( +-   7.18% )
> 0xB2 STSI          7     0.04%     0.00%        0us       44us
>      16.49us ( +-  38.20% )
> [..]
>
> This happens because 'stats' structure is not initialized and
> stats->min equals to 0. Lets initialize the structure for every
> event after it's allocation using init_stats() function. This initialize
> stats->min to -1 and makes 'Min time' statistics counting work:
>
>   # perf kvm stat report
>
> Analyze events for all VCPUs:
>
>      VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time
>      Avg time
> [..]
> 0xB2 MSCH         12     0.07%     0.00%        6us        8us
>      7.31us ( +-   2.11% )
> 0xB2 CHSC         12     0.07%     0.00%        7us       18us
>      9.39us ( +-   9.49% )
> 0xB2 STPX          8     0.05%     0.00%        1us        2us
>      1.88us ( +-   7.18% )
> 0xB2 STSI          7     0.04%     0.00%        1us       44us
>      16.49us ( +-  38.20% )
> [..]
>
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   tools/perf/builtin-kvm.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 21c164b..0f1e5a2 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -404,6 +404,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
>   	}
>
>   	event->key = *key;
> +	init_stats(&event->total.stats);
>   	return event;
>   }

Reviewed-by: David Ahern <dsahern@gmail.com>


