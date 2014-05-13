Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbaEMINM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:13:12 -0400
Received: from smtp207.alice.it ([82.57.200.103]:6373 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbaEMINJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:13:09 -0400
Date: Tue, 13 May 2014 10:13:01 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Daniel Ribeiro <drwyrm@gmail.com>,
        Ilya Petrov <ilya.muromec@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH] input: pcap2: avoid calling mutex_lock() in irq handler
Message-Id: <20140513101301.6d9d2994d5e198bbb24cba57@ao2.it>
In-Reply-To: <20140513021456.GE26152@core.coreip.homeip.net>
References: <1396731290-7062-1-git-send-email-khoroshilov@ispras.ru>
	<20140406202436.GA16739@core.coreip.homeip.net>
	<20140406233744.c40387e9bead51ee48e5ebd1@ao2.it>
	<20140513021456.GE26152@core.coreip.homeip.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2014 19:14:56 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Sun, Apr 06, 2014 at 11:37:44PM +0200, Antonio Ospite wrote:
> > On Sun, 6 Apr 2014 13:24:36 -0700
> > Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > On Sun, Apr 06, 2014 at 12:54:50AM +0400, Alexey Khoroshilov wrote:
> > > > pcap_keys_handler() calls ezx_pcap_read() that calls mutex_lock().
> > > > pcap_keys_handler() is registered as nonthreaded irq handler,
> > > > that means sleeping function is called in irq handler.
> > > > 
> > > > The patch makes a switch to threaded irq handling.
> > > > Compile tested only.
> > > > 
> > > > Found by Linux Driver Verification project (linuxtesting.org).
> > > > 
> > > > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > > > ---
> > > >  drivers/input/misc/pcap_keys.c | 10 ++++++----
> > > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
> > > > index cd230365166e..2a10f3a30969 100644
> > > > --- a/drivers/input/misc/pcap_keys.c
> > > > +++ b/drivers/input/misc/pcap_keys.c
> > > > @@ -79,13 +79,15 @@ static int pcap_keys_probe(struct platform_device *pdev)
> > > >  	if (err)
> > > >  		goto fail_allocate;
> > > >  
> > > > -	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> > > > -			pcap_keys_handler, 0, "Power key", pcap_keys);
> > > > +	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_ONOFF),
> > > > +				   NULL, pcap_keys_handler, 0,
> > > > +				   "Power key", pcap_keys);
> > > >  	if (err)
> > > >  		goto fail_register;
> > > >  
> > > > -	err = request_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> > > > -			pcap_keys_handler, 0, "Headphone button", pcap_keys);
> > > > +	err = request_threaded_irq(pcap_to_irq(pcap_keys->pcap, PCAP_IRQ_MIC),
> > > > +				   NULL, pcap_keys_handler, 0,
> > > > +				   "Headphone button", pcap_keys);
> > > 
> > > So I guess we do need threaded IRQ here, but I do not see the pcap's
> > > irqchip specifying IRQCHIP_ONESHOT_SAFE so I do not think
> > > request_threaded_irq() without IRQF_ONESHOT would succeed.
> > > 
> > > Can someone test the change to be sure?
> > > 
> > 
> > I can try to test it in a couple of weeks, I don't have the hardware
> > at hand right now.
> 
> Antonio, did you have a chance to try this out yet?
> 
> Thanks!

I'll try to set up the environment this week-end, if I fail I'll tell
you; sorry for stalling you.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
