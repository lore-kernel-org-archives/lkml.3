Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaDHXqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:46:33 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44190 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbaDHXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:46:31 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 10/15 V3] perf, c2c: Display cacheline HITM analysis to stdout
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-11-git-send-email-dzickus@redhat.com>
Date: Wed, 09 Apr 2014 08:46:29 +0900
In-Reply-To: <1395689826-215033-11-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:37:01 -0400")
Message-ID: <87vbujv0yy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Mon, 24 Mar 2014 15:37:01 -0400, Don Zickus wrote:
> +	sprintf(summary, "%4d %5.1f%% %5.1f%% %5.1f%% %5.1f%% %8d %8d %8d %8d %18s %6s\n",
> +			record,
> +			tot_dist * 100.,
> +			tot_cumm * 100.,
> +			ld_dist * 100.,
> +			ld_cumm * 100.,

I think adding a 0 after decimal point helps readability little bit.


> +			h->stats.t.rmt_hitm,
> +			h->stats.t.lcl_hitm,
> +			h->stats.t.st_l1hit,
> +			h->stats.t.st_l1miss,
> +			addrstr,
> +			pidstr);
> +
> +	for (j = 0; j < (int)strlen(summary); j++) printf("-");
> +	printf("\n");
> +	printf("%s", summary);
> +	for (j = 0; j < (int)strlen(summary); j++) printf("-");
> +	printf("\n");
> +}
> +
> +static void print_socket_stats_str(struct c2c_hit *clo,
> +				   struct c2c_stats *node_stats)
> +{
> +	int i, j;
> +
> +	if (!node_stats)
> +		return;
> +
> +	for (i = 0; i < max_node_num; i++) {
> +		struct c2c_stats *stats = &node_stats[i];
> +		int num = CPU_COUNT(&stats->cpuset);
> +
> +		if (!num) {
> +			/* pad align socket info */
> +			for (j = 0; j < 21; j++)
> +				printf(" ");
> +			continue;
> +		}
> +
> +		printf("%2d{%2d ", i, num);
> +
> +		if (clo->stats.t.rmt_hitm > 0)
> +			printf("%5.1f%% ", 100. * ((double)stats->t.rmt_hitm / (double) clo->stats.t.rmt_hitm));

Just for your information, most perf tools show 2 digit after decimal
point so it'd be "%5.2f%%" but it's not a strict rule.

Anyway I think multiplying 100.0 first can remove the casts.  So code
below will do the same thing..

		100.0 * stats->t.rmt_hitm / clo->stats.t.rmt_hitm

The same goes to other percentage calculations too.

Thanks,
Namhyung


> +		else
> +			printf("%6s ", "n/a");
> +
> +		if (clo->stats.t.store > 0)
> +			printf("%5.1f%%} ", 100. * ((double)stats->t.store / (double)clo->stats.t.store));
> +		else
> +			printf("%6s} ", "n/a");
> +	}
> +}
