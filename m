Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbaCSBtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:49:10 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54095 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758874AbaCSBtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:49:06 -0400
MIME-Version: 1.0
In-Reply-To: <1395139290-4207-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1395139290-4207-1-git-send-email-ben.dooks@codethink.co.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 19 Mar 2014 10:48:45 +0900
Message-ID: <CAAVeFuLJOSikb3pXffbC7Y4LDKXd-PQ_cadtT1q=TLCyWVh=MA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: check if gpio_desc pointer is error or NULL
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 7:41 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> Some of the gpiod_ calls take a pointer to a gpio_desc as their
> argument but only check to see if it is NULL to validate the
> input.
>
> Calls such as devm_gpiod_get() return an error-pointer if they
> fail, so doing the following will not work:
>
>         gpio = devm_gpiod_get(...);
>         gpiod_direction_output(gpio, 0);
>
> The sequence produces an OOPS like:
>
>         Unable to handle kernel paging request at virtual address fffffffe
>
> Change all calls that check for !desc to use IS_ERR_OR_NULL() to
> avoid these issues.

This change is certainly correct from a semantics point of view. Maybe
I'd argue that the burden is on the caller to check that gpiod_get()
returns a valid GPIO descriptor, but having extra security doesn't
hurt. However my problem with this change in its current form is that
it will hide such forgetfulnesses by making functions like
gpiod_get_value() fail silently instead of triggering a oops.

Could you make sure that any call of a gpiolib function on a non-valid
descriptor raises at least a message in the console, and while you are
at it harmonize the way these messages are output? Right now we are
using pr_debug(), pr_warn() or WARN_ON() depending on the location. I
would say that using an invalid GPIO descriptor is offending enough
that it should trigger a stack dump at every attempt.
