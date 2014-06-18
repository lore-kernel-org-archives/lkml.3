Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaFRTov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:44:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39238 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbaFRTot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:44:49 -0400
Message-ID: <53A1EC2E.1010706@gmail.com>
Date: Wed, 18 Jun 2014 13:44:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv2 00/18] perf tools: Factor ordered samples queue
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> hi,
> this patchset factors session's ordered samples queue,
> and allows to limit the size of this queue.
>
> v2 changes:
>    - several small changes for review comments (Namhyung)
>
>
> The report command queues events till any of following
> conditions is reached:
>    - PERF_RECORD_FINISHED_ROUND event is processed
>    - end of the file is reached
>
> Any of above conditions will force the queue to flush some
> events while keeping all allocated memory for next events.
>
> If PERF_RECORD_FINISHED_ROUND is missing the queue will
> allocate memory for every single event in the perf.data.
> This could lead to enormous memory consuption and speed
> degradation of report command for huge perf.data files.
>
> With the quue allocation limit of 100 MB, I've got around
> 15% speedup on reporting of ~10GB perf.data file.
>
> current code:
>   Performance counter stats for './perf.old report --stdio -i perf-test.data' (3 runs):
>
>     621,685,704,665      cycles                    ( +-  0.52% )
>     873,397,467,969      instructions              ( +-  0.00% )
>
>       286.133268732 seconds time elapsed           ( +-  1.13% )
>
> with patches:
>   Performance counter stats for './perf report --stdio -i perf-test.data' (3 runs):
>
>     603,933,987,185      cycles                    ( +-  0.45% )
>     869,139,445,070      instructions              ( +-  0.00% )
>
>       245.337510637 seconds time elapsed           ( +-  0.49% )
>
>
> The speed up seems to be mainly in less cycles spent in servicing
> page faults:
>
> current code:
>       4.44%     0.01%  perf.old  [kernel.kallsyms]   [k] page_fault
>
> with patches:
>       1.45%     0.00%      perf  [kernel.kallsyms]   [k] page_fault
>
> current code (faults event):
>           6,643,807      faults                    ( +-  0.36% )
>
> with patches (faults event):
>           2,214,756      faults                    ( +-  3.03% )
>
>
> Also now we have one of our big memory spender under control
> and the ordered events queue code is put in separated object
> with clear interface ready to be used by another command
> like script.
>
> Also reachable in here:
>    git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>    perf/core_ordered_events
>

I've skimmed through the patches. What happens if you are in the middle 
of a round and the max queue size is reached?

I need to find some time for a detailed review, and to run through some 
stress case scenarios. e.g., a couple that come to mind
perf sched record -- perf bench sched pipe
perf kvm record while booting a nested VM which causes a lot of VMEXITs

David

