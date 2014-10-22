Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaJVHAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:00:17 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:35862 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJVHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:00:15 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Waiman Long <Waiman.Long@hp.com>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] perf tools: ensure return negitive value when write header error
References: <1413428909-80017-1-git-send-email-wangnan0@huawei.com>
Date: Wed, 22 Oct 2014 16:00:12 +0900
In-Reply-To: <1413428909-80017-1-git-send-email-wangnan0@huawei.com> (Wang
	Nan's message of "Thu, 16 Oct 2014 11:08:29 +0800")
Message-ID: <87siigeghv.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 11:08:29 +0800, Wang Nan wrote:
> When 'perf record' write headers, it calls write_xxx in
> tools/perf/util/header.c, and check return value. It rolls back all
> working only when return value is negative.
>
> This patch ensures write_cpudesc() and write_total_mem() return negative number
> when error. Without this patch, headers reported by 'perf report' header is
> error in some platform. Following output is caputured on ARM, which doesn't
> contain "Processor" field in /proc/cpuinfo. See "cpudesc", "total memory" and
> "cmdline" field.
>
>    bash-4.2# perf record ls
>    ...
>    [ perf record: Woken up 1 times to write data ]
>    [ perf record: Captured and wrote 0.001 MB perf.data (~36 samples) ]
>    bash-4.2# perf report --stdio --header
>    Error:
>    The perf.data file has no samples!
>    # ========
>    # captured on: Fri Sep 12 10:09:10 2014
>    # hostname : arma15el
>    # os release : 3.17.0+
>    # perf version : 3.10.53
>    # arch : armv7l
>    # nrcpus online : 4
>    # nrcpus avail : 1
>    # cpudesc : (null)
>    # total memory : 0 kB
>    # cmdline :
>    # event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest = 1, precise_ip = 0
>    # pmu mappings: not available
>    # ========
>    #
>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

I guess the total_memory, cmdline and pmu mappings are somehow affected
by the broken cpudesc.  Do they have their own problem on ARM?

Anyway I think it's good to check the result properly, so

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  tools/perf/util/header.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index ce0de00..39b80ac 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -605,8 +605,10 @@ static int write_cpudesc(int fd, struct perf_header *h __maybe_unused,
>  			break;
>  	}
>  
> -	if (ret)
> +	if (ret) {
> +		ret = -1;
>  		goto done;
> +	}
>  
>  	s = buf;
>  
> @@ -950,7 +952,8 @@ static int write_total_mem(int fd, struct perf_header *h __maybe_unused,
>  		n = sscanf(buf, "%*s %"PRIu64, &mem);
>  		if (n == 1)
>  			ret = do_write(fd, &mem, sizeof(mem));
> -	}
> +	} else
> +		ret = -1;
>  	free(buf);
>  	fclose(fp);
>  	return ret;
