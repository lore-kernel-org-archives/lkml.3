Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaJHLTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:19:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:60858 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbaJHLTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:19:30 -0400
Date: Wed, 8 Oct 2014 13:19:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 11/11] perf/x86/intel: Perform rotation on Intel CQM RMIDs
Message-ID: <20141008111927.GG4750@worktop.programming.kicks-ass.net>
References: <1411567455-31264-1-git-send-email-matt@console-pimps.org>
 <1411567455-31264-12-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411567455-31264-12-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 03:04:15PM +0100, Matt Fleming wrote:
> This scheme reserves one RMID at all times for rotation. When we need to
> schedule a new event we give it the reserved RMID, pick a victim event
> from the front of the global CQM list and wait for the victim's RMID to
> drop to zero occupancy, before it becomes the new reserved RMID.

> +/*
> + * If we fail to assign a new RMID for intel_cqm_rotation_rmid because
> + * cachelines are still tagged with RMIDs in limbo, we progressively
> + * increment the threshold until we find an RMID in limbo with <=
> + * __intel_cqm_threshold lines tagged. This is designed to mitigate the
> + * problem where cachelines tagged with an RMID are not steadily being
> + * evicted.
> + *
> + * On successful rotations we decrease the threshold back towards zero.
> + */
> +static unsigned int __intel_cqm_threshold;

Ah, so I was about to tell you there is the possibiliy we'll never quite
reach 0. But it appears you've cured that with this adaptive threshold
thing?

Is there an upper bound on the threshold after which we'll just wait, or
will you keep increasing it until something matches?
