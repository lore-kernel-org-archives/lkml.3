Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaILGdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:33:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:34169 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaILGdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:33:21 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Ignore stripped vmlinux and fallback to kallsyms
References: <20140909085929.4a5a81f0@kryten>
Date: Fri, 12 Sep 2014 15:33:20 +0900
In-Reply-To: <20140909085929.4a5a81f0@kryten> (Anton Blanchard's message of
	"Tue, 9 Sep 2014 08:59:29 +1000")
Message-ID: <87ha0dmjpr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Tue, 9 Sep 2014 08:59:29 +1000, Anton Blanchard wrote:
> If a vmlinux is stripped, perf will use it and ignore kallsyms. We
> end up with useless profiles where everything maps to a few
> runtime symbols:
>
>     63.39%       swapper  [kernel.kallsyms]   [k] hcall_real_table
>      4.90%      beam.smp  [kernel.kallsyms]   [k] hcall_real_table
>      4.44%      beam.smp  [kernel.kallsyms]   [k] __sched_text_start
>      3.72%      beam.smp  [kernel.kallsyms]   [k] __run_at_kexec
>
> Detect this case and fallback to using kallsyms. This fixes the issue:
>
>     62.81%       swapper  [kernel.kallsyms]   [k] snooze_loop
>      4.44%      beam.smp  [kernel.kallsyms]   [k] __schedule
>      0.91%      beam.smp  [kernel.kallsyms]   [k] _switch
>      0.73%      beam.smp  [kernel.kallsyms]   [k] put_prev_entity
>
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>
> Index: b/tools/perf/util/symbol-elf.c
> ===================================================================
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -712,6 +712,14 @@ int dso__load_sym(struct dso *dso, struc
>  		symbols__delete(&dso->symbols[map->type]);
>  
>  	if (!syms_ss->symtab) {
> +		/*
> +		 * If the vmlinux is stripped, fail so we will fall back
> +		 * to using kallsyms. The vmlinux runtime symbols aren't
> +		 * of much use.
> +		 */
> +		if (dso->kernel)
> +			goto out_elf_end;
> +
>  		syms_ss->symtab  = syms_ss->dynsym;
>  		syms_ss->symshdr = syms_ss->dynshdr;
>  	}
