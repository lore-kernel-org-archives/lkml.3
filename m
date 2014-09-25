Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaIYW7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:59:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:47045 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbaIYW7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:59:05 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: arm@kernel.org, agross@codeaurora.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc: qcom: do not disable the iface clock in probe
References: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org>
	<7hbnq5m4a5.fsf@deeprootsystems.com> <5422E390.9060802@linaro.org>
Date: Thu, 25 Sep 2014 15:59:03 -0700
In-Reply-To: <5422E390.9060802@linaro.org> (Srinivas Kandagatla's message of
	"Wed, 24 Sep 2014 16:30:24 +0100")
Message-ID: <7hfvff8fyg.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:

> On 24/09/14 16:22, Kevin Hilman wrote:
>> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:
>>
>>> since commit 31964ffebbb9 ("tty: serial: msm: Remove direct access to GSBI")'
>>> serial hangs if earlyprintk are enabled.
>>>
>>> This hang is noticed only when the GSBI driver is probed and all the
>>> earlyprintks before gsbi probe are seen on the console.
>>> The reason why it hangs is because GSBI driver disables hclk in its
>>> probe function without realizing that the serial IP might be in use by
>>> a bootconsole. As gsbi driver disables the clock in probe the
>>> bootconsole locks up.
>>
>>> Turning off hclk's could be dangerous if there are system components
>>> like earlyprintk using the hclk.
>>
>> This seems rather fragile.  Isn't the right fix for these other
>> components to use the clk api to ensure the clock does not get enabled?
> Here we are depending on the bootloader to setup the clocks.
>
> Am not sure if we can really use clk apis at that early stage of bootstrap.

Not that early, but all that matters is that you clk_enable() sometime
before the GSBI driver calls clk_disable().

If the clocks are always enabled by the bootloader, the platforms clock
driver might check for those and ensure they are enabled, so that linux
is aware of it, and bugs like this one are avoided.

IMO, clock enable/disable shuffling in the GSBI driver to avoid UART
console problems is just papering over a bug that's waiting to pop up
elsewhere.

Kevin
