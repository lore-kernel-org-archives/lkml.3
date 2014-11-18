Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaKRGOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:14:16 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60976 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaKRGOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:14:14 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: kan.liang@intel.com, acme@kernel.org, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, ak@linux.intel.com
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-4-git-send-email-kan.liang@intel.com>
	<20141117155553.GC21532@krava.brq.redhat.com>
Date: Tue, 18 Nov 2014 15:14:12 +0900
In-Reply-To: <20141117155553.GC21532@krava.brq.redhat.com> (Jiri Olsa's
	message of "Mon, 17 Nov 2014 16:55:53 +0100")
Message-ID: <87h9xxqbm3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 16:55:53 +0100, Jiri Olsa wrote:
> On Fri, Nov 14, 2014 at 08:44:12AM -0500, kan.liang@intel.com wrote:
>
> SNIP
>
>> +	if (lbr) {
>> +		for (i = 0; i < chain_nr; i++) {
>> +			if (chain->ips[i] == PERF_CONTEXT_USER)
>> +				break;
>> +		}
>> +
>> +		/* LBR only affects the user callchain */
>> +		if (i != chain_nr) {
>> +			struct branch_stack *lbr_stack = sample->branch_stack;
>> +			int lbr_nr = lbr_stack->nr;
>> +			/*
>> +			 * LBR callstack can only get user call chain.
>> +			 * The mix_chain_nr is kernel call chain
>> +			 * number plus LBR user call chain number.
>> +			 * i is kernel call chain number,
>> +			 * 1 is PERF_CONTEXT_USER,
>> +			 * lbr_nr + 1 is the user call chain number.
>> +			 * For details, please refer to the comments
>> +			 * in callchain__printf
>> +			 */
>> +			int mix_chain_nr = i + 1 + lbr_nr + 1;
>> +
>> +			if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
>> +				pr_warning("corrupted callchain. skipping...\n");
>> +				return 0;
>> +			}
>> +
>> +			for (j = 0; j < mix_chain_nr; j++) {
>> +				if (callchain_param.order == ORDER_CALLEE) {
>> +					if (j < i + 1)
>> +						ip = chain->ips[j];
>> +					else if (j > i + 1)
>> +						ip = lbr_stack->entries[j - i - 2].from;
>> +					else
>> +						ip = lbr_stack->entries[0].to;
>> +				} else {
>> +					if (j < lbr_nr)
>> +						ip = lbr_stack->entries[lbr_nr - j - 1].from;
>> +					else if (j > lbr_nr)
>> +						ip = chain->ips[i + 1 - (j - lbr_nr)];
>> +					else
>> +						ip = lbr_stack->entries[0].to;
>> +				}
>> +
>> +				err = add_callchain_ip(thread, parent, root_al,
>> +						       cpumode, ip);
>> +				if (err)
>> +					goto exit;
>> +			}
>> +			return 0;
>> +		}
>> +	}
>
> also could you please move whole block above into separated function?
> Andi has another change for this function and it's becoming really big.

Agreed.

Thanks,
Namhyung
