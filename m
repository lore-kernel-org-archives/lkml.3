Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3C0W4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:56:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46506 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3C0W4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:56:21 -0400
Date: Wed, 27 Mar 2013 22:56:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] clk: allow reentrant calls into the clk framework
Message-ID: <20130327225610.GR4977@n2100.arm.linux.org.uk>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 12:09:43AM -0700, Mike Turquette wrote:
> +	/* set context for any reentrant calls */
> +	atomic_set(&prepare_context, (int) get_current());
...
> +	if (mutex_is_locked(&prepare_lock))
> +		if ((void *) atomic_read(&prepare_context) == get_current())
> +			return true;

If you really want to do it like this, then the _correct_ way to do it
is:

		if (atomic_read(&prepare_context) == (int)get_current())

So that any effects from the cast are the same in both parts.  Otherwise,
you will be running into the possibility that a cast could do something
like truncate the returned value, resulting in the test condition using
pointers always being false.

It's not that much of a problem on ARM, but it's a matter of good
programming discpline that such issues are avoided.

Even better would be to cast it to unsigned long - this is the value
which the atomic types use, and that is less likely to be truncated.
It also helps to avoid the possibility of compilers complaining about
a narrowing cast too - especially as the entire Linux kernel assumes
that pointers can be cast to unsigned long and back again with no loss.
