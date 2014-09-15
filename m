Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbaIOWq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:46:28 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56621 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbaIOWq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:46:26 -0400
Date: Mon, 15 Sep 2014 23:46:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kernel@stlinux.com, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Subject: Re: [PATCH RESEND 0/8] i2c: Relax mandatory I2C ID table passing
Message-ID: <20140915224621.GG25162@lee--X1>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
 <20140912134632.GE1930@katana>
 <CABxcv==OXd+uePcB8zDzB-DDmr9ci6zscHX5TCauWoTO6E4fpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABxcv==OXd+uePcB8zDzB-DDmr9ci6zscHX5TCauWoTO6E4fpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Javier Martinez Canillas wrote:

> [adding Sjoerd as cc who was the one that raised the module auto-loading issue]
> 
> Hello,
> 
> On Fri, Sep 12, 2014 at 3:46 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> >>
> >> Placing this firmly back on your plate.  I truly hope we don't miss
> >> another merge-window.  This patch-set has the support of some pretty
> >> senior kernel maintainers, so I hope acceptance shouldn't be too
> >> difficult.
> >>
> >> As previously discussed I believe it should be okay for an I2C device
> >> driver _not_ supply an I2C ID table to match to.  The I2C subsystem
> >> should be able to match via other means, such as via OF tables.  The
> >> blocking factor during our previous conversation was to keep
> >> registering via sysfs up and running.  This set does that.
> >
> > As mentioned in another thread, modaliases are one other possible side
> > effect. As Javier correctly mentions, the beaviour does not really
> > change with your patchset. Yet, if we remove i2c_device_id from drivers
> > too carelessly, they might not be bound anymore.
> >
> 
> Right, removing the I2C ID table even from drivers that don't really
> need it (e.g: IP blocks only present in DT platforms) will as you said
> break module auto-loading. Probing will work since the OF table is
> used to match the device in i2c_device_match() but is the I2C table
> what is used to fill the valid module aliases with the current
> behavior of i2c_device_uevent(), the aliases filled from the OF table
> are never used.
> 
> So what I propose is to do it incrementally:
> 
> 1) Merge Lee's series since that is definitely a step in the right
> direction to not make an I2C table mandatory (still will be needed for
> module auto loading though).
> 
> 2) On a follow-up series, make sure that all I2C drivers have a proper
> OF table and that are using the MODULE_DEVICE_TABLE(of,...) macro to
> fill the of:<foo> module aliases. That way the modules will have the
> proper aliases of the form "of:<foo>" besides the "i2c:<foo>" one.
> (even when always i2c:<foo> is reported to user-space currently).
> 
> 3) Apply the patch I posted [0] that changes the behavior of
> i2c_device_uevent() to report the OF uevent env vars to user-space in
> case of DT probing which after 2) should not regress any driver module
> auto-loading since all drivers should fill the of:<foo> aliases.

This sounds resonable.

> After this, DT-only drivers will only need an OF table and legacy
> drivers will only need an I2C table. Drivers that support both will
> still need the two tables though which is a drawback of this approach
> since unnecessary duplication will exist on these drivers and can
> cause issues when both tables are not in sync as we saw on the issue
> reported by Sjoerd on [1].
> 
> So an alternate approach could be to do the opposite, just remove the
> OF tables entirely from the I2C drivers and only use the I2C table
> even for DT-only drivers. This is possible since i2c_device_match()
> will succeed even without an OF table because i2c_match_id() matches
> for compatible strings and what is reported as uevent is what is in
> the I2C table anyways. I believe that is what Sjoerd suggested but
> I'll let him comment on that in case I misunderstood.

This would be really bad.  It would go completely against what I have
working to achieve and OF conventions.

> By the way, the SPI subsystem has the same behavior, I raised the issue on [2].
> 
> Best regards,
> Javier
> 
> [0]: https://lkml.org/lkml/2014/9/11/269
> [1]: https://lkml.org/lkml/2014/9/9/100
> [2]: https://lkml.org/lkml/2014/9/11/458

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
