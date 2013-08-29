Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3H2GY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:24:29 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:60954 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3H2GY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:24:27 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Joe Perches <joe@perches.com>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joern Rennecke <joern.rennecke@embecosm.com>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
Thread-Topic: [PATCH] ARC: Fix __udelay parentheses
Thread-Index: AQHOpByfrbiZ1kbBskyi3sxdeiKfdQ==
Date: Thu, 29 Aug 2013 06:24:23 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075140F41@IN01WEMBXA.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <C2D7FE5348E1B147BCA15975FBA23075140F26@IN01WEMBXA.internal.synopsys.com>
 <1377756078.1928.89.camel@joe-AO722>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 11:31 AM, Joe Perches wrote:
> On Thu, 2013-08-29 at 05:55 +0000, Vineet Gupta wrote:
>
>> The intent of writing orig code was to generate only 1 MPYHU insn (32*32 =
>> high-part-64) for the whole math, at any optimization level whatsoever. If the
>> first MPY is overflowing, u r likely spinning for > 10,000 usec (10ms) which is 1
>> scheduling tick on ARC - not good - presumably for hardware debug. It would be
>> better to use a tight loop there and throw it out later.
> It's a delay loop.  Does it matter whether
> or not a multiply or division is used?

I know what you mean here. Your suggestion from a different mail,

> I think the whole thing is odd and it should simply be
>
>	loops = loops_per_jiffy * usecs_to_jiffies(usecs)


This adds an additional MPYHU (ignoring the large limms and check for max jiffies).
FWIW, most arches do optimize this routine a bit - so ARC not using a standard
kernel API is not that big a sin ;-)

On the topic of multiply vs. divide (which probably is not relevant to topic at
hand though), since ARCompact doesn't have native divide, we end up emulating it
using libgcc routines. That makes it slightly non-deterministic (not a big deal)
and also adds to boot time (which those delays sprinkled all over the place in
crazy device probes and such). Seriously we got hammered by a customer for that once.

-Vineet
