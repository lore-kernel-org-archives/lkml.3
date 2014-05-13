Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaEMCPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:15:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44891 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaEMCO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:14:59 -0400
Date: Mon, 12 May 2014 19:14:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Antonio Ospite <ao2@ao2.it>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Daniel Ribeiro <drwyrm@gmail.com>,
        Ilya Petrov <ilya.muromec@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] input: pcap2: avoid calling mutex_lock() in irq handler
Message-ID: <20140513021456.GE26152@core.coreip.homeip.net>
References: <1396731290-7062-1-git-send-email-khoroshilov@ispras.ru>
 <20140406202436.GA16739@core.coreip.homeip.net>
 <20140406233744.c40387e9bead51ee48e5ebd1@ao2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140406233744.c40387e9bead51ee48e5ebd1@ao2.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 11:37:44PM +0200, Antonio Ospite wrote:
> On Sun, 6 Apr 2014 13:24:36 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Sun, Apr 06, 2014 at 12:54:50AM +0400, Alexey Khoroshilov wrote:
> > > pcap_keys_handler() calls ezx_pcap_read() that calls mutex_lock().
> > > pcap_keys_handler() is registered as nonthreaded irq handler,
> > > that means sleeping function is called in irq handler.
> > > 
> > > The patch makes a switch to threaded irq handling.
> > > Compile tested only.
> > > 
> > > Found by Linux Driver Verification project (linuxtesting.org).
> > > 
> > > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > > ---
> > >  drivers/input/misc/pcap_keys.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
> > > index cd230365166e..2a10f3a30969 100644
> > > --- a/drivers/input/misc/pcap_keys.c
> > > +++ b/drivers/input/misc/pcap_keys.c
> > > @@ -79,13 +79,15 @@ static int pcap_keys_probe(struct platform_device *pdev)
> > >  	if (err)
> > >  		goto fail_allocate;
> > >  
> > > -	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> > > -			pcap_keys_handler, 0, "Power key", pcap_keys);
> > > +	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> > > +				   NULL, pcap_keys_handler, 0,
> > > +				   "Power key", pcap_keys);
> > >  	if (err)
> > >  		goto fail_register;
> > >  
> > > -	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> > > -			pcap_keys_handler, 0, "Headphone button", pcap_keys);
> > > +	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> > > +				   NULL, pcap_keys_handler, 0,
> > > +				   "Headphone button", pcap_keys);
> > 
> > So I guess we do need threaded IRQ here, but I do not see the pcap's
> > irqchip specifying IRQCHIP_ONESHOT_SAFE so I do not think
> > request_threaded_irq() without IRQF_ONESHOT would succeed.
> > 
> > Can someone test the change to be sure?
> > 
> 
> I can try to test it in a couple of weeks, I don't have the hardware
> at hand right now.

Antonio, did you have a chance to try this out yet?

Thanks!

-- 
Dmitry
