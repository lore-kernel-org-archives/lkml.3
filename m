Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaEHCBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:01:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbaEHCBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:01:23 -0400
Date: Wed, 7 May 2014 22:00:50 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140508020050.GX39568@redhat.com>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506202307.GA1458@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:23:08AM +0400, Cyrill Gorcunov wrote:
> On Tue, May 06, 2014 at 11:42:58AM -0400, Vince Weaver wrote:
> > 
> > So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> > 
> > It crashes more or less instantly (sorry for the line wrapping, 
> > just got the serial console hooked up and don't have minicom configured 
> > right yet).
> > 
> > this is 3.15-rc4 with the anti-memory corruption patch applied.
> > 
> > [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> > [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331
> 
> This looks like
> 
> p4_pmu_schedule_events:
> 		...
> 		bind = p4_config_get_bind(hwc->config);
> 			returned bind = NULL;
> 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]); NULL deref
> 
> If i'm right (btw it's possible to use addr2line helper?) then hwc->config
> is corrupted and p4_config_get_bind returned nil simply because proper event
> was not found. And I don't understand how it could happen because before
> configuration gets written into hwc->config it's validated once obtained
> from user-space as a raw event. Weird...

I think my commit 13beacee817d27a40ffc6f065ea0042685611dd5 explains this
corruption.  Though I have to admit I haven't looked through the problem
very closely yet.

IOW my lazy fix in that commit doesn't cover fuzzers and the real problem
in p4_pmu_schedule_events. :-)

Cheers,
Don
