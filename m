Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3C1PXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:23:46 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45090 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3C1PXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:23:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1303281031260.22263@ionos>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
 <1364445958-2999-1-git-send-email-mturquette@linaro.org> <1364445958-2999-3-git-send-email-mturquette@linaro.org>
 <alpine.LFD.2.02.1303281031260.22263@ionos>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 28 Mar 2013 08:23:22 -0700
Message-ID: <CAPtuhTiPqJkQw-nJMuyaZuTQ2iYbrbtEWMobBf5fWCB3dUG2jQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: allow reentrant calls into the clk framework
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>, linaro-kernel@lists.linaro.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 2:33 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 27 Mar 2013, Mike Turquette wrote:
>
>> Reentrancy into the clock framework is necessary for clock operations
>> that result in nested calls to the clk api.  A common example is a clock
>> that is prepared via an i2c transaction, such as a clock inside of a
>> discrete audio chip or a power management IC.  The i2c subsystem itself
>> will use the clk api resulting in a deadlock:
>>
>> clk_prepare(audio_clk)
>>       i2c_transfer(..)
>>               clk_prepare(i2c_controller_clk)
>>
>> The ability to reenter the clock framework prevents this deadlock.
>>
>> Other use cases exist such as allowing .set_rate callbacks to call
>> clk_set_parent to achieve the best rate, or to save power in certain
>> configurations.  Yet another example is performing pinctrl operations
>> from a clk_ops callback.  Calls into the pinctrl subsystem may call
>> clk_{un}prepare on an unrelated clock.  Allowing for nested calls to
>> reenter the clock framework enables both of these use cases.
>>
>> Reentrancy is implemented by two global pointers that track the owner
>> currently holding a global lock.  One pointer tracks the owner during
>> sleepable, mutex-protected operations and the other one tracks the owner
>> during non-interruptible, spinlock-protected operations.
>>
>> When the clk framework is entered we try to hold the global lock.  If it
>> is held we compare the current task id against the current owner; a
>
> s/task id/task/ We store a the task pointer in the owner variable.
>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Will fix the typo and add your reviewed-by.

Thanks for the review,
Mike
