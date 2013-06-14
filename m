Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3FNNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:25:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3FNNZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:25:25 -0400
Message-ID: <51BB19C2.4030208@suse.cz>
Date: Fri, 14 Jun 2013 15:25:22 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: strnape1@fel.cvut.cz
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr, julia.lawall@lip6.fr,
        Nicolas Palix <nicolas.palix@imag.fr>
Subject: Re: [PATCH] scripts: Coccinelle script for pci_free_consistent()
References: <20130508230308.Horde.hkDwg5wWGGBzmzKnqIjUhg1@wimap.feld.cvut.cz>
In-Reply-To: <20130508230308.Horde.hkDwg5wWGGBzmzKnqIjUhg1@wimap.feld.cvut.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.5.2013 23:03, strnape1@fel.cvut.cz wrote:
> Created coccinelle script for reporting missing pci_free_consistent() calls.
> 
> Signed-off-by: Petr Strnad <strnape1@fel.cvut.cz>

Julia, Nicolas, any comments about this patch?

Thanks,
Michal

> ---
> diff --git a/scripts/coccinelle/free/pci_free_consistent.cocci  
> b/scripts/coccinelle/free/pci_free_consistent.cocci
> new file mode 100644
> index 0000000..43600cc
> --- /dev/null
> +++ b/scripts/coccinelle/free/pci_free_consistent.cocci
> @@ -0,0 +1,52 @@
> +/// Find missing pci_free_consistent for every pci_alloc_consistent.
> +///
> +// Confidence: Moderate
> +// Copyright: (C) 2013 Petr Strnad.  GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Keywords: pci_free_consistent, pci_alloc_consistent
> +// Options: --no-includes --include-headers
> +
> +virtual report
> +virtual org
> +
> +@search@
> +local idexpression id;
> +expression x,y,z,e;
> +position p1,p2;
> +type T;
> +@@
> +
> +id = pci_alloc_consistent@p1(x,y,&z)
> +... when != e = id
> +if (id == NULL || ...) { ... return ...; }
> +... when != pci_free_consistent(x,y,id,z)
> +    when != if (id) { ... pci_free_consistent(x,y,id,z) ... }
> +    when != if (y) { ... pci_free_consistent(x,y,id,z) ... }
> +    when != e = (T)id
> +    when exists
> +(
> +return 0;
> +|
> +return 1;
> +|
> +return id;
> +|
> +return@p2 ...;
> +)
> +
> +@script:python depends on report@
> +p1 << search.p1;
> +p2 << search.p2;
> +@@
> +
> +msg = "ERROR: missing pci_free_consistent; pci_alloc_consistent on  
> line %s and return without freeing on line %s" % (p1[0].line,p2[0].line)
> +coccilib.report.print_report(p2[0],msg)
> +
> +@script:python depends on org@
> +p1 << search.p1;
> +p2 << search.p2;
> +@@
> +
> +msg = "ERROR: missing pci_free_consistent; pci_alloc_consistent on  
> line %s and return without freeing on line %s" % (p1[0].line,p2[0].line)
> +cocci.print_main(msg,p1)
> +cocci.print_secs("",p2)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


