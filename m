Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbaE2MjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:39:23 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52452 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaE2MjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:39:22 -0400
Message-ID: <53872A72.6040007@hitachi.com>
Date: Thu, 29 May 2014 21:39:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find correct
 variable DIE
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Here is the patch which fixes perf probe to find variable
location correctly, on the recent dwarf format. This is not
related to the SEGV issue which I fixed in previous mail.

Thank you,

(2014/05/29 21:19), Masami Hiramatsu wrote:
> Fix perf probe to find correct variable DIE which has location or
> external instance by tracking down the lexical blocks.
> 
> Current die_find_variable() expects that the all variable DIEs
> which has DW_TAG_variable have a location. However, since recent
> dwarf information may have declaration variable DIEs at the
> entry of function (subprogram), die_find_variable() returns it.
> 
> To solve this problem, it must track down the DIE tree to find
> a DIE which has an actual location or a reference for external
> instance.
> 
> e.g. finding a DIE which origin is <0xdc73>;
> 
>  <1><11496>: Abbrev Number: 95 (DW_TAG_subprogram)
>     <11497>   DW_AT_abstract_origin: <0xdc42>
>     <1149b>   DW_AT_low_pc      : 0x1850
> [...]
>  <2><114cc>: Abbrev Number: 119 (DW_TAG_variable) <- this is a declaration
>     <114cd>   DW_AT_abstract_origin: <0xdc73>
>  <2><114d1>: Abbrev Number: 119 (DW_TAG_variable)
> [...]
>  <3><115a7>: Abbrev Number: 105 (DW_TAG_lexical_block)
>     <115a8>   DW_AT_ranges      : 0xaa0
>  <4><115ac>: Abbrev Number: 96 (DW_TAG_variable) <- this has a location
>     <115ad>   DW_AT_abstract_origin: <0xdc73>
>     <115b1>   DW_AT_location    : 0x486c        (location list)
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/dwarf-aux.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
> index 7defd77..cc66c40 100644
> --- a/tools/perf/util/dwarf-aux.c
> +++ b/tools/perf/util/dwarf-aux.c
> @@ -747,14 +747,17 @@ struct __find_variable_param {
>  static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
>  {
>  	struct __find_variable_param *fvp = data;
> +	Dwarf_Attribute attr;
>  	int tag;
>  
>  	tag = dwarf_tag(die_mem);
>  	if ((tag == DW_TAG_formal_parameter ||
>  	     tag == DW_TAG_variable) &&
> -	    die_compare_name(die_mem, fvp->name))
> +	    die_compare_name(die_mem, fvp->name) &&
> +	/* Does the DIE have location information or external instance? */
> +	    (dwarf_attr(die_mem, DW_AT_external, &attr) ||
> +	     dwarf_attr(die_mem, DW_AT_location, &attr)))
>  		return DIE_FIND_CB_END;
> -
>  	if (dwarf_haspc(die_mem, fvp->addr))
>  		return DIE_FIND_CB_CONTINUE;
>  	else
> 
> 
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


