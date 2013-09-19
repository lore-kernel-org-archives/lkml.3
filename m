Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab3ISAXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 20:23:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42790 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3ISAXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 20:23:13 -0400
Date: Wed, 18 Sep 2013 17:23:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Joe Perches <joe@perches.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
Message-ID: <20130919002308.GA11266@roeck-us.net>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379545361.1787.87.camel@joe-AO722>
 <0da25c5c-660c-4836-8179-6e7c51fd0d9f@CO9EHSMHS005.ehs.local>
 <1379546336.1787.95.camel@joe-AO722>
 <1119f60e-99dd-45f8-8d91-2b0fa8b7f03b@DB8EHSMHS027.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1119f60e-99dd-45f8-8d91-2b0fa8b7f03b@DB8EHSMHS027.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:32:59PM -0700, Sören Brinkmann wrote:
> On Wed, Sep 18, 2013 at 04:18:56PM -0700, Joe Perches wrote:
> > On Wed, 2013-09-18 at 16:09 -0700, Sören Brinkmann wrote:
> > > On Wed, Sep 18, 2013 at 04:02:41PM -0700, Joe Perches wrote:
> > > > On Wed, 2013-09-18 at 15:43 -0700, Soren Brinkmann wrote:
> > > > > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > > > > The devices generate low-jitter clock signals and are reprogrammable via
> > > > > an I2C interface.
> > > > []
> > > > > v2:
> > > > []
> > > > >  - use 10000 as MIN and MAX value in usleep_range
> > > > []
> > > > > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > > > []
> > > > > +static int si570_set_frequency(struct clk_si570 *data, unsigned long frequency)
> > > > > +{
> > > > []
> > > > > +	/* Applying a new frequency can take up to 10ms */
> > > > > +	usleep_range(10000, 10000);
> > > > 
> > > > Generally it's nicer to have an actual range for usleep_range.
> > > Well, as I said in the discussion with Guenther. I'm flexible and nobody
> > > objected when I said to make both equal. A real range doesn't make sense
> > > here though, but I don't know what's common practice for cases like
> > > this.
> > 
> > udelay is normal, but I guess you don't need atomic context.
> After checkpatch correcting me a few times I went with what
> Documentation/timers/timers-howto.txt suggests. But yes, then we have
> this situation, that I want to sleep 10ms, but not longer using a
> *_range function. I guess it is very application specific whether a
> longer delay here is acceptable or not.
> 
You really want to sleep and not call udelay for 10ms. The idea behind usleep_range
is that you give the kernel some slack. In this case, you could for example make it
10-12 ms. That doesn't make much difference for the driver, but it might save a
timer interrupt in the kernel because it might be able to coalesce more than one
event. After all, it doesn't have to be _exactly_ 10 ms, which is what you are
claiming with the fixed number. Prior to usleep_range, you would have happily
called msleep(10) without realizing that it might sleep up to 20 ms on you.
Keep that in mind ...

> You're right. I'll add a delay there as well. The 'rang' question
> applies here as well.
> 
Same thing, really. You could make it 100-200uS. That doesn't make much
difference for this driver, but it might make a difference for overall
performance, especially if everyone is playing nicely.

Guenter
