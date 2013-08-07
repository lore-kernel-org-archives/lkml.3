Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab3HGQYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:24:09 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:44191 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754422Ab3HGQYH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:24:07 -0400
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130807161557.GO7656@atomide.com>
Date: Wed, 7 Aug 2013 19:23:59 +0300
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4B64047B-505F-4D54-871B-8F1B5315B613@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com> <20130806093356.GA27889@kroah.com> <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com> <20130807161557.GO7656@atomide.com>
To: Tony Lindgren <tony@atomide.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Aug 7, 2013, at 7:15 PM, Tony Lindgren wrote:

> * Pantelis Antoniou <panto@antoniou-consulting.com> [130806 02:44]:
>> On Aug 6, 2013, at 12:33 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Aug 06, 2013 at 10:53:44AM +0300, Pantelis Antoniou wrote:
>>>> +
>>>> static int _omap_device_notifier_call(struct notifier_block *nb,
>>>> 				      unsigned long event, void *dev)
>>>> {
>>>> @@ -185,9 +211,13 @@ static int _omap_device_notifier_call(struct notifier_block *nb,
>>>> 	struct omap_device *od;
>>>> 
>>>> 	switch (event) {
>>>> -	case BUS_NOTIFY_DEL_DEVICE:
>>>> +	case BUS_NOTIFY_UNBOUND_DRIVER:
>>>> +		/* NOTIFY_DEL_DEVICE is not the right call...
>>>> +		 * we use a callback here, to make sure no-one is going to
>>>> +		 * try to use the omap_device data after they're deleted
>>>> +		 */
>>>> 		if (pdev->archdata.od)
>>>> -			omap_device_delete(pdev->archdata.od);
>>>> +			device_schedule_callback(dev, _omap_device_cleanup);
>>> 
>>> Really?  This is one sign that you are totally using the driver core
>>> incorrectly.  You shouldn't have to rely on notifier callbacks to handle
>>> device removals, your bus code should do that for you directly.
>>> 
>>> I don't like this at all, sorry.
>>> 
>> 
>> Don't shoot the messenger please...
> 
> As you're inititalizing capebus with DT, let's figure out what if
> anything you actually need from omap_device. I'd much rather remove
> dependencies than add more.
> 

There is no such thing as capebus anymore. This is just the path of
removing a platform device, which happens to also be an omap_device.

> If you need omap_device for the clocks, there are patches pending to
> make them DT only for omaps. And we already have DT based solution for
> pins, regulators and DMA.
> 
> So what else remains? The pieces needed for runtime PM?
> 

What happens here is that the omap_device data are freed prematurely and then end up 
used again during the teardown of the platform device.


>> This is all about fixing a crash without messing too many things.
> 
> It seems this fix is only needed for supporting out-of-tree code?
> These features with omap_device we may not even want to support in
> the mainline tree as is being discussed..
> 

What out of tree code? The only thing this patch does is make sure we
don't crash when a perfectly valid call to platform_device_unregister() happens.

Drivers that don't use omap_device work just fine.

> Regards,
> 
> Tony
> 

Regards

-- Pantelis

