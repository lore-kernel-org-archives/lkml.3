Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaKPPoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 10:44:10 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:32481
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198AbaKPPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 10:44:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,397,1413237600"; 
   d="scan'208";a="88608604"
Date: Sun, 16 Nov 2014 16:43:51 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] kprobes: Deletion of an unnecessary check
 before the function call "module_put"
In-Reply-To: <5468B3FD.20409@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411161639310.2364@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net> <alpine.DEB.2.10.1411161428190.2364@hadrien> <5468B3FD.20409@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014, SF Markus Elfring wrote:

> >> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> >> index 3995f54..f1e7d45 100644
> >> --- a/kernel/kprobes.c
> >> +++ b/kernel/kprobes.c
> >> @@ -1527,8 +1527,7 @@ int register_kprobe(struct kprobe *p)
> >>  out:
> >>  	mutex_unlock(&kprobe_mutex);
> >>
> >> -	if (probed_mod)
> >> -		module_put(probed_mod);
> >> +	module_put(probed_mod);
> >
> > There is an out label, so please check whether the labels could not be
> > better positioned to avoid calling module_put when it is not needed.
>
> I do not see refactoring opportunities around jump labels in this use case
> for the implementation of the register_kprobe() function so far because
> the mutex_unlock() function must be called.
> Would you like to suggest any other source code fine-tuning?

OK.  I don't think that removing the if is a good choice in this case.
The code ret = check_kprobe_address_safe(p, &probed_mod); is unusual, in
that it can fail to do anything in two ways.  One is by setting ret, on
detecting an error, and the other is by returning 0 but still putting a
NULL value in probed_mod when there is nothing to do.  Thus, in the
successful execution of the rest of the function, a probed module might or
might not exist.  The if around the module_put is helpful to the reader to
understand that this possibility exists.

julia
