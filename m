Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaFWXb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:31:26 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:40721 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaFWXbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:31:23 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        naveen krishna <ch.naveen@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Jean Delvare <jdelvare@suse.de>,
        Simon Glass <sjg@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-i2c\@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: exynos5: Properly use the "noirq" variants of suspend/resume
References: <1403155273-1057-1-git-send-email-dianders@chromium.org>
	<7h8uosyc3k.fsf@paris.lan>
	<CAD=FV=XxNVmF+N5HF4SnZoJRJvkSUkpEx6ct4v2gtmAQ9n28-Q@mail.gmail.com>
	<7hwqcbs166.fsf@paris.lan>
	<CAD=FV=Uz9O0i2gmuk2+BHa-Tksvyxv0+MTi2UEjVREAMNCK7Ug@mail.gmail.com>
	<7h7g4brx6w.fsf@paris.lan>
	<CAD=FV=VmPMf6tCNmKJ1o5J7PyAXoU8fb6+s+Fkv18FH2WaQp7A@mail.gmail.com>
	<7h38evp8ng.fsf@paris.lan>
	<CAD=FV=VBcWC2Z2WCmsiZUPCrakqrdd9Cd6QL9TLYS4c23+sMkA@mail.gmail.com>
Date: Mon, 23 Jun 2014 16:31:21 -0700
In-Reply-To: <CAD=FV=VBcWC2Z2WCmsiZUPCrakqrdd9Cd6QL9TLYS4c23+sMkA@mail.gmail.com>
	(Doug Anderson's message of "Mon, 23 Jun 2014 15:42:01 -0700")
Message-ID: <7hwqc7nqye.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Kevin,
>
> On Mon, Jun 23, 2014 at 3:23 PM, Kevin Hilman <khilman@linaro.org> wrote:
>>> So I guess in this case the truly correct way to handle it is:
>>>
>>> 1. i2c controller should have Runtime PM even though (as per the code
>>> now) there's nothing you can do to it to save power under normal
>>> circumstances.  So the runtime "suspend" code would be a no-op.
>>>
>>> 2. When the i2c controller is told to runtime resume, it should
>>> double-check if a full SoC poweroff has happened since the last time
>>> it checked.  In this case it should reinit its hardware.
>>>
>>> 3. If the i2c controller gets a full "resume" callback then it should
>>> also reinit the hardware just so it's not sitting in a half-configured
>>> state until the first peripheral uses it.
>>>
>>> If later someone finds a way to power gate the i2c controller when no
>>> active transfers are going (and we actually save non-trivial power
>>> doing this) then we've got a nice place to put that code.
>>>
>>> NOTE: Unless we can actually save power by power gating the i2c
>>> peripheral when there are no active transfers, we would also just have
>>> the i2c_xfer() init the hardware if needed.  Maybe that's kinda gross,
>>> though.
>>
>> Yes, this is how we manage the i2c controller on OMAP.
>>
>> Essentially, between every xfer, the hw is disabled and can potentially
>> lose context, so eveery xfer requires a hw init.  We use the runtime PM
>> "autosuspend" feature so that it stays alive for X milliseconds so
>> bursty i2c xfers are not punished.
>>
>> Have a look at drivers/i2c/busses/i2c-omap.c.
>>
>> You'll notice there are not callbacks for system suspend/resume, it's
>> only doing runtime PM.
>
> OK, cool!  That might be a bit too aggressive of a change for what I
> can take on right now.  I've filed http://crbug.com/388007 to see if
> Samsung can take a look at this.

Sure.  While I think moving to runtime PM is the right thing to do, that
alone shouldn't block this patch.

Kevin
