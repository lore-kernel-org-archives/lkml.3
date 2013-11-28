Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab3K1NAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:00:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50073 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758865Ab3K1NAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:00:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nishanth Menon <nm@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Daniel Mack <zonque@gmail.com>,
        linux-omap@vger.kernel.org, joelf@ti.com, gururaja.hebbar@ti.com,
        balajitk@ti.com, s.neumann@raumfeld.com, Russ.Dill@ti.com,
        vaibhav.bedia@gmail.com, linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@linaro.org>, Julia.Lawall@lip6.fr,
        Gilles.Muller@lip6.fr, nicolas.palix@imag.fr, mmarek@suse.cz,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr,
        rmk+kernel@arm.linux.org.uk, linux-pm@vger.kernel.org
Subject: Re: pm_runtime functions and IS_ERR_VALUE (was Re: [PATCH v6] ARM: omap: edma: add suspend suspend/resume hooks)
Date: Thu, 28 Nov 2013 14:13:04 +0100
Message-ID: <3296671.QxQGfYsfND@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131127231541.GA8418@kahuna>
References: <1384726754-27875-1-git-send-email-zonque@gmail.com> <5295F99F.6010203@ti.com> <20131127231541.GA8418@kahuna>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 27, 2013 05:15:41 PM Nishanth Menon wrote:
> Change in subject line + wider forum
> 
> On 19:24-20131127, Sekhar Nori wrote:
> > On Wednesday 27 November 2013 07:17 PM, Daniel Mack wrote:
> > > On 11/27/2013 02:35 PM, Sekhar Nori wrote:
> > >> On Monday 18 November 2013 03:49 AM, Daniel Mack wrote:
> > >>> +static int edma_pm_suspend(struct device *dev)
> > >>> +{
> > >>> +	int j, r;
> > >>> +
> > >>> +	r = pm_runtime_get_sync(dev);
> > >>> +	if (IS_ERR_VALUE(r)) {
> > >>
> > >> So IS_ERR_VALUE() is only for functions which may return a negative
> > >> number outside of MAX_ERRNO as a success indication.
> > >> pm_runtime_get_sync() does not appear to be one of them so just use"
> > >>
> > >> if (r < 0) { .. }
> > > 
> > > That's true. Thanks for catching this, I'll fix it. However, grepping
> > > through the tree, there are quite a lot places where the same mistake is
> > > made.
> > 
> > Yes, this is a common fallacy. Russell cleaned up a bunch of these a
> > while back.
> 
> Thinking a little more on this front, to prevent recurrence and fixing
> the ones we already have, how about something like the following
> patch?

Looks reasonable -  if the result survives the auto build testing. :-)

Thanks!

> For example, on 3.13-rc1, with omap2plus_defconfig, I see the following:
> http://pastebin.mozilla.org/3681911
> 
> -->8--
> From b7946d214fab72b2e18cd67eec01c377f1cddee8 Mon Sep 17 00:00:00 2001
> From: Nishanth Menon <nm@ti.com>
> Date: Wed, 27 Nov 2013 17:01:20 -0600
> Subject: [RFC PATCH] scripts: Coccinelle script for pm_runtime_* return checks
>  with IS_ERR_VALUE
> 
> As indicated by Sekhar in [1], there seems to be a tendency to use
> IS_ERR_VALUE to check the error result for pm_runtime_* functions which
> make no sense considering commit c48cd65 (ARM: OMAP: use consistent
> error checking) - the error values can either be < 0 for error OR
> 0, 1 in cases where we have success.
> 
> So, setup a coccinelle script to help identify the same.
> 
> [1] http://marc.info/?t=138472678100003&r=1&w=2
> 
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Reported-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  scripts/coccinelle/api/pm_runtime.cocci |  109 +++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>  create mode 100644 scripts/coccinelle/api/pm_runtime.cocci
> 
> diff --git a/scripts/coccinelle/api/pm_runtime.cocci b/scripts/coccinelle/api/pm_runtime.cocci
> new file mode 100644
> index 0000000..f01789e
> --- /dev/null
> +++ b/scripts/coccinelle/api/pm_runtime.cocci
> @@ -0,0 +1,109 @@
> +/// Make sure pm_runtime_* calls does not use unnecessary IS_ERR_VALUE
> +//
> +// Keywords: pm_runtime
> +// Confidence: Medium
> +// Copyright (C) 2013 Texas Instruments Incorporated - GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Options: --include-headers
> +
> +virtual patch
> +virtual context
> +virtual org
> +virtual report
> +
> +//----------------------------------------------------------
> +//  Detection
> +//----------------------------------------------------------
> +
> +@runtime_bad_err_handle exists@
> +expression ret;
> +@@
> +(
> +ret = \(pm_runtime_idle\|
> +	pm_runtime_suspend\|
> +	pm_runtime_autosuspend\|
> +	pm_runtime_resume\|
> +	pm_request_idle\|
> +	pm_request_resume\|
> +	pm_request_autosuspend\|
> +	pm_runtime_get\|
> +	pm_runtime_get_sync\|
> +	pm_runtime_put\|
> +	pm_runtime_put_autosuspend\|
> +	pm_runtime_put_sync\|
> +	pm_runtime_put_sync_suspend\|
> +	pm_runtime_put_sync_autosuspend\|
> +	pm_runtime_set_active\|
> +	pm_schedule_suspend\|
> +	pm_runtime_barrier\|
> +	pm_generic_runtime_suspend\|
> +	pm_generic_runtime_resume\)(...);
> +...
> +IS_ERR_VALUE(ret)
> +...
> +)
> +
> +//----------------------------------------------------------
> +//  For context mode
> +//----------------------------------------------------------
> +
> +@depends on runtime_bad_err_handle && context@
> +identifier pm_runtime_api;
> +expression ret;
> +@@
> +(
> +ret = pm_runtime_api(...);
> +...
> +* IS_ERR_VALUE(ret)
> +...
> +)
> +
> +//----------------------------------------------------------
> +//  For patch mode
> +//----------------------------------------------------------
> +
> +@depends on runtime_bad_err_handle && patch@
> +identifier pm_runtime_api;
> +expression ret;
> +@@
> +(
> +ret = pm_runtime_api(...);
> +...
> +- IS_ERR_VALUE(ret)
> ++ ret < 0
> +...
> +)
> +
> +//----------------------------------------------------------
> +//  For org and report mode
> +//----------------------------------------------------------
> +
> +@r depends on runtime_bad_err_handle exists@
> +position p1, p2;
> +identifier pm_runtime_api;
> +expression ret;
> +@@
> +(
> +ret = pm_runtime_api@p1(...);
> +...
> +IS_ERR_VALUE@p2(ret)
> +...
> +)
> +
> +@script:python depends on org@
> +p1 << r.p1;
> +p2 << r.p2;
> +pm_runtime_api << r.pm_runtime_api;
> +@@
> +
> +cocci.print_main(pm_runtime_api,p1)
> +cocci.print_secs("IS_ERR_VALUE",p2)
> +
> +@script:python depends on report@
> +p1 << r.p1;
> +p2 << r.p2;
> +pm_runtime_api << r.pm_runtime_api;
> +@@
> +
> +msg = "%s returns < 0 as error. Unecessary IS_ERR_VALUE at line %s" % (pm_runtime_api, p2[0].line)
> +coccilib.report.print_report(p1[0],msg)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
