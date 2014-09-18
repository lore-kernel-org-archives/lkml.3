Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbaIRPyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:54:38 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45132 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000AbaIRPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140918124611.GA26817@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
	<1410290686-6680-4-git-send-email-octavian.purdila@intel.com>
	<20140918105458.GA2337@localhost>
	<CAE1zot+_hX6TVkW-B6H9NzgyLhF54oQJZt+x_xXGjEB6A5dAZA@mail.gmail.com>
	<20140918124611.GA26817@localhost>
Date: Thu, 18 Sep 2014 18:54:34 +0300
Message-ID: <CAE1zotK7nb6VVp5a3n2_fnWZQHfizg4hFFy-ZVW5fzyFwmBMcA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] gpio: add support for the Diolan DLN-2 USB GPIO driver
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 3:46 PM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Sep 18, 2014 at 03:43:07PM +0300, Octavian Purdila wrote:
>> On Thu, Sep 18, 2014 at 1:54 PM, Johan Hovold <johan@kernel.org> wrote:
>> > On Tue, Sep 09, 2014 at 10:24:46PM +0300, Octavian Purdila wrote:
>
>> > Either way, it looks like this could race with get_direction() if you
>> > get a set_direction() while get_direction() is retrieving the direction
>> > from the device.
>> >
>> > This would break gpio_get().
>> >
>> I don't think gpio_set_direction() and gpio_get() are allowed to race.
>
> I wrote that set_direction() and get_direction() could race, which in
> turn would break gpio_get() as you would be caching the wrong
> direction setting.
>

OK, I now see the problem. I think doing this in get_direction() will
fix the issue:

                if (!test_and_set_bit(offset, dln2->pin_dir_set))
                        set/clear_bit(offset, dln2->pin_dir);

because gpiolib calls get_direction() while requesting a pin and
request cannot race with itself. Which means that get_direction() can
not race with itself the first time it is called, when the set/clear
operation will be run.

And because we know that get_direction() is called first, we can even
remove the set/clear operation from set_direction().
