Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaKJU47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:56:59 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49512 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKJU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:56:57 -0500
Date: Mon, 10 Nov 2014 20:56:53 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20141110205653.GF1292@console-pimps.org>
References: <1415276602-10337-1-git-send-email-matt@console-pimps.org>
 <1415276602-10337-11-git-send-email-matt@console-pimps.org>
 <20141107122052.GD3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107122052.GD3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov, at 01:20:52PM, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 12:23:21PM +0000, Matt Fleming wrote:
> > +/*
> > + * If we fail to assign a new RMID for intel_cqm_rotation_rmid because
> > + * cachelines are still tagged with RMIDs in limbo, we progressively
> > + * increment the threshold until we find an RMID in limbo with <=
> > + * __intel_cqm_threshold lines tagged. This is designed to mitigate the
> > + * problem where cachelines tagged with an RMID are not steadily being
> > + * evicted.
> > + *
> > + * On successful rotations we decrease the threshold back towards zero.
> > + *
> > + * __intel_cqm_max_threshold provides an upper bound on the threshold,
> > + * and is measured in bytes because it's exposed to userland.
> > + */
> > +static unsigned int __intel_cqm_threshold;
> > +static unsigned int __intel_cqm_max_threshold = -1;
> 
> Should we initialize that to a finite value? Surely results are absolute
> crap if we do indeed reach that max?

I don't think we'll ever reach that max, it'll bottom out once it
reaches the size of the LLC, since the pathological case is that the
RMID you're currently trying to stabilize is used to tag every line in
the LLC.

Not sure what a reasonable finite value would be here though? 10% of the
LLC size?

-- 
Matt Fleming, Intel Open Source Technology Center
