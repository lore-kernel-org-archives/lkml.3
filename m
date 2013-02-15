Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3BOXR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:17:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53383 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3BOXR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130215195347.GF4351@the-dreams.de>
References: <1360953682-25066-1-git-send-email-dianders@chromium.org>
	<20130215193736.GD4351@the-dreams.de>
	<CAD=FV=VTJN3bU1rpMyjDMvX1SYZJWoJCiNtHNe+nDrtwnXqTXA@mail.gmail.com>
	<20130215195347.GF4351@the-dreams.de>
Date: Fri, 15 Feb 2013 15:17:24 -0800
X-Google-Sender-Auth: G2NK4ZhEvEKz52Wp7Z7-Wc9S8Ww
Message-ID: <CAD=FV=XBcxuC_Se0CHhgCFPDLjqRrK5gB917rTbk4yUPHHTerw@mail.gmail.com>
Subject: Re: [PATCH] i2c: mux: Remove unneeded platform_set_drvdata to NULL in remove
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram,

On Fri, Feb 15, 2013 at 11:53 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> I'll re-send with I2C subsystem wide.  I probably won't attempt the
>> whole kernel wide at this point, but would be very happy if someone
>> else wanted to!  :)
>
> Thanks. Please double check that setting NULL is really unneeded for the
> non-platform-bus variants, too, or skip those if you are unsure. Please
> also update the commit message to reference a stronger indication than
> Stephen's "should not be necessary" ;) I do agree but for the commit
> history, a better reference would be nice to educate readers.

Sounds good.

I've it looks like non-platform-bus instances in drivers/i2c break down to:
* dev_set_drvdata() directly (even though we're a platform device)
* pci_set_drvdata()
* amba_set_drvdata()
* serio_set_drvdata()

I'll go ahead and include those in my patch.  I've looked through the
code a bit.  While I can't 100% guarantee that there's not some
strange code path that I'm missing, it all looks pretty
straightforward.  A few points to be made:

* It would be a bit hard to believe that some higher-level code could
make any particular assumptions about the value in the pointer (it
might point to static data, kmalloced data, etc).  ...so if the
higher-level code is directly looking at this value it'd really could
only be looking to validate that the driver put NULL here.  I don't
see that anywhere.

* I've checked all of the calls to xxx_get_drvdata() in the drivers
touched.  The majority are in remove, suspend, or resume, so we're
good there.  In other cases I just validated that they aren't checking
for and relying on a NULL result of xxx_get_drvdata().

* It would be possible that some subsystem tries to be helpful and
call xxx_get_drvdata() for you and then pass drvdata into a callback
(so I wouldn't see xxx_get_drvdata()).  I don't see that (it would be
a strange design anyway IMHO).  Most of the time I2C devices seem to
get their private data from adap->algo_data anyway (or from the
pointer passed to IRQ registration) and xxx_set_drvdata() doesn't
touch those.

* The __device_release_driver() function actually calls the
"dev_set_drvdata(dev, NULL)" for you anyway.  ...and I that's what's
running the remove code anyway.  ...so we'd only need to worry about
code that could show up before that...


-Doug
