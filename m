Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaEOCv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:51:58 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55124 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaEOCv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:51:57 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 14 May 2014 22:55:40 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
In-Reply-To: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Vince Weaver wrote:

>         pe[32].sample_period=0xc0000000000000bd;
> 
> Should it be possible to open an event with a large negative sample_period 
> like that? 

so this seems to be a real bug.

attr->sample_period is a u64 value, but internally it gets cast to
s64 and is added against itself and so all kinds of unexpected things 
happen.

So if you set attr->sample_period to 0xc0000000000000bd in the hopes of 
sampling the RETIRED_INSTRUCTIONS event every 5 years or so, instead
what happens is that in
	x86_perf_event_set_period()
the value is cast to a signed 64-bit value, so we are now negative.

Then "left" is set to period because we are negative.

Then since left is less than 0, we double the period value.
This overflows the 64-bit integer and suddenly we are in undefined
behavior territory and we're lucky the C compiler doesn't decide to
format the hard drive.

Anyway we are still less than 0, so then the

	if (unlikely(left < 2))
		left = 2;

code kicks in and suddenly our hugely positive sample_period has changed
to just being "2".  And so we suddenly get a storm of interrupts instead 
of one every 5 years.

So, not sure how to fix this without a total re-write, unless we want to 
cheat and just say sample_period is capped at 62-bits or something.

Also it's unclear why sometimes this can cause a stuck interrupt leading 
to the "irq loop stuck" message.  I have a reproducible fuzzer test case 
that will cause this to happen, but can't isolate it down to a simple test 
case...

Vince

