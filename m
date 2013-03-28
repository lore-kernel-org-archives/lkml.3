Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab3C1Jdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:33:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:40051 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab3C1Jdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:33:52 -0400
Date: Thu, 28 Mar 2013 10:33:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        rajagopal.venkat@linaro.org, davidb@codeaurora.org,
        ulf.hansson@linaro.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 2/2] clk: allow reentrant calls into the clk framework
In-Reply-To: <1364445958-2999-3-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.LFD.2.02.1303281031260.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org> <1364445958-2999-1-git-send-email-mturquette@linaro.org> <1364445958-2999-3-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Mike Turquette wrote:

> Reentrancy into the clock framework is necessary for clock operations
> that result in nested calls to the clk api.  A common example is a clock
> that is prepared via an i2c transaction, such as a clock inside of a
> discrete audio chip or a power management IC.  The i2c subsystem itself
> will use the clk api resulting in a deadlock:
> 
> clk_prepare(audio_clk)
> 	i2c_transfer(..)
> 		clk_prepare(i2c_controller_clk)
> 
> The ability to reenter the clock framework prevents this deadlock.
> 
> Other use cases exist such as allowing .set_rate callbacks to call
> clk_set_parent to achieve the best rate, or to save power in certain
> configurations.  Yet another example is performing pinctrl operations
> from a clk_ops callback.  Calls into the pinctrl subsystem may call
> clk_{un}prepare on an unrelated clock.  Allowing for nested calls to
> reenter the clock framework enables both of these use cases.
> 
> Reentrancy is implemented by two global pointers that track the owner
> currently holding a global lock.  One pointer tracks the owner during
> sleepable, mutex-protected operations and the other one tracks the owner
> during non-interruptible, spinlock-protected operations.
> 
> When the clk framework is entered we try to hold the global lock.  If it
> is held we compare the current task id against the current owner; a

s/task id/task/ We store a the task pointer in the owner variable.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
