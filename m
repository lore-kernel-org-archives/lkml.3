Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaBESAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:00:19 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46842 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaBESAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <20140204200018.GZ22609@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
	<20140204110531.GR22609@sirena.org.uk>
	<CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
	<20140204181831.GP22609@sirena.org.uk>
	<CAJAp7Ohn3ch2nK_S8j9ieRBzNeyt6OJmumEhRXXykB9RgMJsQg@mail.gmail.com>
	<20140204200018.GZ22609@sirena.org.uk>
Date: Wed, 5 Feb 2014 10:00:15 -0800
Message-ID: <CAJAp7OjB-cJbLpdWo0RFJZefCKcCiKc8KgrjkBobJnddv4MSWA@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Make regulator object reflect configured voltage
From: Bjorn Andersson <bjorn@kryo.se>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 12:00 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Feb 04, 2014 at 11:09:03AM -0800, Bjorn Andersson wrote:
>
>> I have a regulator that's being configured from DT as:
>> regulator-min-microvolt = <2950000>;
>> regulator-max-microvolt = <2950000>;
>
>> In the consumer I do regulator_set_voltage(2.95V).
>
>> As min == max the voltage is applied by the regulator framework on registration
>> of the regulator; and the regulator_set_voltage() fails as
>> REGULATOR_CHANGE_VOLTAGE is not set for this regulator.
>
> So we should be changing the code to allow a set_voltage() that sets the
> voltage to the existing voltage regardless of constraints allowing a
> change then - that's what the underlying issue is.  Your change wouldn't
> cover the case where the hardware defualt is being used for example.

Makes sense, but the only thing we could check for would be if min_uV
== max_uV == current-voltage. That would work out fine for this use
case, but do you think it would be good enough?

The best thing I've come up with then is to add the following check in
regulator_set_voltage().

if (min_uV == max_uV && _regulator_get_voltage(rdev) == min_uV)
    goto out;

Would this be acceptable? It's achieving the same thing as my patch,
is more robust and covers the case of setting the voltage to the hw
default value.

Regards,
Bjorn
