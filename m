Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaACN3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:29:55 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46572
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbaACN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:29:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384297200"; 
   d="scan'208";a="43372044"
Date: Fri, 3 Jan 2014 14:29:35 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Michal Marek <mmarek@suse.cz>
cc: Nishanth Menon <nm@ti.com>, Julia.Lawall@lip6.fr, Gilles.Muller@lip6.fr,
        nicolas.palix@imag.fr, linux-kernel@vger.kernel.org,
        cocci@systeme.lip6.fr, linux-pm@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH resend] scripts: Coccinelle script for pm_runtime_* return
 checks with IS_ERR_VALUE
In-Reply-To: <52C6B3C8.7040509@suse.cz>
Message-ID: <alpine.DEB.2.10.1401031429140.2095@hadrien>
References: <1385991581-16843-1-git-send-email-nm@ti.com> <52C6B3C8.7040509@suse.cz>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Jan 2014, Michal Marek wrote:

> On 2013-12-02 14:39, Nishanth Menon wrote:
> > As indicated by Sekhar in [1], there seems to be a tendency to use
> > IS_ERR_VALUE to check the error result for pm_runtime_* functions which
> > make no sense considering commit c48cd65 (ARM: OMAP: use consistent
> > error checking) - the error values can either be < 0 for error OR
> > 0, 1 in cases where we have success.
> >
> > So, setup a coccinelle script to help identify the same.
>
> Julia, Gilles, do you have any objections to this semantic patch?

No objections.

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

>
> Thanks,
> Michal
> >
> > [1] http://marc.info/?t=138472678100003&r=1&w=2
> >
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Reported-by: Sekhar Nori <nsekhar@ti.com>
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> > Original post: http://marc.info/?t=138559437300001&r=1&w=2
> >
> >  scripts/coccinelle/api/pm_runtime.cocci |  109 +++++++++++++++++++++++++++++++
> >  1 file changed, 109 insertions(+)
> >  create mode 100644 scripts/coccinelle/api/pm_runtime.cocci
> >
> > diff --git a/scripts/coccinelle/api/pm_runtime.cocci b/scripts/coccinelle/api/pm_runtime.cocci
> > new file mode 100644
> > index 0000000..f01789e
> > --- /dev/null
> > +++ b/scripts/coccinelle/api/pm_runtime.cocci
> > @@ -0,0 +1,109 @@
> > +/// Make sure pm_runtime_* calls does not use unnecessary IS_ERR_VALUE
> > +//
> > +// Keywords: pm_runtime
> > +// Confidence: Medium
> > +// Copyright (C) 2013 Texas Instruments Incorporated - GPLv2.
> > +// URL: http://coccinelle.lip6.fr/
> > +// Options: --include-headers
> > +
> > +virtual patch
> > +virtual context
> > +virtual org
> > +virtual report
> > +
> > +//----------------------------------------------------------
> > +//  Detection
> > +//----------------------------------------------------------
> > +
> > +@runtime_bad_err_handle exists@
> > +expression ret;
> > +@@
> > +(
> > +ret = \(pm_runtime_idle\|
> > +	pm_runtime_suspend\|
> > +	pm_runtime_autosuspend\|
> > +	pm_runtime_resume\|
> > +	pm_request_idle\|
> > +	pm_request_resume\|
> > +	pm_request_autosuspend\|
> > +	pm_runtime_get\|
> > +	pm_runtime_get_sync\|
> > +	pm_runtime_put\|
> > +	pm_runtime_put_autosuspend\|
> > +	pm_runtime_put_sync\|
> > +	pm_runtime_put_sync_suspend\|
> > +	pm_runtime_put_sync_autosuspend\|
> > +	pm_runtime_set_active\|
> > +	pm_schedule_suspend\|
> > +	pm_runtime_barrier\|
> > +	pm_generic_runtime_suspend\|
> > +	pm_generic_runtime_resume\)(...);
> > +...
> > +IS_ERR_VALUE(ret)
> > +...
> > +)
> > +
> > +//----------------------------------------------------------
> > +//  For context mode
> > +//----------------------------------------------------------
> > +
> > +@depends on runtime_bad_err_handle && context@
> > +identifier pm_runtime_api;
> > +expression ret;
> > +@@
> > +(
> > +ret = pm_runtime_api(...);
> > +...
> > +* IS_ERR_VALUE(ret)
> > +...
> > +)
> > +
> > +//----------------------------------------------------------
> > +//  For patch mode
> > +//----------------------------------------------------------
> > +
> > +@depends on runtime_bad_err_handle && patch@
> > +identifier pm_runtime_api;
> > +expression ret;
> > +@@
> > +(
> > +ret = pm_runtime_api(...);
> > +...
> > +- IS_ERR_VALUE(ret)
> > ++ ret < 0
> > +...
> > +)
> > +
> > +//----------------------------------------------------------
> > +//  For org and report mode
> > +//----------------------------------------------------------
> > +
> > +@r depends on runtime_bad_err_handle exists@
> > +position p1, p2;
> > +identifier pm_runtime_api;
> > +expression ret;
> > +@@
> > +(
> > +ret = pm_runtime_api@p1(...);
> > +...
> > +IS_ERR_VALUE@p2(ret)
> > +...
> > +)
> > +
> > +@script:python depends on org@
> > +p1 << r.p1;
> > +p2 << r.p2;
> > +pm_runtime_api << r.pm_runtime_api;
> > +@@
> > +
> > +cocci.print_main(pm_runtime_api,p1)
> > +cocci.print_secs("IS_ERR_VALUE",p2)
> > +
> > +@script:python depends on report@
> > +p1 << r.p1;
> > +p2 << r.p2;
> > +pm_runtime_api << r.pm_runtime_api;
> > +@@
> > +
> > +msg = "%s returns < 0 as error. Unecessary IS_ERR_VALUE at line %s" % (pm_runtime_api, p2[0].line)
> > +coccilib.report.print_report(p1[0],msg)
> >
>
>
