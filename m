Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaKQPbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:31:01 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:42195 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbaKQPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:30:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,403,1413237600"; 
   d="scan'208";a="107663365"
Date: Mon, 17 Nov 2014 16:30:11 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>, Michal Marek <mmarek@suse.cz>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] scripts/coccinelle: catch freeing cryptographic
 structures via kfree
In-Reply-To: <20141117151420.10739.16342.stgit@buzz>
Message-ID: <alpine.DEB.2.10.1411171628230.2532@hadrien>
References: <20141117151420.10739.16342.stgit@buzz>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2014, Konstantin Khlebnikov wrote:

> Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
>
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> ---
>  scripts/coccinelle/free/crypto_free.cocci |   45 +++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 scripts/coccinelle/free/crypto_free.cocci
>
> diff --git a/scripts/coccinelle/free/crypto_free.cocci b/scripts/coccinelle/free/crypto_free.cocci
> new file mode 100644
> index 0000000..0799b70
> --- /dev/null
> +++ b/scripts/coccinelle/free/crypto_free.cocci
> @@ -0,0 +1,45 @@
> +///
> +/// Structures allocated by crypto_alloc_* must be freed using crypto_free_*.
> +/// This finds freeing them by kfree.
> +///
> +// Confidence: Moderate
> +// Copyright: (C) 2014 Konstantin Khlebnikov,  GPLv2.
> +// Comments: There are false positives in crypto/ where they are actually freed.
> +// Keywords: crypto, kfree
> +// Options: --no-includes --include-headers
> +
> +virtual org
> +virtual report
> +virtual context
> +
> +@r depends on context || org || report@
> +expression x;
> +identifier crypto_alloc =~ "^crypto_alloc_";
> +@@
> +
> +(
> + x = crypto_alloc(...)
> +)

You can drop the outer parentheses, in this case and in the kfree case.

Are there many of these crypto_alloc_ functions?  It would be nicer to
avoid the regular expression.  For one thing, you don't have much control
over what it matches, and for another thing Coccinelle will not be able to
optimize the selection of files.  With the regular expression it will have
to parse every file and analyze every function, which will be slow.

julia

> +
> +@pb@
> +expression r.x;
> +position p;
> +@@
> +
> +(
> +* kfree@p(x)
> +)
> +
> +@script:python depends on org@
> +p << pb.p;
> +@@
> +
> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
> +coccilib.org.print_todo(p[0], msg)
> +
> +@script:python depends on report@
> +p << pb.p;
> +@@
> +
> +msg="WARNING: invalid free of crypto_alloc_* allocated data"
> +coccilib.report.print_report(p[0], msg)
>
>
