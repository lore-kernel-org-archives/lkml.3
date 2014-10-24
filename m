Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaJXV51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:57:27 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62796 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaJXV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20141024211848.GP3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
	<20141024201138.GL3729@sirena.org.uk>
	<CAF6AEGssn23wSaSCY-MH+CUk1YD2g7Ld+rejQq0BSHUAcXgZEQ@mail.gmail.com>
	<20141024211848.GP3729@sirena.org.uk>
Date: Fri, 24 Oct 2014 17:57:24 -0400
Message-ID: <CAF6AEGsDhv6V8ggOsLHgk6YgWEaL4iV1yX4qOdA_=KzCAWqR=w@mail.gmail.com>
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
From: Rob Clark <robdclark@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, David Brown <davidb@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 5:18 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Oct 24, 2014 at 04:36:24PM -0400, Rob Clark wrote:
>
>> iirc, I was using _get_exclusive() in a few places where I wanted to
>> be sure not to get dummy-regulator in cases where I should
>> -EPROBE_DEFER instead (since probe order with DT is slightly
>> hilarious, and since I depend on a few other drivers I end up
>> deferring at least a couple times at boot)... I don't quite remember
>> the details.  But afaict regulator_get() still allows dummy-regulator,
>> which is what I specifically don't want.
>
> No, this is actually making things worse.  You will only get a dummy
> regulator from regulator_get() if no regulator at all is mapped in the
> DT, if one is mapped then you'll always get either an -EPROBE_DEFER or
> the real regulator.  Right now the driver is broken with respect to
> -EPROBE_DEFER since it just completely ignores the error code and
> carries on happily if any error is returned which means that the
> behaviour is going to be unstable on any given system, what happens will
> depend on probe order which could in turn depend on what's been built
> modular and so on.

Oh, you are only looking at the one in mdp4_kms_init(), which could
possibly be a simple regulator_get().  Look instead at the ones in
hdmi_init(), where I need to know whether to defer or not.  At one
point I was having a problem getting dummy regulators with
regulator_get() but that could have been a symptom of another problem.
I will re-try regulator_get() next time I am working on the kernel
part of the driver..

The mdp4_kms->vdd logic is a bit of a hack right now, since we are
missing a driver upstream for that regulator (and just relying on
bootloader to leave it on for us).

BR,
-R

> As far as I can tell the only thing the driver does with the regulator
> it's grabbing exclusively is enable it in probe() and that's going to
> work just as well with the dummy regulator anyway so I can't see any
> reason to worry if the driver is getting one.
>
>> If you have a recommendation for a better way, I am all ears.
>
> Just use regulator_get() (or better, devm_regulator_get()) and pay
> attention to the errors.  The driver should also disable the regulator
> on remove and I'd be surprised if the other two regulators shouldn't be
> using a normal _get() too.  If there is a good reason to use _optional()
> then the code should be changed to use ERR_PTR() rather than NULL to
> check for missing regulators and the driver needs to keep them enabled
> as long as it's using them.
>
> Given that the two optional regulators are only set to one specific
> value it's a bit surprising that the DT doesn't do this but I guess it's
> possible there could be broken DTs out there that do give permission for
> set_voltage() for a range rather than specifying the correct voltage.
