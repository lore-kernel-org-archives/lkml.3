Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3HCOLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 10:11:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:22584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3HCOLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 10:11:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,807,1367996400"; 
   d="scan'208";a="356844659"
Message-ID: <51FD0F96.4090805@intel.com>
Date: Sat, 03 Aug 2013 17:11:34 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com> <1375218838-31042-2-git-send-email-adrian.hunter@intel.com> <20130731145820.GF3614@ghostprotocols.net> <20130731172833.GH3614@ghostprotocols.net>
In-Reply-To: <20130731172833.GH3614@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/2013 8:28 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 11:58:20AM -0300, Arnaldo Carvalho de Melo escreveu:
>> >  Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
>>> >  >  Using the information in mmap events, perf tools can read object
>>> >  >  code associated with sampled addresses.  A test is added that
>>> >  >  compares bytes read by perf with the same bytes read using
>>> >  >  objdump.
>> >
>> >  investigating...
>> >
>> >  (gdb) run test 21
>> >  Starting program: /root/bin/perf test 21
>> >  [Thread debugging using libthread_db enabled]
>> >  Using host libthread_db library "/lib64/libthread_db.so.1".
>> >  21: Test object code reading                               :
>> >  Program received signal SIGSEGV, Segmentation fault.
>> >  0x000000000045a2d3 in xyarray__entry (xy=0x0, x=0, y=0) at util/xyarray.h:17
>> >  17		return&xy->contents[x * xy->row_size + y * xy->entry_size];
>
> Still investigating, but the attached patch is needed to handle such
> failure cases:

I removed the offending perf_evlist__disable() since it was not needed 
anyway.  Otherwise the existing error path was simpler so I kept it in V3.

>
> [root@zoo ~]# perf test 21
> 21: Test object code reading                               : FAILED!
> [root@zoo ~]# perf test -v 21
> 21: Test object code reading                               :
> --- start ---
> Looking at the vmlinux_path (6 entries long)
> symsrc__init: cannot get elf header.
> Using /lib/modules/3.11.0-rc2+/build/vmlinux for symbols
> Parsing event 'cycles'
> Parsing event 'cycles:u'
> perf_evlist__open failed
> ---- end ----
> Test object code reading: FAILED!
> [root@zoo ~]#
>
> - Arnaldo
>
>
> error_path.patch
>
>
> diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
> index 7c9437d..9d9b6b5 100644
> --- a/tools/perf/tests/code-reading.c
> +++ b/tools/perf/tests/code-reading.c
> @@ -357,7 +357,7 @@ static int do_test_code_reading(void)
>   	ret = machine__create_kernel_maps(machine);
>   	if (ret<  0) {
>   		pr_debug("machine__create_kernel_maps failed\n");
> -		goto out_err;
> +		goto out_machine_exit;
>   	}
>
>   	/* Load kernel map */
> @@ -365,7 +365,7 @@ static int do_test_code_reading(void)
>   	ret = map__load(map, NULL);
>   	if (ret<  0) {
>   		pr_debug("map__load failed\n");
> -		goto out_err;
> +		goto out_destroy_kernel_maps;
>   	}
>   	have_vmlinux = map->dso->symtab_type == DSO_BINARY_TYPE__VMLINUX;
>   	/* No point getting kernel events if there is no vmlinux */
> @@ -375,26 +375,26 @@ static int do_test_code_reading(void)
>   	threads = thread_map__new_by_tid(pid);
>   	if (!threads) {
>   		pr_debug("thread_map__new_by_tid failed\n");
> -		goto out_err;
> +		goto out_destroy_kernel_maps;
>   	}
>
>   	ret = perf_event__synthesize_thread_map(NULL, threads,
>   						perf_event__process, machine);
>   	if (ret<  0) {
>   		pr_debug("perf_event__synthesize_thread_map failed\n");
> -		goto out_err;
> +		goto out_thread_map_delete;
>   	}
>
>   	thread = machine__findnew_thread(machine, pid);
>   	if (!thread) {
>   		pr_debug("machine__findnew_thread failed\n");
> -		goto out_err;
> +		goto out_thread_map_delete;
>   	}
>
>   	cpus = cpu_map__new(NULL);
>   	if (!cpus) {
>   		pr_debug("cpu_map__new failed\n");
> -		goto out_err;
> +		goto out_thread_map_delete;
>   	}
>
>   	while (1) {
> @@ -403,7 +403,7 @@ static int do_test_code_reading(void)
>   		evlist = perf_evlist__new();
>   		if (!evlist) {
>   			pr_debug("perf_evlist__new failed\n");
> -			goto out_err;
> +			goto out_cpu_map_delete;
>   		}
>
>   		perf_evlist__set_maps(evlist, cpus, threads);
> @@ -416,7 +416,7 @@ static int do_test_code_reading(void)
>   		ret = parse_events(evlist, str);
>   		if (ret<  0) {
>   			pr_debug("parse_events failed\n");
> -			goto out_err;
> +			goto out_evlist_delete;
>   		}
>
>   		perf_evlist__config(evlist,&opts);
> @@ -435,7 +435,7 @@ static int do_test_code_reading(void)
>   				continue;
>   			}
>   			pr_debug("perf_evlist__open failed\n");
> -			goto out_err;
> +			goto out_evlist_delete;
>   		}
>   		break;
>   	}
> @@ -443,7 +443,7 @@ static int do_test_code_reading(void)
>   	ret = perf_evlist__mmap(evlist, UINT_MAX, false);
>   	if (ret<  0) {
>   		pr_debug("perf_evlist__mmap failed\n");
> -		goto out_err;
> +		goto out_evlist_close;
>   	}
>
>   	perf_evlist__enable(evlist);
> @@ -454,7 +454,7 @@ static int do_test_code_reading(void)
>
>   	ret = process_events(machine, evlist);
>   	if (ret<  0)
> -		goto out_err;
> +		goto out_evlist_munmap;
>
>   	if (!have_vmlinux)
>   		err = TEST_CODE_READING_NO_VMLINUX;
> @@ -462,19 +462,21 @@ static int do_test_code_reading(void)
>   		err = TEST_CODE_READING_NO_ACCESS;
>   	else
>   		err = TEST_CODE_READING_OK;
> -out_err:
> -	if (evlist) {
> -		perf_evlist__disable(evlist);
> -		perf_evlist__munmap(evlist);
> -		perf_evlist__close(evlist);
> -		perf_evlist__delete(evlist);
> -	}
> -	if (cpus)
> -		cpu_map__delete(cpus);
> -	if (threads)
> -		thread_map__delete(threads);
> +
> +out_evlist_munmap:
> +	perf_evlist__munmap(evlist);
> +out_evlist_close:
> +	perf_evlist__close(evlist);
> +out_evlist_delete:
> +	perf_evlist__delete(evlist);
> +out_cpu_map_delete:
> +	cpu_map__delete(cpus);
> +out_thread_map_delete:
> +	thread_map__delete(threads);
> +out_destroy_kernel_maps:
>   	machines__destroy_kernel_maps(&machines);
>   	machine__delete_threads(machine);
> +out_machine_exit:
>   	machines__exit(&machines);
>
>   	return err;
>

