Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaLIVH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:07:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:56325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbaLIVHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:07:25 -0500
Date: Tue, 9 Dec 2014 18:07:17 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, ananth@in.ibm.com
Subject: Re: [RFC PATCH 2/8] perf probe powerpc: Fix symbol fixup issues due
 to ELF type
Message-ID: <20141209210717.GA8788@kernel.org>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
 <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0412a00009a22762f92c208964df6f842796464e.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 09, 2014 at 11:04:00PM +0530, Naveen N. Rao escreveu:
> If using the symbol table, symbol addresses are not being fixed up
> properly, resulting in probes being placed at wrong addresses:
> 
>   # perf probe do_fork
>   Added new event:
>     probe:do_fork        (on do_fork)
> 
>   You can now use it in all perf tools, such as:
> 
> 	  perf record -e probe:do_fork -aR sleep 1
> 
>   # cat /sys/kernel/debug/tracing/kprobe_events
>   p:probe/do_fork _text+635952
>   # printf "%x" 635952
>   9b430
>   # grep do_fork /boot/System.map
>   c0000000000ab430 T .do_fork
> 
> Fix by checking for ELF type ET_DYN used by ppc64 kernels.

Are you sure this doesn't need to be enclosed in ifdef PPC64?

- Arnaldo
 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  tools/perf/util/symbol-elf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 1e23a5b..67e4392 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -629,7 +629,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
>  						     NULL) != NULL);
>  	} else {
>  		ss->adjust_symbols = ehdr.e_type == ET_EXEC ||
> -				     ehdr.e_type == ET_REL;
> +				     ehdr.e_type == ET_REL ||
> +				     ehdr.e_type == ET_DYN;
>  	}
>  
>  	ss->name   = strdup(name);
> -- 
> 2.1.3
