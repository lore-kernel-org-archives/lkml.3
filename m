Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbaD2QSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:18:52 -0400
Received: from smtp-out-078.synserver.de ([212.40.185.78]:1044 "EHLO
	smtp-out-008.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757871AbaD2QSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:18:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19950
Message-ID: <535FD0E0.70809@metafoo.de>
Date: Tue, 29 Apr 2014 18:18:40 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [Cocci] [PATCH v2 1/1] scripts/coccinelle: use BIT macro if used
References: <1398595800-6683-1-git-send-email-javier@dowhile0.org>
In-Reply-To: <1398595800-6683-1-git-send-email-javier@dowhile0.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 12:50 PM, Javier Martinez Canillas wrote:
> Using the BIT() macro instead of manually shifting bits
> makes the code less error prone.
>
> If is more readable is a matter of taste so only replace
> if the file is already using this macro.
>
> Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>

I don't think this should be enabled by default. It will generate a ton of 
false positives, not everything that is 1 shifted by something is a 
single-bit field. E.g. imagine a device with multi-bit fields:

#define FOOBAR_A (0 << FOOBAR_OFFSET)
#define FOOBAR_B (1 << FOOBAR_OFFSET)
#define FOOBAR_C (2 << FOOBAR_OFFSET)
#define FOOBAR_D (3 << FOOBAR_OFFSET)

The script will now suggest to replace FOOBAR_B (1 << FOOBAR_OFFSET) with 
FOOBAR_B BIT(FOOBAR_OFFSET). Which is technically correct, but not semantically.

- Lars

> ---
>
> Changes since v1:
>   - Add a rule that checks if the file is already using this macro
>     as suggested by Julia Lawall
>
>   scripts/coccinelle/api/bit.cocci | 30 ++++++++++++++++++++++++++++++
>   1 file changed, 30 insertions(+)
>   create mode 100644 scripts/coccinelle/api/bit.cocci
>
> diff --git a/scripts/coccinelle/api/bit.cocci b/scripts/coccinelle/api/bit.cocci
> new file mode 100644
> index 0000000..a02cfd3
> --- /dev/null
> +++ b/scripts/coccinelle/api/bit.cocci
> @@ -0,0 +1,30 @@
> +// Use the BIT() macro if is already used
> +//
> +// Confidence: High
> +// Copyright (C) 2014 Javier Martinez Canillas.  GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Options: --include-headers
> +
> +@hasbitops@
> +@@
> +
> +#include <linux/bitops.h>
> +
> +@usesbit@
> +@@
> +
> +BIT(...)
> +
> +@depends on hasbitops && usesbit@
> +expression E;
> +@@
> +
> +- 1 << E
> ++ BIT(E)
> +
> +@depends on hasbitops && usesbit@
> +expression E;
> +@@
> +
> +- BIT((E))
> ++ BIT(E)
>

