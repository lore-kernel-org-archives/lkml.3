Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaAUJ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:26:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58700 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaAUJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:26:37 -0500
Date: Tue, 21 Jan 2014 09:25:31 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140121092531.350ab714@alan.etchedpixels.co.uk>
In-Reply-To: <20140121003856.GP15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
	<20140120100530.GY15937@n2100.arm.linux.org.uk>
	<20140120211601.GB634@kroah.com>
	<20140120213206.GJ15937@n2100.arm.linux.org.uk>
	<20140120231141.GA2355@kroah.com>
	<20140120231603.GL15937@n2100.arm.linux.org.uk>
	<20140120235128.GA5012@kroah.com>
	<20140121000706.GN15937@n2100.arm.linux.org.uk>
	<20140121002623.GA6173@kroah.com>
	<20140121003856.GP15937@n2100.arm.linux.org.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So, let's go back to your original worry, what are you concerned about?
> > A device being removed while probe() is called?
> 
> My concern is that we're turning something which should be simple into
> something unnecessarily complex.  By that, I mean something along the
> lines of:

Or in fact more complex in other cases because your remove may well be
refcounted so the stuff may not be going away in the foo_remove() path.

> 
> static DEFINE_MUTEX(foo_mutex);
> static unsigned foo_devices;
> 
> static int foo_probe(struct platform_device *pdev)
> {
> 	int ret;
> 
> 	mutex_lock(&foo_mutex);
> 	if (foo_devices++ == 0)
> 		uart_register_driver(&driver);
> 
> 	ret = foo_really_probe_device(pdev);

We have atomic_inc_and_test and atomic_dec_and_test so it's
fractionally less ugly.

> in every single serial driver we have...  Wouldn't it just be better to
> fix the major/minor number problem rather than have to add all that code
> repetitively to all those drivers?

Quite.

Although for some drivers I suspect what is actually missing when built
in is

module_init() {
	if (not_the_right_platform())
		return -ENOGOOD;
}

 
Going dynamic is the right fix though. Changing how the driver
registration work is a different (and quite independent) problem.

Alan
