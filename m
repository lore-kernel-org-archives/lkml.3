Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3CTQX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:23:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43705 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981Ab3CTQXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:23:54 -0400
Message-ID: <5149E296.1030304@wwwdotorg.org>
Date: Wed, 20 Mar 2013 10:23:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: [RFC] pinctrl: pins are freed 2 times in pinctrl_bind_pins
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com> <1363779113-8776-3-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1363779113-8776-3-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 05:31 AM, Richard Genoud wrote:
> If the function pinctrl_select_state() fails because one pin is already
> taken elsewhere, pinmux_enable_setting makes all the necessary pin_free
> calls (and not more than necessary).
> The problem here is that devm_pinctrl_put() will be called on the pin
> group, and each pin in this group has already been freed.
> 
> Example:
> If a i2c function has already sucessfully taken pins 5 and 6.
> And now, pinctrl_bind_pins() is called for function PHY (pins 3 4 5 6 7).
> pinmux_enable_setting() will fail AND call pin_free on necessary pins.
> But if devm_pinctrl_put() is called, it will call again pin_free on pins
> 3 4 5 6 7.
> So, the pins 5 and 6 will be released (and pins 3 4 7 double freed).
> Which means that even if the i2c function has claim the pins, they will
> be available for other functions.
> 
> This patch simply doesn't call devm_pinctrl_put when
> pinctrl_select_state fails, but I'm not sure it's the right thing to do.

The correct fix here is not to skip the call to devm_pinctrl_put(),
since that undoes a lot of other things besides the current state selection.

Instead, pinctrl_select_state_locked() needs to be fixed so that:

a)

Change "p->state = state;" to "p->state = NULL;" or similar, to indicate
that no state is selected. (Please validate if a NULL value in that
variable will cause problems elsewhere)

b)

Add back the assignment "p->state = state;" at the end of the function,
if no error occurred.

c)

Fix the list_for_each_entry() call that applies all the settings for the
new state so that if it fails, it undoes everything that it's applied so
far. That's the hard part, unless there's a
list_for_each_entry_before_the_current_one_that_list_for_each_entry_iterated_over_already()
macro!
