Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaEWQyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbaEWQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:54:50 -0400
Date: Fri, 23 May 2014 18:54:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/7] perf: Add support to dynamically get cacheline size
Message-ID: <20140523165405.GE1074@krava>
References: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
 <1400526833-141779-7-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400526833-141779-7-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:13:52PM -0400, Don Zickus wrote:
> Different arches may have different cacheline sizes.  Look it up and set
> a global variable for reference.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  tools/perf/util/cpumap.c | 31 +++++++++++++++++++++++++++++++
>  tools/perf/util/cpumap.h | 12 ++++++++++++
>  tools/perf/util/sort.c   |  3 +++
>  3 files changed, 46 insertions(+)
> 
> diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
> index c4e55b7..d833238 100644
> --- a/tools/perf/util/cpumap.c
> +++ b/tools/perf/util/cpumap.c
> @@ -477,3 +477,34 @@ int cpu__setup_cpunode_map(void)
>  	closedir(dir1);
>  	return 0;
>  }
> +
> +int cpu__setup_cacheline_size(void)
> +{
> +	const char *mnt;
> +	char path[PATH_MAX];
> +	int n, ret, size;
> +	FILE *fp;
> +	
> +
> +	mnt = sysfs__mountpoint();
> +	if (!mnt)
> +		return -1;
> +
> +	n = snprintf(path, PATH_MAX, "%s/devices/system/cpu/cpu0/cache/index0/coherency_line_size", mnt);
> +	if (n == PATH_MAX) {
> +		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
> +		return -1;
> +	}
> +
> +	fp = fopen(path, "r");
> +	if (!fp)
> +		return -1;
> +	ret = fscanf(fp, "%d", &size);
> +	fclose(fp);
> +	if (ret != 1)
> +		return -1;

you can use filename__read_int

jirka
