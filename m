Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3LJPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:25:39 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43916 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3LJPZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:25:37 -0500
Date: Tue, 10 Dec 2013 16:25:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: mingo@kernel.org, mingo@redhat.com, jacob.w.shin@gmail.com,
        oleg@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        hpa@zytor.com, tgl@domain.invalid, linux-kernel@vger.kernel.org,
        sherry.hurwitz@amd.com
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware
 breakpoint bp_len
Message-ID: <20131210152532.GF10633@localhost.localdomain>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1380730268-25807-3-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380730268-25807-3-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:11:07AM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Jacob Shin <jacob.w.shin@gmail.com>
> 
> Currently bp_len is given a default value of 4. Allow user to override it:
> 
>   $ perf stat -e mem:0x1000/8
>                             ^
>                             bp_len
> 
> If no value is given, it will default to 4 as it did before.
> 
> Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  tools/perf/Documentation/perf-record.txt |  7 +++++--
>  tools/perf/util/parse-events.c           | 17 +++++++----------
>  tools/perf/util/parse-events.h           |  2 +-
>  tools/perf/util/parse-events.l           |  1 +
>  tools/perf/util/parse-events.y           | 26 ++++++++++++++++++++++++--
>  5 files changed, 38 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index e297b74..e07491f 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -33,12 +33,15 @@ OPTIONS
>          - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
>  	  hexadecimal event descriptor.
>  
> -        - a hardware breakpoint event in the form of '\mem:addr[:access]'
> +        - a hardware breakpoint event in the form of '\mem:addr[/len][:access]'
>            where addr is the address in memory you want to break in.
>            Access is the memory access type (read, write, execute) it can
> -          be passed as follows: '\mem:addr[:[r][w][x]]'.
> +          be passed as follows: '\mem:addr[:[r][w][x]]'. len is the range,
> +          number of bytes from specified addr, which the breakpoint will cover.
>            If you want to profile read-write accesses in 0x1000, just set
>            'mem:0x1000:rw'.
> +          If you want to profile write accesses in [0x1000~1008), just set
> +          'mem:0x1000/8:w'.
>  
>  --filter=<filter>::
>          Event filter.
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 9812531..65d81ae 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -515,7 +515,7 @@ do {					\
>  }
>  
>  int parse_events_add_breakpoint(struct list_head *list, int *idx,
> -				void *ptr, char *type)
> +				void *ptr, char *type, u64 len)
>  {
>  	struct perf_event_attr attr;
>  
> @@ -525,14 +525,11 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
>  	if (parse_breakpoint_type(type, &attr))
>  		return -EINVAL;
>  
> -	/*
> -	 * We should find a nice way to override the access length
> -	 * Provide some defaults for now
> -	 */
> -	if (attr.bp_type == HW_BREAKPOINT_X)
> -		attr.bp_len = sizeof(long);
> -	else
> -		attr.bp_len = HW_BREAKPOINT_LEN_4;
> +	/* Provide some defaults if len is not specified */
> +	if (!len)
> +		len = attr.bp_type == HW_BREAKPOINT_X ? sizeof(long) :
> +							HW_BREAKPOINT_LEN_4;

Why is LEN_4 affected in the type?

> +	attr.bp_len = len;

Thanks.
