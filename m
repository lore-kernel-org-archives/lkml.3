Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3G3FY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:24:59 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55461 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3G3FY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:24:58 -0400
X-AuditID: 9c93016f-b7b50ae0000021a9-bc-51f74e281258
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 8/9] perf tools: add kcore to the object code reading test
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com>
	<1374760890-30558-9-git-send-email-adrian.hunter@intel.com>
Date: Tue, 30 Jul 2013 14:24:56 +0900
In-Reply-To: <1374760890-30558-9-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Thu, 25 Jul 2013 17:01:29 +0300")
Message-ID: <87vc3s1uxj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 17:01:29 +0300, Adrian Hunter wrote:
> Make the "object code reading" test attempt to read from
> kcore.
>
> The test uses objdump which struggles with kcore. i.e.
> doesn't always work, sometimes takes a long time.
> The test has been made to work around those issues.
>
[SNIP]

> -	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS) {
> +	if (al.map->dso->symtab_type == DSO_BINARY_TYPE__KALLSYMS &&
> +	    !dso__is_kcore(al.map->dso)) {

I was confused.  So this means that the symbols came from the kallsyms
but actual binary data came from the kcore, right?


>  		pr_debug("Unexpected kernel address - skipping\n");
>  		return 0;
>  	}

[SNIP]
> +
> +	/* 2nd time through we just try kcore */
> +	if (try_kcore && !have_kcore)
> +		return TEST_CODE_READING_NO_KCORE;
> +
> +	/* No point getting kernel events if there is no kernel object */
> +	if (!have_vmlinux && !have_kcore)
>  		excl_kernel = true;
>  
>  	threads = thread_map__new_by_tid(pid);
> @@ -457,8 +502,12 @@ static int do_test_code_reading(void)
>  	if (ret < 0)
>  		goto out_err;
>  
> -	if (!have_vmlinux)
> +	if (!have_vmlinux && !have_kcore && !try_kcore)
> +		err = TEST_CODE_READING_NO_KERNEL_OBJ;
> +	else if (!have_vmlinux && !try_kcore)
>  		err = TEST_CODE_READING_NO_VMLINUX;
> +	else if (!have_kcore && try_kcore)
> +		err = TEST_CODE_READING_NO_KCORE;

It seems that the above line is not reachable since we already bailed
out the second test if we don't have kcore.


>  	else if (excl_kernel)
>  		err = TEST_CODE_READING_NO_ACCESS;
>  	else
> @@ -485,7 +534,9 @@ int test__code_reading(void)
>  {
>  	int ret;
>  
> -	ret = do_test_code_reading();
> +	ret = do_test_code_reading(false);
> +	if (!ret)

Shouldn't it be

	if (ret)
?

Thanks,
Namhyung


> +		ret = do_test_code_reading(true);
>  
>  	switch (ret) {
>  	case TEST_CODE_READING_OK:
> @@ -493,9 +544,15 @@ int test__code_reading(void)
>  	case TEST_CODE_READING_NO_VMLINUX:
>  		fprintf(stderr, " (no vmlinux)");
>  		return 0;
> +	case TEST_CODE_READING_NO_KCORE:
> +		fprintf(stderr, " (no kcore)");
> +		return 0;
>  	case TEST_CODE_READING_NO_ACCESS:
>  		fprintf(stderr, " (no access)");
>  		return 0;
> +	case TEST_CODE_READING_NO_KERNEL_OBJ:
> +		fprintf(stderr, " (no kernel obj)");
> +		return 0;
>  	default:
>  		return -1;
>  	};
