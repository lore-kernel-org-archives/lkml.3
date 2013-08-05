Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab3HEEFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:05:53 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:53877 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3HEEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:05:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAC-DJzKqv7b0fdPOL5+Sx2AF7EG=2+xrq8R+UrK-ev1-sNu=Pw@mail.gmail.com>
References: <1374106861-3549-1-git-send-email-bleung@chromium.org>
	<CAC-DJzKqv7b0fdPOL5+Sx2AF7EG=2+xrq8R+UrK-ev1-sNu=Pw@mail.gmail.com>
Date: Sun, 4 Aug 2013 21:05:50 -0700
X-Google-Sender-Auth: y-ZFb5E0IFt6RJpaxZaq5KhBPSo
Message-ID: <CANLzEkvkTaRZXU66zzC4GtO4zyJgwak5QNMZkL_iaUaRqow_mQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Platform: x86: chromeos_laptop - Deferred Probing
From: Benson Leung <bleung@chromium.org>
To: Martin Nordholts <enselic@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        adurbin@chromium.org, Olof Johansson <olofj@chromium.org>,
        Axel Lin <axel.lin@ingics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

I commented on your patch, but I want to add a little bit more in response here.

On Thu, Jul 18, 2013 at 9:13 AM, Martin Nordholts <enselic@gmail.com> wrote:
> One downside with the solution in this set of patches is that more
> lines are added to the driver.
> By making use of the i2c_driver.detect() mechanism like in my patch,
> we can actually reduce the number of lines in the driver.
>

It looks like the vast majority of the savings in number of lines of
code in your patch is from removing the board specific enumeration of
peripherals.

For example, in my patch, I have a data structure that describes the
chromebook pixel thusly :

static struct chromeos_laptop chromebook_pixel = {
        .i2c_peripherals = {
                /* Touch Screen. */
                { .add = setup_atmel_1664s_ts, I2C_ADAPTER_PANEL },
                /* Touchpad. */
                { .add = setup_atmel_224s_tp, I2C_ADAPTER_VGADDC },
                /* Light Sensor. */
                { .add = setup_isl29018_als, I2C_ADAPTER_PANEL },
        },
};

And so on for every other board that the driver supports. It
explicitly describes the small set of devices that are known to exist
on a particular system, and describes precisely which bus it lives on.
That way, we can use i2c_new_probed_device.

Your patch removes these, and instead, makes one list of all devices
that the driver supports across all systems that pass the dmi check.
Your driver then uses detect in sort of a shotgun approach for all
supported i2c adapters. The approach may work for Pixel, but as I
mentioned in my other email, it causes failed probes on other systems.

It would be my preference to continue to use i2c_new_probed_device,
and explicitly describe each Chromebook system



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
