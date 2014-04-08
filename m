Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaDHHJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:09:08 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:36405 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaDHHJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:09:06 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 04/15 V3] perf c2c: Dump raw records, decode data_src bits
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-5-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 16:09:03 +0900
In-Reply-To: <1395689826-215033-5-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:36:55 -0400")
Message-ID: <8761mkxpps.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:36:55 -0400, Don Zickus wrote:
> +	union perf_mem_data_src dsrc = { .val = val, };
> +	int printed = scnprintf(bf, size, PREFIX);
> +	size_t i;
> +	bool first_present = true;
> +
> +	for (i = 0; i < ARRAY_SIZE(decode_bits); i++) {
> +		int bitval;
> +
> +		switch (decode_bits[i].field) {
> +		case OP:  bitval = decode_bits[i].bit & dsrc.mem_op;    break;
> +		case LVL: bitval = decode_bits[i].bit & dsrc.mem_lvl;   break;
> +		case SNP: bitval = decode_bits[i].bit & dsrc.mem_snoop; break;
> +		case LCK: bitval = decode_bits[i].bit & dsrc.mem_lock;  break;
> +		case TLB: bitval = decode_bits[i].bit & dsrc.mem_dtlb;  break;
> +		default: bitval = 0;					break;
> +		}
> +
> +		if (!bitval)
> +			continue;
> +
> +		if (strlen(decode_bits[i].name) + !!i > size - printed - sizeof(SUFFIX)) {
> +			sprintf(bf + size - sizeof(SUFFIX) - sizeof(ELLIPSIS) + 1, ELLIPSIS);
> +			printed = size - sizeof(SUFFIX);
> +			break;
> +		}
> +
> +		printed += scnprintf(bf + printed, size - printed, "%s%s",
> +				     first_present ? "" : ",", decode_bits[i].name);
> +		first_present = false;
> +	}
> +
> +	printed += scnprintf(bf + printed, size - printed, SUFFIX);

It seems that adjusting bf and size as printed might make the code
somewhat simpler and readable - i.e.:

        ret = scnprintf(bf, size, "%s", ...);

        bf += ret;
        size -= ret;
        printed += ret;


> +	return printed;
>  }
>  
> -static int perf_c2c__process_load(struct perf_evsel *evsel,
> -				  struct perf_sample *sample,
> -				  struct addr_location *al)
> +static int perf_c2c__fprintf_header(FILE *fp)
>  {
> -	perf_sample__fprintf(sample, evsel, al, stdout);
> -	return 0;
> +	int printed = fprintf(fp, "%c %-16s  %6s  %6s  %4s  %18s  %18s  %18s  %6s  %-10s %-60s %s\n", 
> +			      'T',
> +			      "Status",
> +			      "Pid",
> +			      "Tid",
> +			      "CPU",
> +			      "Inst Adrs",
> +			      "Virt Data Adrs",
> +			      "Phys Data Adrs",
> +			      "Cycles",
> +			      "Source",
> +			      "  Decoded Source",
> +			      "ObJect:Symbol");

s/ObJect/Object/ ?

Thanks,
Namhyung


> +	return printed + fprintf(fp, "%-*.*s\n", printed, printed, graph_dotted_line);
> +}
