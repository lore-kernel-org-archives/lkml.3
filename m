Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaLATxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:53:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbaLATxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:53:51 -0500
Date: Mon, 1 Dec 2014 20:53:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Kan Liang <kan.liang@intel.com>
Cc: acme@kernel.org, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V6 1/3] perf tool: Add sort key symoff for perf diff
Message-ID: <20141201195345.GA13302@krava.brq.redhat.com>
References: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417444812-22063-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:40:10AM -0500, Kan Liang wrote:

SNIP

> +static int64_t
> +sort__symoff_collapse(struct hist_entry *left, struct hist_entry *right)
> +{
> +	struct symbol *sym_l = left->ms.sym;
> +	struct symbol *sym_r = right->ms.sym;
> +	u64 symoff_l, symoff_r;
> +	int64_t ret;
> +
> +	if (!sym_l || !sym_r)
> +		return cmp_null(sym_l, sym_r);
> +
> +	ret = strcmp(sym_r->name, sym_l->name);
> +	if (ret)
> +		return ret;
> +
> +
> +	symoff_l = left->ip - sym_l->start;
> +	symoff_r = right->ip - sym_r->start;
> +
> +	return (int64_t)(symoff_r - symoff_l);
> +}
> +
> +static int hist_entry__symoff_snprintf(struct hist_entry *he, char *bf,
> +				    size_t size, unsigned int width)
> +{
> +	struct map *map = he->ms.map;
> +	struct symbol *sym = he->ms.sym;
> +	size_t ret = 0;
> +
> +	if (sym) {
> +		ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
> +		ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
> +				       he->ip - sym->start);
> +
> +	} else {
> +		size_t len = BITS_PER_LONG / 4;
> +
> +		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx", len,
> +				       map ? map->unmap_ip(map, he->ip) : he->ip);
> +	}
> +
> +	ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
> +			       width - ret, "");
> +	return ret;
> +}
> +
> +struct sort_entry sort_symoff = {
> +	.se_header	= "Symbol + Offset",
> +	.se_cmp		= sort__symoff_cmp,
> +	.se_snprintf	= hist_entry__symoff_snprintf,
> +	.se_width_idx	= HISTC_SYMOFF,
> +};

I might have missed this in previous discussions,
but do we also want just pure string comparison?

now I get:
     0.30%   +0.42%  main+0x110                         
     1.80%   -0.45%  main+0x115                         
     0.05%   -0.04%  main+0x118                         
     0.34%   +0.49%  main+0x11c                         
     2.15%   -0.22%  main+0x120                         
     0.41%   +0.22%  main+0x123                         
     1.86%   +0.04%  main+0x12f                         
     3.86%   -0.69%  main+0x133                         
     0.02%           main+0x137                         
     3.80%   -1.19%  main+0x13d                         
     0.26%   +0.45%  main+0x141                         
     2.26%   +1.41%  main+0x145                         
     8.78%   -1.59%  main+0x148                         
     0.05%           main+0x14c                         
     1.40%   -0.26%  main+0x155                         
     0.07%           main+0x158                         
     0.74%   -0.03%  main+0x15b                         
     1.06%   -0.17%  main+0x160                         
     0.31%   +0.30%  main+0x1a8                         
     1.82%   -0.51%  main+0x1af                         
     0.09%   +0.07%  main+0x1b1                         
     0.05%           main+0x1b4                         

could we add something like '-s symstr' to do
only symbol string comparison, so the previous
output would gather in single line like:

     5.09%   +2.07%  main


otherwise the patchset looks ok to me:
  Acked-by: Jiri Olsa <jolsa@kernel.org>


thanks,
jirka
