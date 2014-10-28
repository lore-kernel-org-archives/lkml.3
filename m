Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaJ1U6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:58:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:62161 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbaJ1U6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:58:07 -0400
X-IronPort-AV: E=Sophos;i="5.04,805,1406584800"; 
   d="scan'208";a="103438219"
Date: Tue, 28 Oct 2014 21:58:05 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Wolfram Sang <wsa@the-dreams.de>
cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 4/4] coccinelle: api: add spatch to prevent
 unnecessary .owner
In-Reply-To: <1414514443-28943-5-git-send-email-wsa@the-dreams.de>
Message-ID: <alpine.DEB.2.02.1410282157510.2090@localhost6.localdomain6>
References: <1414514443-28943-1-git-send-email-wsa@the-dreams.de> <1414514443-28943-5-git-send-email-wsa@the-dreams.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

On Tue, 28 Oct 2014, Wolfram Sang wrote:

> There are calls which silently set the owner of a module. This is the
> preferred way [1], so avoid setting it manually. Currently, we only care
> about platform drivers, but there might be more calls to be added later.
> 
> [1] https://lkml.org/lkml/2014/10/12/87
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  scripts/coccinelle/api/platform_no_drv_owner.cocci | 106 +++++++++++++++++++++
>  1 file changed, 106 insertions(+)
>  create mode 100644 scripts/coccinelle/api/platform_no_drv_owner.cocci
> 
> diff --git a/scripts/coccinelle/api/platform_no_drv_owner.cocci b/scripts/coccinelle/api/platform_no_drv_owner.cocci
> new file mode 100644
> index 000000000000..e065b9e714fc
> --- /dev/null
> +++ b/scripts/coccinelle/api/platform_no_drv_owner.cocci
> @@ -0,0 +1,106 @@
> +/// Remove .owner field if calls are used which set it automatically
> +///
> +// Confidence: High
> +// Copyright: (C) 2014 Wolfram Sang. GPL v2.
> +
> +virtual patch
> +virtual context
> +virtual org
> +virtual report
> +
> +@match1@
> +declarer name module_platform_driver;
> +declarer name module_platform_driver_probe;
> +identifier __driver;
> +@@
> +(
> +	module_platform_driver(__driver);
> +|
> +	module_platform_driver_probe(__driver, ...);
> +)
> +
> +@fix1 depends on match1 && patch && !context && !org && !report@
> +identifier match1.__driver;
> +@@
> +	static struct platform_driver __driver = {
> +		.driver = {
> +-			.owner = THIS_MODULE,
> +		}
> +	};
> +
> +@match2@
> +identifier __driver;
> +@@
> +(
> +	platform_driver_register(&__driver)
> +|
> +	platform_driver_probe(&__driver, ...)
> +|
> +	platform_create_bundle(&__driver, ...)
> +)
> +
> +@fix2 depends on match2 && patch && !context && !org && !report@
> +identifier match2.__driver;
> +@@
> +	static struct platform_driver __driver = {
> +		.driver = {
> +-			.owner = THIS_MODULE,
> +		}
> +	};
> +
> +// ----------------------------------------------------------------------------
> +
> +@fix1_context depends on match1 && !patch && (context || org || report)@
> +identifier match1.__driver;
> +position j0;
> +@@
> +
> + 	static struct platform_driver __driver = {
> +		.driver = {
> +*			.owner@j0 = THIS_MODULE,
> +		}
> +	};
> +
> +@fix2_context depends on match2 && !patch && (context || org || report)@
> +identifier match2.__driver;
> +position j0;
> +@@
> +
> + 	static struct platform_driver __driver = {
> +		.driver = {
> +*			.owner@j0 = THIS_MODULE,
> +		}
> +	};
> +
> +// ----------------------------------------------------------------------------
> +
> +@script:python fix1_org depends on org@
> +j0 << fix1_context.j0;
> +@@
> +
> +msg = "No need to set .owner here. The core will do it."
> +coccilib.org.print_todo(j0[0], msg)
> +
> +@script:python fix2_org depends on org@
> +j0 << fix2_context.j0;
> +@@
> +
> +msg = "No need to set .owner here. The core will do it."
> +coccilib.org.print_todo(j0[0], msg)
> +
> +// ----------------------------------------------------------------------------
> +
> +@script:python fix1_report depends on report@
> +j0 << fix1_context.j0;
> +@@
> +
> +msg = "No need to set .owner here. The core will do it."
> +coccilib.report.print_report(j0[0], msg)
> +
> +@script:python fix2_report depends on report@
> +j0 << fix2_context.j0;
> +@@
> +
> +msg = "No need to set .owner here. The core will do it."
> +coccilib.report.print_report(j0[0], msg)
> +
> -- 
> 2.0.0
> 
> 
