Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbbAILAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:00:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780AbbAILAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:00:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1417824042-539-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1417824042-539-2-git-send-email-linux@rasmusvillemoes.dk> <1417824042-539-1-git-send-email-linux@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        d.kasatkin@samsung.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 2/2] MPILIB: Deobfuscate mpi_cmp
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2257.1420801223.1@warthog.procyon.org.uk>
Date: Fri, 09 Jan 2015 11:00:23 +0000
Message-ID: <2258.1420801223@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks very reasonable.  cc'ing Dmitry for his check.

David
---
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> The condition preceding 'return 1;' makes my head hurt. At this point,
> we know that u and v have the same sign; if they are negative, they
> compare opposite to how their absolute values compare (which
> mpihelp_cmp found for us), otherwise cmp itself is the
> answer. Negating cmp is ok since mpihelp_cmp returns {-1,0,1};
> -INT_MIN==INT_MIN won't bite us.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  lib/mpi/mpi-cmp.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
> index 3801694240d8..d25e9e96c310 100644
> --- a/lib/mpi/mpi-cmp.c
> +++ b/lib/mpi/mpi-cmp.c
> @@ -61,10 +61,8 @@ int mpi_cmp(MPI u, MPI v)
>  	if (!usize)
>  		return 0;
>  	cmp = mpihelp_cmp(u->d, v->d, usize);
> -	if (!cmp)
> -		return 0;
> -	if ((cmp < 0 ? 1 : 0) == (u->sign ? 1 : 0))
> -		return 1;
> -	return -1;
> +	if (u->sign)
> +		return -cmp;
> +	return cmp;
>  }
>  EXPORT_SYMBOL_GPL(mpi_cmp);
> -- 
> 2.1.3
