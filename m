Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3KBOv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 10:51:56 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:19739
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131Ab3KBOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 10:51:54 -0400
X-IronPort-AV: E=Sophos;i="4.93,622,1378850400"; 
   d="scan'208";a="33235521"
Date: Sat, 2 Nov 2013 15:51:50 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Josh Triplett <josh@joshtriplett.org>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [PATCH] coccinelle: Add a script to find and remove unnecessary
 ifs with no body
In-Reply-To: <20131102143236.GA18084@leaf>
Message-ID: <alpine.DEB.2.02.1311021550330.2261@hadrien>
References: <20131102143236.GA18084@leaf>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Nov 2013, Josh Triplett wrote:

> This script matches code like:
>
> if (foo) {}
>
> and either eliminates it (if foo has no side effects) or replaces it
> with foo (if foo has side effects).
>
> Works perfectly in report mode; the results of patch mode are
> semantically correct but may still benefit from further simplification.

Actually, I would get rid of the patch mode.  Looking through some of the
results, I don't see any where just deleting the code is the right thing
to do.  They all look like cases where the developer wanted to remember to
think more about the problem.

julia

>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  scripts/coccinelle/misc/unnecessary-if.cocci | 40 ++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/unnecessary-if.cocci
>
> diff --git a/scripts/coccinelle/misc/unnecessary-if.cocci b/scripts/coccinelle/misc/unnecessary-if.cocci
> new file mode 100644
> index 0000000..7ed721f
> --- /dev/null
> +++ b/scripts/coccinelle/misc/unnecessary-if.cocci
> @@ -0,0 +1,40 @@
> +/// Remove unnecessary ifs with no statements.
> +//
> +// Confidence: High
> +// Options: --no-includes --include-headers
> +
> +virtual patch
> +virtual report
> +virtual context
> +
> +@r1 depends on patch@
> +expression E, E2, f;
> +@@
> +(
> +- if (
> +      <+... \(f(...)\|++E\|--E\|E++\|E--\|E=E2\) ...+>
> +- ) {}
> ++ ;
> +|
> +- if (E) {}
> +)
> +
> +@r2 depends on report || context@
> +expression E, E2, f;
> +position p;
> +@@
> +(
> +- if@p (
> +      <+... \(f(...)\|++E\|--E\|E++\|E--\|E=E2\) ...+>
> +- ) {}
> ++ ;
> +|
> +- if@p (E) {}
> +)
> +
> +@script:python depends on report@
> +p << r2.p;
> +@@
> +
> +msg = "WARNING: Unnecessary if with no body."
> +coccilib.report.print_report(p[0], msg)
> --
> 1.8.4.2
>
>
