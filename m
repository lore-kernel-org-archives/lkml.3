Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162288AbaDCFs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 01:48:59 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57797 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162273AbaDCFsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 01:48:54 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com, bp@alien8.de
Subject: Re: [PATCH 1/4] perf: Allow ability to map cpus to nodes easily
In-Reply-To: <1395689577-214654-2-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:32:54 -0400")
References: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
	<1395689577-214654-2-git-send-email-dzickus@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Thu, 03 Apr 2014 14:48:51 +0900
Message-ID: <874n2byncs.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

(Adding Boris to CC as he might be interested)

On Mon, 24 Mar 2014 15:32:54 -0400, Don Zickus wrote:
> This patch figures out the max number of cpus and nodes that are on the
> system and creates a map of cpu to node.  This allows us to provide a cpu
> and quickly get the node associated with it.
>
> It was mostly copied from builtin-kmem.c and tweaked slightly to use less memory
> (use possible cpus instead of max).  It also calculates the max number of nodes.
>
> V3: simplify function names
>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/cpumap.c | 139 +++++++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/cpumap.h |  35 ++++++++++++
>  2 files changed, 174 insertions(+)
>
> diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
> index 7fe4994..2eb528e 100644
> --- a/tools/perf/util/cpumap.c
> +++ b/tools/perf/util/cpumap.c
> @@ -317,3 +317,142 @@ int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
>  {
>  	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
>  }
> +
> +/* setup simple routines to easily access node numbers given a cpu number */
> +static int __set_max_num(FILE *fp, int *max)
> +{
> +	int num;
> +	char buf[256];
> +
> +	num = fread(&buf, 1, sizeof(buf), fp);
> +	if (!num)
> +		return -1;
> +
> +	buf[num] = '\0';
> +
> +	/* start on the right, to find highest node num */
> +	while (--num) {
> +		if ((buf[num] == ',') || (buf[num] == '-')) {
> +			num++;
> +			break;
> +		}
> +	}
> +	if (sscanf(&buf[num], "%d", max) < 1)
> +		return -1;
> +
> +	/* convert from 0-based to 1-based */
> +	(*max)++;
> +
> +	return 0;
> +}
> +
> +/* Determine highest possible cpu in the system for sparse allocation */
> +static void set_max_cpu_num(void)
> +{
> +	FILE *fp;
> +	int ret = -1;
> +
> +	/* set up default */
> +	max_cpu_num = 4096;
> +
> +	/* get the highest possible cpu number for a sparse allocation */
> +	fp = fopen("/sys/devices/system/cpu/possible", "r");

More generally, this sysfs access needs to check actual mountpoint using
sysfs__mountpoint() IMHO.

Also this API can be generalized like reading int value from a sysfs
file as the filename itself represents the content in most cases.

So how about changing this way?  It might reside on somewhere in tools/lib/api/fs/.

  max_cpu_num = sysfs__read_int("devices/system/cpu/possible");

  max_node_num = sysfs__read_int("devices/system/node/possible");


Hmm.. looking at the code, perf already has filename__read_{int,str} API
in util/util.c.  Maybe you can just use it instead.

Thanks,
Namhyung
