Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbaIPIAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:00:25 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62666 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaIPIAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:00:20 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <20140915224621.GG25162@lee--X1>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
	<20140912134632.GE1930@katana>
	<CABxcv==OXd+uePcB8zDzB-DDmr9ci6zscHX5TCauWoTO6E4fpg@mail.gmail.com>
	<20140915224621.GG25162@lee--X1>
Date: Tue, 16 Sep 2014 10:00:18 +0200
Message-ID: <CABxcv=nZhBFRTTmafLxopTiX+wrOKtMD5tKf-00ysrWcZ5N5rg@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/8] i2c: Relax mandatory I2C ID table passing
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kernel@stlinux.com, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On Tue, Sep 16, 2014 at 12:46 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Fri, 12 Sep 2014, Javier Martinez Canillas wrote:
>> So what I propose is to do it incrementally:
>>
>> 1) Merge Lee's series since that is definitely a step in the right
>> direction to not make an I2C table mandatory (still will be needed for
>> module auto loading though).
>>
>> 2) On a follow-up series, make sure that all I2C drivers have a proper
>> OF table and that are using the MODULE_DEVICE_TABLE(of,...) macro to
>> fill the of:<foo> module aliases. That way the modules will have the
>> proper aliases of the form "of:<foo>" besides the "i2c:<foo>" one.
>> (even when always i2c:<foo> is reported to user-space currently).
>>
>> 3) Apply the patch I posted [0] that changes the behavior of
>> i2c_device_uevent() to report the OF uevent env vars to user-space in
>> case of DT probing which after 2) should not regress any driver module
>> auto-loading since all drivers should fill the of:<foo> aliases.
>
> This sounds resonable.
>

Ok, sounds like a plan then.

>> After this, DT-only drivers will only need an OF table and legacy
>> drivers will only need an I2C table. Drivers that support both will
>> still need the two tables though which is a drawback of this approach
>> since unnecessary duplication will exist on these drivers and can
>> cause issues when both tables are not in sync as we saw on the issue
>> reported by Sjoerd on [1].
>>
>> So an alternate approach could be to do the opposite, just remove the
>> OF tables entirely from the I2C drivers and only use the I2C table
>> even for DT-only drivers. This is possible since i2c_device_match()
>> will succeed even without an OF table because i2c_match_id() matches
>> for compatible strings and what is reported as uevent is what is in
>> the I2C table anyways. I believe that is what Sjoerd suggested but
>> I'll let him comment on that in case I misunderstood.
>
> This would be really bad.  It would go completely against what I have
> working to achieve and OF conventions.
>

Yes, I was just mentioning the two possible approaches but Sjoerd did
a much better work on the SPI thread [0].

Another drawback of only using the I2C table is that the vendor prefix
of the compatible strings are not reported to user-space. So if there
are two devices with the same name (driven by two different drivers)
but different vendor, these are going to be probed correctly if
built-in but module auto-loading will fail since doesn't take into
account the vendor prefix. This is the current status btw and I guess
it was never noticed because there isn't two devices with the same
name today.

The drawback of using the OF based aliases is that many I2C drivers
probably rely on the current behavior and don't have a proper OF table
but IMHO that is a bug and has to be fixed anyways.

Of course that doesn't mean that we shouldn't make sure that all
drivers have a proper OF table (and using MODULE_DEVICE_TABLE) before
changing i2c_device_uevent(). Hence my proposal to do it in 3 steps as
explained before.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/15/70
