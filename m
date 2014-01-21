Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaAUJpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:45:55 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43601 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753973AbaAUJpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:45:51 -0500
Date: Tue, 21 Jan 2014 09:45:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140121094529.GQ15937@n2100.arm.linux.org.uk>
References: <20140120100530.GY15937@n2100.arm.linux.org.uk> <20140120211601.GB634@kroah.com> <20140120213206.GJ15937@n2100.arm.linux.org.uk> <20140120231141.GA2355@kroah.com> <20140120231603.GL15937@n2100.arm.linux.org.uk> <20140120235128.GA5012@kroah.com> <20140121000706.GN15937@n2100.arm.linux.org.uk> <20140121002623.GA6173@kroah.com> <20140121003856.GP15937@n2100.arm.linux.org.uk> <20140121092531.350ab714@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121092531.350ab714@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:25:31AM +0000, One Thousand Gnomes wrote:
> > static DEFINE_MUTEX(foo_mutex);
> > static unsigned foo_devices;
> > 
> > static int foo_probe(struct platform_device *pdev)
> > {
> > 	int ret;
> > 
> > 	mutex_lock(&foo_mutex);
> > 	if (foo_devices++ == 0)
> > 		uart_register_driver(&driver);
> > 
> > 	ret = foo_really_probe_device(pdev);
> 
> We have atomic_inc_and_test and atomic_dec_and_test so it's
> fractionally less ugly.

How do atomics help here?  If we do this as:

	if (atomic_inc_and_test(&foo_atomic))
		uart_register_driver(&driver);

Then let's think about what can happen:

	CPU0				CPU1
	foo_probe
	atomic_inc_and_test() == true
		uart_register_driver
					foo_probe
					atomic_inc_and_test()
					really_probe_foo()
						*bang*

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
