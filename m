Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3EIQjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:39:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64928 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab3EIQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130509141444.GV18614@n2100.arm.linux.org.uk>
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
 <1368076726-11492-2-git-send-email-skannan@codeaurora.org>
 <CACVXFVMd_iRtEM8ZLK6Ps66gZO6SCp1mXSgY6JbWtRJjJUh+ag@mail.gmail.com>
 <CACxGe6uHBNUcbD9SeRP5c3E8NN-Z2yjVV+9VAhuoJnXoBtTu2w@mail.gmail.com>
 <20130509135017.GD3200@sirena.org.uk> <20130509141444.GV18614@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 9 May 2013 17:39:03 +0100
X-Google-Sender-Auth: CHGtZpLheUTk8saNg1izAG_uL8c
Message-ID: <CACxGe6sO7kEZgg6km4bzP1cq+2MqGb=D4cZbuWELoz+yhaO6KQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] driver core: Add API to wait for deferred probe to
 complete during init
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Ming Lei <tom.leiming@gmail.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 3:14 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 09, 2013 at 02:50:17PM +0100, Mark Brown wrote:
>> On Thu, May 09, 2013 at 12:50:46PM +0100, Grant Likely wrote:
>>
>> > However, if a device that shuts down resources after init has
>> > completed and then cannot turn those resources back on when another
>> > driver requests them then it sounds like there is a bigger design
>> > problem. We're in a hotplug world and most of the time a driver cannot
>> > assume that a resource will never get requested after initcalls have
>> > completed. It sounds like a design bug in the driver if it cannot
>> > handle that use case.
>>
>> Even if the driver copes fine it can still be desirable to avoid the
>> power down/up cycle if it involves some user visible effect - things
>> like blinking the display off then on for example.  That said I am a
>> little suspicious about this approach, it doesn't feel as robust as it
>> should to go round individual callers.
>
> What if the driver for something like your display is a module which
> needs to be loaded from userland?
>
> Where the design bug lies is in the "lets probe all the drivers and then
> shut down resources which drivers haven't claimed".  That contains an
> implied assumption: that all drivers have been loaded and probed at the
> point where you shut down those resources.
>
> That simply may not be true in todays kernel - it's not true for a start
> if you have modular drivers, and you have built most of the drivers as
> modules (as a distro would want to with single zImage).  It's
> coincidentally not true if you have deferred probing and some drivers
> defer.
>
> The real problem is this: at what point has the system actually finished
> "booting" in the sense that all drivers for a platform have been
> initialised?  With user loadable modules and deferred probing, that's
> actually a very fuzzy concept.
>
> As you can't really tell when that point has been reached, how can you
> decide to shut down resources which "aren't being used" in a sane way
> without avoiding the down/up cycle?  Basically, you can't.
>
> So, trying to solve the problem may be totally fruitless because you
> can't actually solve it - you can only put a sticky plaster over it and
> hope that it catches most of the problem.  But reality is that you can't
> have both a shutdown of unused resources _and_ avoid the down/up cycle.

+1. You can /minimize/ up-down cycles with the kind of optimization
that is being attempted here, but the driver still *must* deal with
bringing resources back up if they get requested "later than you would
otherwise like".

g.



--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
