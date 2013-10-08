Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3JHHSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:18:08 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:42309 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3JHHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:18:04 -0400
X-AuditID: 9c93017e-b7bd7ae00000460c-71-5253b1aa4014
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V4 2/9] perf tools: validate kcore module addresses
References: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com>
	<1381128618-22721-3-git-send-email-adrian.hunter@intel.com>
Date: Tue, 08 Oct 2013 16:18:02 +0900
In-Reply-To: <1381128618-22721-3-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 7 Oct 2013 09:50:11 +0300")
Message-ID: <87ob70kz85.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon,  7 Oct 2013 09:50:11 +0300, Adrian Hunter wrote:
> Before using kcore we need to check that modules are
> in memory at the same addresses that they were when
> data was recorded.
>
> This is done because, while we could remap symbols
> to different addresses, the object code linkages
> would still be different which would provide an
> erroneous view of the object code.

[SNIP]
>  
> -static int kcore_mapfn(u64 start, u64 len, u64 pgoff, void *data)
> +static void add_module(struct module_info *mi, struct rb_root *modules)
>  {
> -	struct kcore_mapfn_data *md = data;
> -	struct map *map;
> +	struct rb_node **p = &modules->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct module_info *m;
>  
> -	map = map__new2(start, md->dso, md->type);
> -	if (map == NULL)
> +	while (*p != NULL) {
> +		parent = *p;
> +		m = rb_entry(parent, struct module_info, rb_node);
> +		if (strcmp(mi->name, m->name) < 0)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +	rb_link_node(&mi->rb_node, parent, p);
> +	rb_insert_color(&mi->rb_node, modules);
> +}

[SNIP]

> +static int __read_proc_modules(void *arg, const char *name, u64 start)
> +{
> +	struct rb_root *modules = arg;
> +	struct module_info *mi;
> +
> +	mi = zalloc(sizeof(struct module_info));
> +	if (!mi)
>  		return -ENOMEM;
>  
> -	map->end = map->start + len;
> -	map->pgoff = pgoff;
> +	mi->name = strdup(name);
> +	mi->start = start;
>  
> -	list_add(&map->node, &md->maps);
> +	add_module(mi, modules);
> +
> +	if (!mi->name)
> +		return -ENOMEM;

Why did you add the mi if it failed to allocate name?  I guess it'd
crash since the add_module() uses mi->name for strcmp().

Thanks,
Namhyung

> +
> +	return 0;
> +}
