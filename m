Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaIYKqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:46:21 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42335 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaIYKqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:46:18 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Thu, 25 Sep 2014 12:43:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 1/4] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140925104342.GC32124@localhost>
References: <1411158165-25794-2-git-send-email-octavian.purdila@intel.com>
 <20140924104809.GA16198@localhost>
 <CAE1zotLu7pN9pC_C+iRwSpMh2iPW5E1CL4RiycLK-jV_FZEfOQ@mail.gmail.com>
 <20140924135444.GD16198@localhost>
 <CAE1zot+BqL4=kTJaQYwPxL-19W-+2nomXXrKaogJZRXuvrVE0A@mail.gmail.com>
 <20140924150749.GG16198@localhost>
 <CAE1zotLbziKCaXio-LTu0hoz+jjTzqZD=PC3yP3VSn2+f7j62Q@mail.gmail.com>
 <CAE1zot+NGpLFC2fT5giNdXowhaesOux97e_7N9T6EV1OaWWdtg@mail.gmail.com>
 <20140925103011.GA32124@localhost>
 <CAE1zotL2A7Y_xbgCJD2mxiJ=F97GX7PkkB+YTUQjHD6tkDGs-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotL2A7Y_xbgCJD2mxiJ=F97GX7PkkB+YTUQjHD6tkDGs-g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 01:41:16PM +0300, Octavian Purdila wrote:
> On Thu, Sep 25, 2014 at 1:30 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Thu, Sep 25, 2014 at 01:25:24PM +0300, Octavian Purdila wrote:
> >
> >> Johan, I think we don't really need the spinlock, the disconnect flag
> >> and an atomic counter should work. Do you see any issues with that?
> >
> > No, you need to test and increment atomically so the lock is needed.
> >
> > Consider what could happen if you get a disconnect after testing but
> > before incrementing.
> 
> I am still not seeing the problem. We would continue with the
> increment, we will try to send which will fail and go on the error
> path where we will decrement and wake_up. What am I missing?

The whole point of the counter and flag is to make sure that no
transfers are started after the flag is set. If you remove the lock you
cannot guarantee that.

Disconnect sets the flag (after you test it in transfer() but before
incrementing the counter), checks the counter which is 0 and proceeds
with deregistration and deallocation. Then transfer() gets to run...

Johan
