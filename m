Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251Ab3FSIwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:52:13 -0400
Received: from ozlabs.org ([203.10.76.45]:46920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933820Ab3FSIwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:52:03 -0400
Date: Wed, 19 Jun 2013 18:51:59 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 15/15] perf, tools: Add perf stat --transaction v3
Message-ID: <20130619085159.GA25177@concordia>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
 <1366485563-16209-16-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366485563-16209-16-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 12:19:23PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support to perf stat to print the basic transactional execution statistics:
> Total cycles, Cycles in Transaction, Cycles in aborted transsactions
> using the intx and intx_checkpoint qualifiers.
> Transaction Starts and Elision Starts, to compute the average transaction length.
> 
> This is a reasonable overview over the success of the transactions.
> 
> Enable with a new --transaction / -T option.
> 
> This requires measuring these events in a group, since they depend on each
> other.
> 
> This is implemented by using TM sysfs events exported by the kernel

Hi Andi,

I think this still hasn't gone upstream, so I thought I'd just jump in
and comment for powerpc ...

> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 7e910ba..5053c1a 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -70,6 +70,30 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
>  static void print_counter(struct perf_evsel *counter, char *prefix);
>  static void print_aggr(char *prefix);
>  
> +/* Default events used for perf stat -T */
> +static const char * const transaction_attrs[] = {
> +	"task-clock",
> +	"{"
> +	"instructions,"
> +	"cycles,"
> +	"cpu/cycles-t/,"
> +	"cpu/cycles-ct/,"
> +	"cpu/tx-start/,"
> +	"cpu/el-start/"
> +	"}"
> +};

This hard coded list isn't going to work for us on powerpc.

We don't have HLE, so we won't ever have an event for el-start.

I don't quite grok what the cycles-ct is about, checkpointed cycles? But
I don't think we have anything equivalent.

I guess the simplest option is to make it a per-arch list inside the
perf tool?

cheers
