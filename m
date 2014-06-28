Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912AbaF1R6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:58:39 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:35582
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbaF1R62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:58:28 -0400
X-IronPort-AV: E=Sophos;i="5.01,567,1400018400"; 
   d="scan'208";a="69376222"
Date: Sat, 28 Jun 2014 19:58:13 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH V3] scripts/coccinelle/free: add NULL test before freeing
 functions
In-Reply-To: <alpine.DEB.2.10.1406281955050.2538@hadrien>
Message-ID: <alpine.DEB.2.10.1406281957440.2538@hadrien>
References: <1403945247-21549-1-git-send-email-fabf@skynet.be> <alpine.DEB.2.10.1406281955050.2538@hadrien>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jun 2014, Julia Lawall wrote:

> On Sat, 28 Jun 2014, Fabian Frederick wrote:
>
> > Warns or generates patch for NULL check before the following functions:
> >
> > kfree
> > usb_free_urb
> > debugfs_remove
> > debugfs_remove_recursive
> >
> > Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> > Cc: Gilles Muller <Gilles.Muller@lip6.fr>
> > Cc: Joe Perches <joe@perches.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> > ---
> >
> > V3:
> >    -Update print_main message.
> >    -Add patch mode (suggested by Julia Lawall)
> >
> > V2:
> >    -Add 3 more functions to kfree (suggested by Joe Perches)
> >    -Update warning message to involve code analysis (suggested by Julia Lawall)
> >
> >  scripts/coccinelle/free/ifnullfree.cocci | 53 ++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> >  create mode 100644 scripts/coccinelle/free/ifnullfree.cocci
> >
> > diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
> > new file mode 100644
> > index 0000000..c826d98
> > --- /dev/null
> > +++ b/scripts/coccinelle/free/ifnullfree.cocci
> > @@ -0,0 +1,53 @@
> > +/// NULL check before some freeing functions is not needed.
> > +///
> > +/// Based on checkpatch warning
> > +/// "kfree(NULL) is safe this check is probably not required"
> > +/// and kfreeaddr.cocci by Julia Lawall.
> > +///
> > +/// Comments: -
> > +/// Options: --no-includes --include-headers
> > +
> > +virtual patch
> > +virtual org
> > +virtual report
> > +virtual context
> > +
> > +@r2 depends on patch@
> > +expression E;
> > +@@
> > +- if (E)
> > +(
> > +-	kfree(E);
> > ++ kfree(E);
> > +|
> > +-	debugfs_remove(E);
> > ++ debugfs_remove(E);
> > +|
> > +-	debugfs_remove_recursive(E);
> > ++ debugfs_remove_recursive(E);
> > +|
> > +-	usb_free_urb(E);
> > ++ usb_free_urb(E);
> > +)
> > +
> > +@r depends on context || report || org @
> > +expression E;
> > +position p;
> > +@@
> > +
> > +* if (E)
> > +*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
> > +
> > +@script:python depends on org@
> > +p << r.p;
> > +@@
> > +
> > +cocci.print_main("NULL check before that freeing function is not needed", p)
> > +
> > +@script:python depends on report@
> > +p << r.p;
> > +@@
> > +
> > +msg = "WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values."
> > +coccilib.report.print_report(p[0], msg)
> > +
> > --
> > 1.8.4.5
> >
> >
>
