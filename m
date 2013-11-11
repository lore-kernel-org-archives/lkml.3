Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3KKHsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:48:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:21562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab3KKHsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:48:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="387586803"
Message-ID: <52808D81.70308@intel.com>
Date: Mon, 11 Nov 2013 09:55:45 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: Round mmap pages to power 2
References: <1383885392-31082-1-git-send-email-dsahern@gmail.com> <527CAAAB.3000900@intel.com> <527CF7FF.7060001@gmail.com>
In-Reply-To: <527CF7FF.7060001@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/13 16:41, David Ahern wrote:
> On 11/8/13, 2:11 AM, Adrian Hunter wrote:
>> This prevents:
>>
>>      --out-pages=0
>>
>> from working e.g.
>>
>>      tools/perf/perf record -vv --out-pages=0 uname
>>      rounding mmap pages size to 4096 (1 pages)
>>
>> Although without this patch:
>>
>>      tools/perf/perf record -vv --out-pages=0 uname
>>      --mmap_pages/-m value must be a power of two.
>>       usage: perf record [<options>] [<command>]
>>          or: perf record [<options>] -- <command> [<options>]
>>
>>              --out-pages <pages>
>>                            Number of pages or size with units to use for
>> output (default 64M)
>>
>> Also there is:
>>
>>      tools/perf/perf record -vv --no-out-pages uname
>>      Segmentation fault (core dumped)
>
> This is problem with perf_evlist__parse_mmap_pages(); same thing happens
> with --no-map-pages.
>
> With the attached both round a 0 up to 1 page:
>
> [daahern@nxos-vdc-dev3 perf]$ perf record --out-pages 0 uname
> rounding mmap pages size to 4096 (1 pages)


Your code looks like out_pages = 0 selects write() instead of mmap().
So it you can't set out_pages = 0, how do you select write()?


> Linux
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.008 MB perf.data (~339 samples) ]
>
> [daahern@nxos-vdc-dev3 perf]$ perf record --mmap-pages 0 uname
> rounding mmap pages size to 4096 (1 pages)
> Linux
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.008 MB perf.data (~339 samples) ]
>
> [daahern@nxos-vdc-dev3 perf]$ perf record --no-mmap-pages uname
>
>  usage: perf record [<options>] [<command>]
>     or: perf record [<options>] -- <command> [<options>]
>
>     -m, --mmap-pages <pages>
>                           number of mmap data pages
> David
>

