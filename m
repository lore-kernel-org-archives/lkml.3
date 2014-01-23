Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaAWSE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:04:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33859 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbaAWSEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:04:55 -0500
Date: Thu, 23 Jan 2014 18:04:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140123180423.1a62611a@www.etchedpixels.co.uk>
In-Reply-To: <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
	<20140120100530.GY15937@n2100.arm.linux.org.uk>
	<CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I had earlier submitted a patch [1] to remove the hard coded
> major/minor number for Samsung UART driver, but that was rejected
> because of userspace breakage. Without this patch, Samsung UART driver
> can't bind to the hard-coded device node. Changing the default
> major/minor will also not help to fix the objections raised in [1].
> 
> Would you please suggest a way forward?
> 
> [1] https://lkml.org/lkml/2013/12/27/2

So to go and try and put this to bed properly I would suggest the
following way forward. 

We add

CONFIG_LEGACY_STATIC_TTY

Some platforms historically used static device nodes for the console
devices. Select this if you are building a kernel for an old system which
has a static /dev.

Note that because some devices historically used incorrect clashing
numbering this may prevent you building a single kernel which can be
booted on multiple platforms.


And then we do

	.nr		= CONFIG_SERIAL_SAMSUNG_UARTS,
 	.cons		= S3C24XX_SERIAL_CONSOLE,
 	.dev_name	= S3C24XX_SERIAL_NAME,
#ifdef CONFIG_LEGACY_STATIC_TTY
	.major		= S3C24XX_SERIAL_MAJOR,
	.minor		= S3C24XX_SERIAL_MINOR,
#endif

for the afflicted ports (and anyone else who wants to migrate)


We can then enable that config option for ARM (and in time for any other
architecture that turns out to need/want it). Eventually it can go away
(not that its exactly doing any harm if it doesnt).


Does that sound a valid way forward for everyone ?

Alan
