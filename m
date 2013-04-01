Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3DAHcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 03:32:08 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:64650 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3DAHcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 03:32:06 -0400
MIME-Version: 1.0
X-Originating-IP: [114.39.109.172]
In-Reply-To: <CAMPhdO8sxF5N1_SGrcrqd4g8hGq-dWx9_XXLCG25G0pYw+i5fg@mail.gmail.com>
References: <1364741987.3834.2.camel@phoenix>
	<1364742271.3834.7.camel@phoenix>
	<CAMPhdO8sxF5N1_SGrcrqd4g8hGq-dWx9_XXLCG25G0pYw+i5fg@mail.gmail.com>
Date: Mon, 1 Apr 2013 15:32:05 +0800
Message-ID: <CAFRkauCEdEszCAVSjDFOpQx6mKqL52TZfGQaapBidEQh5v9SMw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pwm: pxa: Remove clk_enabled field from struct pxa_pwm_chip
From: Axel Lin <axel.lin@ingics.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1 Eric Miao <eric.y.miao@gmail.com>:
> On Sun, Mar 31, 2013 at 11:04 PM, Axel Lin <axel.lin@ingics.com> wrote:
>> clk_enable/clk_disable maintain an enable_count, clk_prepare and clk_unprepare
>> also maintain a prepare_count. These APIs will do prepare/enable when the first
>> user calling these APIs, and do disable/unprepare when the corresponding counter
>> reach 0. Thus We don't need to maintain a clk_enabled counter here.
>
> The original intention is to keep a paired clk enable counter no matter
> how the user calls pwm_enable()/pwm_disable() in pair or not, if that's
> no longer the case.

We don't need to worry that case:
In pwm core, both pwm_enable() and pwm_disable() will always check
PWMF_ENABLED flag.


/**
 * pwm_enable() - start a PWM output toggling
 * @pwm: PWM device
 */
int pwm_enable(struct pwm_device *pwm)
{
        if (pwm && !test_and_set_bit(PWMF_ENABLED, &pwm->flags))
                return pwm->chip->ops->enable(pwm->chip, pwm);

        return pwm ? 0 : -EINVAL;
}
EXPORT_SYMBOL_GPL(pwm_enable);

/**
 * pwm_disable() - stop a PWM output toggling
 * @pwm: PWM device
 */
void pwm_disable(struct pwm_device *pwm)
{
        if (pwm && test_and_clear_bit(PWMF_ENABLED, &pwm->flags))
                pwm->chip->ops->disable(pwm->chip, pwm);
}
EXPORT_SYMBOL_GPL(pwm_disable);
