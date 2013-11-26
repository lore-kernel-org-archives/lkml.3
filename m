Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab3KZNj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:39:28 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:59617 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3KZNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <20131126122818.GA7427@katana>
References: <1385447520-3306-1-git-send-email-mike.looijmans@topic.nl>
	<20131126090639.GA2568@katana>
	<52946BA6.3080308@topic.nl>
	<20131126122818.GA7427@katana>
Date: Tue, 26 Nov 2013 14:39:25 +0100
Message-ID: <CAPDyKFoHJWLvCNd1b=-NOzeN8npFkYNPCU0YgREovMZZC0K6bw@mail.gmail.com>
Subject: Re: [PATCH] i2c-mux-pca954x: Disable mux after 200ms timeout
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2013 13:28, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> CCing linux-pm, maybe they know more...
>
>> The extra I2C traffic consumes extra power. If the bus is terminated
>> using 2k resistors, approximately 1mA of current (assuming ~2V
>> signals) is flowing when the bus is pulled low. On low power
>> designs, this extra power consumption is noticable. There is no way
>> to turn the mux "off" from either user or kernel space. The signals
>> going through the mux to a place where no I2C device is actually
>> listening are only wasting power.
>
> I only have an overview of current linux pm mechanisms. I wonder if
> those can't be used somehow. Like if devices on the multiplexed bus are
> idle (well, only regarding transfers), then we can switch off the muxer.
>
>> The I2C signals are used to control sensitive codecs. When looking
>> at the sampled data, the I2C traffic is visible in the captured
>> analog signal. To prevent this from happening, the mux can be
>
> I wonder: Is this really a feature of sensitive codecs or an issue of
> the board design?
>
>> disabled whenever not communicating with the codec. This could be
>> accomplished with the "deselect_on_exit" boolean, but because audio
>> driver sends the codec parameters in dozens of small transactions,
>> this will result in a lot more needless I2C traffic, constantly
>> switching the mux for each codec setting.
>
> Has this been looked at? ASoC supports grouping of tranfers IIRC. Maybe
> your I2C driver is only missing I2C_M_NOSTART?.
>
>> Would it be acceptable if I made the timeout optional, by making the
>> "deselect_on_exit" boolean into a three-state value (off, on,
>> timeout)? Or, alternatively, implement "deselect_on_exit" using the
>> timeout scheme (probably with a very short timeout)?
>
> I have a number of concerns designwise. First, if we do something like
> shutting-down-a-bus-if-there-are-no-transfers-expected, it definately
> should be in the core, not the driver. As said before, I have the
> assumption it should even be connected to the runtime pm core via some
> callback. And if we have that for I2C, we surely want that for other
> buses as well, at least SPI. Also, the timeout thing sounds too
> heuristic to me. Later, people might want to change the timeout value
> depending on workloads or so, and then a governor, etc... No, thanks.

It very much sounds like runtime PM should help you here. Then you get
the reference counting and the so called runtime_autosuspend feature
for free. :-)

>
> BTW is it feasible to shut down the whole I2C bus at controller level
> after transfers? No needless transfers and maybe even more power
> savings.

For sure this should be possible. Some controller drivers have started
to adapt some runtime PM code for this is already, nomadik and omap
for example. I think typically clocks, pins and if there are a power
domain regulator for the controller, those should be handled through
runtime PM to save power at "request inactivity".

Kind regards
Ulf Hansson

>
> Anyway, thanks for letting me know about your requirements (they should
> have been in the original commit message, though ;))
>
