Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3H2Bnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:43:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59103 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755274Ab3H2Bnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:43:51 -0400
Message-ID: <1377740630.1928.71.camel@joe-AO722>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
From: Joe Perches <joe@perches.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: "Vineet.Gupta1@synopsys.com" <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Aug 2013 18:43:50 -0700
In-Reply-To: <E6BF041E97966E4DB955F0DF883AD2D684F1F648@de02wembxa.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <1377715539.1928.45.camel@joe-AO722>
	 <E6BF041E97966E4DB955F0DF883AD2D684F1F601@de02wembxa.internal.synopsys.com>
	 <1377716507.1928.57.camel@joe-AO722>
	 <E6BF041E97966E4DB955F0DF883AD2D684F1F648@de02wembxa.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 19:12 +0000, Mischa Jonker wrote:
> Hello Joe,
> 
> > I don't see the loops_per_jiffy initial shift << 32.
> 
> loops_per_jiffy * HZ = loops_per_second
> loops_per_jiffy * HZ = 1,000,000 * loops_per_us
> loops_per_jiffy * HZ * 4295 = 4,295,000 * loops_per_us
> 
> loops_per_jiffy * HZ * 4294.967296 = 2^32 * loops_per_us
> 
> > > > > -	loops = ((long long)(usecs * 4295 * HZ) *
> > > > > -		 (long long)(loops_per_jiffy)) >> 32;
> > > > > +	loops = (((long long) usecs) * 4295 * HZ *
> > > > > +		  (long long) loops_per_jiffy) >> 32;
> 
> > 
> > I know that.  It's the use of a signed long long vs the unsigned long long
> > that I think wrong.
> 
> Yes that is wrong too.
> 
> > 
> > Why cast a unsigned to a signed?
> 
> I don't know, this was in the original file. The issue that I was trying to solve, was that usleep didn't sleep long enough, and that is fixed by this patch. 
> 
> Wrt signed/unsigned: would you like me to update this patch or create a separate one?

I think the whole thing is odd and it should simply be

	loops = loops_per_jiffy * usecs_to_jiffies(usecs);

and if it's really necessary to have a u64 delay
then __delay should be rewritten to take an one
as an argument and this calc should be:

	u64 loops = (u64)loops_per_jiffy * usecs_to_jiffies(usecs);



