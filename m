Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaF0UNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 16:13:35 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:23461 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaF0UNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:13:34 -0400
X-IronPort-AV: E=Sophos;i="5.01,562,1400018400"; 
   d="scan'208";a="82590068"
Date: Fri, 27 Jun 2014 22:13:32 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] scripts/coccinelle/free: add NULL test before freeing
 functions
In-Reply-To: <1403899335-3867-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1406272212430.2042@localhost6.localdomain6>
References: <1403899335-3867-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why not make a patch case that removes the test?  Since the expression is 
duplicated in the test and in the argument to kfree it does not seem 
likely that it will have a side effect.

julia

On Fri, 27 Jun 2014, Fabian Frederick wrote:

> Warns on NULL check before the following functions:
> 
> kfree
> usb_free_urb
> debugfs_remove
> debugfs_remove_recursive
> 
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> Cc: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2:
>    -Add 3 more functions to kfree (suggested by Joe Perches)
>    -Update warning message to involve code analysis (suggested by Julia Lawall)
> 
>  scripts/coccinelle/free/ifnullfree.cocci | 34 ++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 scripts/coccinelle/free/ifnullfree.cocci
> 
> diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
> new file mode 100644
> index 0000000..626309c
> --- /dev/null
> +++ b/scripts/coccinelle/free/ifnullfree.cocci
> @@ -0,0 +1,34 @@
> +/// NULL check before some freeing functions is not needed.
> +///
> +/// Based on checkpatch warning
> +/// "kfree(NULL) is safe this check is probably not required"
> +/// and kfreeaddr.cocci by Julia Lawall.
> +///
> +/// Comments: -
> +/// Options: --no-includes --include-headers
> +
> +virtual org
> +virtual report
> +virtual context
> +
> +@r depends on context || report || org @
> +expression E;
> +position p;
> +@@
> +
> +* if (E)
> +*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
> +
> +@script:python depends on org@
> +p << r.p;
> +@@
> +
> +cocci.print_main("freeing", p)
> +
> +@script:python depends on report@
> +p << r.p;
> +@@
> +
> +msg = "WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values."
> +coccilib.report.print_report(p[0], msg)
> +
> -- 
> 1.8.4.5
> 
> 
