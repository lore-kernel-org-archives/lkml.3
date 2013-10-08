Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3JHLrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 07:47:53 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54110 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3JHLrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 07:47:52 -0400
Message-ID: <5253F0E4.4080105@hitachi.com>
Date: Tue, 08 Oct 2013 20:47:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/3] Support for perf to probe into SDT markers:
References: <20131007063911.11693.33624.stgit@hemant-fedora> <20131007064806.11693.23845.stgit@hemant-fedora>
In-Reply-To: <20131007064806.11693.23845.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/07 15:48), Hemant Kumar wrote:
> This allows perf to probe into the sdt markers/notes present in
> the libraries and executables. We try to find the associated location
> and handle prelinking (since, stapsdt notes section is not allocated
> during runtime). Prelinking is handled with the help of base
> section which is allocated during runtime. This address can be compared
> with the address retrieved from the notes' description. If its different,
> we can take this difference and then add to the note's location.
> 
> We can use existing '-a/--add' option to add events for sdt markers.
> Also, we can add multiple events at once using the same '-a' option.
> 
> Usage:
> perf probe -x /lib64/libc.so.6 -a 'my_event=%libc:setjmp'
> 
> or
> 
> perf probe -x /lib64/libc.so.6 %libc:setjmp
> 
> Output (corresponding to the first usage):
> Added new event:
>   libc:my_event        (on 0x35981)
> 
> You can now use it in all perf tools, such as:
> 
>     perf record -e libc:my_event -aR sleep 1
> 
> 
> Signed-off-by: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-probe.c    |   11 +++++
>  tools/perf/util/probe-event.c |   89 +++++++++++++++++++++++++++++++++++++----
>  tools/perf/util/probe-event.h |    2 +
>  tools/perf/util/symbol-elf.c  |   80 +++++++++++++++++++++++++++++++++++++
>  tools/perf/util/symbol.h      |    3 +
>  5 files changed, 177 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index cbd2383..6f09723 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -370,6 +370,17 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  			pr_err("Error: Don't use --markers with --funcs.\n");
>  			usage_with_options(probe_usage, options);
>  		}
> +		if (params.mod_events) {
> +			ret = add_perf_probe_events(params.events,
> +						    params.nevents,
> +						    params.max_probe_points,
> +						    params.target,
> +						    params.force_add);
> +			if (ret < 0) {
> +				pr_err(" Error: Failed to add events. "
> +				       " (%d)\n", ret);
> +			}
> +		}

What is this code for? params.sdt is true only if "--markers" is set, and that
should not be used with --add and --del, because it's an action "query markers".
We should give an error and abort here.

Other points are covered by Namhyung's review(thanks!).

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


