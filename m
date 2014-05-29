Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbaE2V7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:59:42 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54715 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaE2V7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140529211815.GP5099@sirena.org.uk>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1401211721-19712-4-git-send-email-bjorn.andersson@sonymobile.com>
	<20140528165529.GC5099@sirena.org.uk>
	<CAJAp7OgY-99jRqvBOPbkj=Nrt7vW=0Ae+Xvf3J7JrDS1eoigWw@mail.gmail.com>
	<20140529211815.GP5099@sirena.org.uk>
Date: Thu, 29 May 2014 14:59:38 -0700
Message-ID: <CAJAp7Oj7jUw_PGxS6TEG=eCMkfaTTi0V1+8EZt4Mp_8gEUFaWA@mail.gmail.com>
Subject: Re: [PATCH 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: Mark Brown <broonie@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 2:18 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, May 29, 2014 at 02:03:40PM -0700, Bjorn Andersson wrote:
>
> Please fix your mailer to word wrap at less than 80 columns so quoted
> text is legible.
>
>> The hardware in this case is a "pmic" shared by all cpus in the system, so when
>> we set the voltage, state or load of a regulator we merely case a vote. For
>> voltage and state this is not an issue, but for load the value that's
>> interesting for the "pmic" is the sum of the votes; i.e. the sum of the loads
>> from all systems on a single regulator.
>
>> What the code does here is to follow the hack found at codeaurora, that upon
>> get_optimum_mode we guess that the client will call get_optimum_mode followed
>> my set_mode. We keep the track of what load was last requested and use that in
>> our vote.
>
> No, this is awful and there's no way in hell that stuff like this should
> be implemented in a driver since there's clearly nothing at all hardware
> specific about it.  The load tracking needs to be implemented in the
> framework if it's going to be implemented, and passing it up through the
> chain is obviously going to need some conversion and accounting for
> hardware conversion losses which doesn't seem to be happening here.
>
> I'm still unclear on what the summed current is going to be used for,
> though...
>

You do load accumlation of all the requests from the drivers of the Linux
system, but in the Qualcomm system there might be load from the modem or the
sensor co-processor that we don't know about here. So additional accumulation
is done by the "pmic" - that is directly accessed by those other systems as
well.

So here we don't set the mode of the regulator, we tell the "pmic" our part and
then it can accumulate further.


I understand your strong opinions regarding this, so I will respin this to
forcefully set the regulator mode intead of merely casting a vote.  I.e.
implement set_mode to actually set the mode.

>> >> +     if (vreg->parts->ip.mask) {
>> >> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_DRMS;
>> >> +             initdata->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
>> >> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_NORMAL;
>> >> +             initdata->constraints.valid_modes_mask |= REGULATOR_MODE_IDLE;
>
>> > No, this is just plain broken.  Constraints are set by the *board*, you
>> > don't know if these settings are safe on any given board.
>
>> I can see that these are coming from board files, but I didn't find any example
>> of how these are supposed to be set when using DT only.
>
>> What's happening here is that given what compatible you use, different "parts"
>> will be selected and based on that this code will or will not be executed;
>> hence this is defined by what compatible you're using.
>
>> But this is of course not obvious, so unless I've missed something I can clean
>> this up slightly and make the connection to compatible more obvious. Okay?
>
> No, it's still just plain broken.  You've no idea if the settings you're
> providing work or not on a given system (or set of drivers for that
> matter) - mode configuration really is a part of the system integration
> not an unchanging part of the PMIC.  This code appears to assume that
> every client driver (plus passives) is going to accurately supply load
> information which just isn't realistic except in very controlled cases
> for a specific system.
>
> The reason it's not supported in DT at the minute is that the definition
> of modes is not at all clear in a generic fashion, plus of course the
> fact that we have no users in mainline for dynamic mode setting.  Most
> PMICs these days are smart enough to do this autonomously anyway so it's
> not clear that this is something that it's worth spending time on.
>
> Please look for the prior threads on this.

At the time of implementing this the proposed sdhci driver from Qualcomm called
regulator_set_mode, but that got redesigned not to fiddle with
regulators. So                                                     it
seems you're right, no-one ever calls regulator_set_mode in mainline
and
hence doesn't have this problem.

So the only example I can find is lp872x, that for buck* does this exactly like
I do.

But as there are no users anymore, I could just let the constraints part go for
now and once we've figured out the dt part there will be some way of setting
these. Okay?

Regards,
Bjorn
