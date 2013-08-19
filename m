Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751271Ab3HSTtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:49:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41272 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3HSTtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:49:22 -0400
Message-ID: <521276BE.4090208@wwwdotorg.org>
Date: Mon, 19 Aug 2013 13:49:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
References: <1376685563-1053-1-git-send-email-treding@nvidia.com> <20130816215530.GA14464@mithrandir> <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com> <3558931.NyoikKT8ha@flatron>
In-Reply-To: <3558931.NyoikKT8ha@flatron>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 04:26 AM, Tomasz Figa wrote:
...
> Please correct me if I'm wrong, but to get to initcalls you need a timer. 
> However a timer driver might need interrupts (to tick) and clocks (to get 
> the frequency).
> 
> At least this is what happens on the platforms I work with. They don't 
> need any special early registration method, though. We just special case 
> those drivers, as Thierry pointed, so they don't use device based APIs.
> 
> However if we consider a more complex setup, let's say that the timer 
> driver needs to access some special registers, which are shared with other 
> drivers as well (again not a completely exotic case, as I already met this 
> when working with timer and PWM drivers for older Samsung platforms and 
> had to hack things a bit). One would suggest using regmap here, but it is 
> a device based API.

To take this even further, I'm not sure there's a particular reason why
the timer has to have an internal clock source driven from the same chip
clock input as the CPU itself. What if there's a separate clock input,
whose source chip has an enable input, which is connected to a GPIO,
which is driven by an I2C-based GPIO expander? Admittedly that's a
pretty crazy HW design, but I doubt it's much other than an accident
that it doesn't exist in practice, given the probable lack of feedback
cycle from Linux SW internals to all board designers.

It seems like the best solution here is to make the generic case fully
capable. Perhaps initcalls shouldn't depend on a timer at all, or should
be split into sets that require certain services, and those services can
appear dynamically, and when they do, the relevant initcalls that were
held off by lack of a certain feature all get triggered.
