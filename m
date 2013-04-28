Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab3D1FpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 01:45:07 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:13867
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750725Ab3D1FpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 01:45:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLYAMU-02-8X7-02
X-M-MSG: 
Date: Sun, 28 Apr 2013 00:44:56 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/3] perf tools: allow user to specify hardware
 breakpoint bp_len
Message-ID: <20130428054455.GA30257@jshin-Toonie>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com>
 <1367002666-6910-3-git-send-email-jacob.shin@amd.com>
 <20130427165856.GA30282@redhat.com>
 <20130427173424.GA32506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130427173424.GA32506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 07:34:24PM +0200, Oleg Nesterov wrote:
> On 04/27, Oleg Nesterov wrote:
> >
> > On 04/26, Jacob Shin wrote:
> > >
> > > @@ -518,12 +518,10 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
> > >  	if (parse_breakpoint_type(type, &attr))
> > >  		return -EINVAL;
> > >
> > > -	/*
> > > -	 * We should find a nice way to override the access length
> > > -	 * Provide some defaults for now
> > > -	 */
> > >  	if (attr.bp_type == HW_BREAKPOINT_X)
> > >  		attr.bp_len = sizeof(long);
> > > +	else if (len)
> > > +		attr.bp_len = len;
> > >  	else
> > >  		attr.bp_len = HW_BREAKPOINT_LEN_4;
> >
> > Stupid question... So X86_FEATURE_BPEXT only works for r/w? I mean, it
> > doesn't allow to specify the mask for an execute breakpoint?

Yes, it does work with instruction execution breakpoints as well.

> >
> > Otherwise the code above should be probably updated, say,
> >
> > 	if (!len) {
> > 		len = attr.bp_type == HW_BREAKPOINT_X ?
> > 			sizeof(long) : HW_BREAKPOINT_LEN_4;
> > 	}
> > 	attr.bp_len = len;
> 
> OK, we can't do this until we change arch_build_bp_info() which
> insists on sizeof(long) and sets X86_BREAKPOINT_LEN_X == 1.

Right, for instruction execution breakpoints, it is a x86 requirement
to have length as 1. Which makes sense, because you really want to be
trapping on 1 specifc IP.

Now using this new mask MSR, we should be able to trap on range of IPs,
but yeah since we are naturally extending bp_len .... we'll tackle it
later when we can come up with a good scheme to express masks in arch
neutral/general way.

