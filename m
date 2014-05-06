Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaEFUXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:23:13 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:54600 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbaEFUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:23:11 -0400
Date: Wed, 7 May 2014 00:23:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140506202307.GA1458@moon>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 11:42:58AM -0400, Vince Weaver wrote:
> 
> So just to be difficult I fired up the perf_fuzzer on a Pentium 4 machine.
> 
> It crashes more or less instantly (sorry for the line wrapping, 
> just got the serial console hooked up and don't have minicom configured 
> right yet).
> 
> this is 3.15-rc4 with the anti-memory corruption patch applied.
> 
> [   67.872274] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   67.876146] IP: [<ffffffff81013df2>] p4_pmu_schedule_events+0xa5/0x331

This looks like

p4_pmu_schedule_events:
		...
		bind = p4_config_get_bind(hwc->config);
			returned bind = NULL;
		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]); NULL deref

If i'm right (btw it's possible to use addr2line helper?) then hwc->config
is corrupted and p4_config_get_bind returned nil simply because proper event
was not found. And I don't understand how it could happen because before
configuration gets written into hwc->config it's validated once obtained
from user-space as a raw event. Weird...
