Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3IYUvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:51:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48554 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3IYUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:51:22 -0400
Message-ID: <52434CBC.2070408@gmail.com>
Date: Wed, 25 Sep 2013 22:51:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux@arm.linux.org.uk, mturquette@linaro.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v6 0/5] clk: clock deregistration support
References: <1377874402-2944-1-git-send-email-s.nawrocki@samsung.com> <52420664.2040604@gmail.com> <3160771.O1gFkR91vK@avalon>
In-Reply-To: <3160771.O1gFkR91vK@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 09/25/2013 11:47 AM, Laurent Pinchart wrote:
> Doesn't that introduce race conditions ? If the sub-drivers require the clock,
> they want to be sure that the clock won't disappear beyond their backs. I
> agree that the circular dependency needs to be solved somehow, but we probably
> need a more generic solution. The problem will become more widespread in the
> future with DT-based device instantiation in both V4L2 and KMS.

It doesn't introduce any new race conditions AFAICT. I doubt all these 
issues
can be resolved in one single step. Currently the modular clock 
providers are
seriously broken, there is no reference tracking and the clock consumers 
can
easily get into a state where they have invalid references to clocks 
supplied
by already unregistered drivers.

With this patch series the clock consumer drivers will not crash thanks 
to the
clock object reference counting. So the worst thing may happen is a 
clock left
in an unexpected state.

However there should be no problems with the v4l2-async API, the host driver
in its de-initialization routine unregisters its sub-drivers (they 
should stop
using the clock when notified of such an event), only then the host would
unregister the clock (subsequently the sub-drivers get re-attached and put
into deferred probing state).

There may be issues when a sub-driver's file handle is opened while the host
is about to de-initialize. But I doubt resolution of such problems belongs
to the common clock framework. I have been trying to improve the situation
in small steps, rather than waiting forever for a perfect solution.

Do you perhaps have any ideas WRT to a "more generic solution" ? In general
I have been trying to avoid using v4l2-clk and add what's missing in the
common clock framework.

Perhaps we should leave only the kref part in the __clk_get(), __clk_put()
hooks and be taking reference to a clock in clk_prepare() and releasing it
in clk_unprepare() ? This way circular reference would exist only between
clk_prepare(), clk_unprepare() calls.

Assuming a driver prepares clock in device's open() and unprepares in device
close() handler perhaps it could all work better, without relying on the 
host
to ensure the resource reference tracking. I'm not sure if that is not 
making
too many assumptions for a generic API.


Thanks for the feedback.

--
Regards,
Sylwester
