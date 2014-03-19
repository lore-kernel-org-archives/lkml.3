Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbaCSMsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbaCSMsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:48:36 -0400
Date: Wed, 19 Mar 2014 13:48:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 04/19] perf: Allow ability to map cpus to nodes easily
Message-ID: <20140319124827.GB7423@krava.brq.redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609388-40489-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:42:53PM -0500, Don Zickus wrote:
> This patch figures out the max number of cpus and nodes that are on the

SNIP

> +
> +int cpu_map__setup_cpunode_map(void)
> +{
> +	struct dirent *dent1, *dent2;
> +	DIR *dir1, *dir2;
> +	unsigned int cpu, mem;
> +	char buf[PATH_MAX];
> +
> +	/* initialize globals */
> +	if (init_cpunode_map())
> +		return -1;
> +
> +	dir1 = opendir(PATH_SYS_NODE);
> +	if (!dir1)
> +		return 0;
> +
> +	/* walk tree and setup map */
> +	while ((dent1 = readdir(dir1)) != NULL) {
> +		if (dent1->d_type != DT_DIR ||
> +		    sscanf(dent1->d_name, "node%u", &mem) < 1)
> +			continue;
> +
> +		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
> +		dir2 = opendir(buf);
> +		if (!dir2)
> +			continue;
> +		while ((dent2 = readdir(dir2)) != NULL) {
> +			if (dent2->d_type != DT_LNK ||
> +			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
> +				continue;
> +			cpunode_map[cpu] = mem;
> +		}
> +		closedir(dir2);
> +	}
> +	closedir(dir1);
> +	return 0;
> +}
> +
> diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
> index b123bb9..d6fde2b 100644
> --- a/tools/perf/util/cpumap.h
> +++ b/tools/perf/util/cpumap.h
> @@ -4,6 +4,9 @@
>  #include <stdio.h>
>  #include <stdbool.h>
>  
> +#include "perf.h"
> +#include "util/debug.h"
> +
>  struct cpu_map {
>  	int nr;
>  	int map[];
> @@ -46,4 +49,36 @@ static inline bool cpu_map__empty(const struct cpu_map *map)
>  	return map ? map->map[0] == -1 : true;
>  }
>  
> +int max_cpu_num;
> +int max_node_num;
> +int *cpunode_map;
> +
> +int cpu_map__setup_cpunode_map(void);
> +
> +static inline int cpu_map__max_node(void)
> +{
> +	if (unlikely(!max_node_num))
> +		pr_debug("cpu_map not initiailzed\n");
> +
> +	return max_node_num;
> +}
> +
> +static inline int cpu_map__max_cpu(void)
> +{
> +	if (unlikely(!max_cpu_num))
> +		pr_debug("cpu_map not initiailzed\n");
> +
> +	return max_cpu_num;
> +}
> +
> +static inline int cpu_map__get_node(int cpu)
> +{
> +	if (unlikely(cpunode_map == NULL)) {
> +		pr_debug("cpu_map not initialized\n");
> +		return -1;
> +	}
> +
> +	return cpunode_map[cpu];
> +}

cool, maybe above function names should not have 'cpu_map..',
it's like pure cpu-ish stuff, maybe:

  setup_cpunode_map
  cpu__max_node
  cpu__max_cpu
  cpu__get_node

or something like that ;-)

jirka
