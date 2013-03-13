Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092Ab3CMRqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:46:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53277 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934080Ab3CMRp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:45:59 -0400
Subject: Re: [PATCH] USB: ehci-s5p: Fix phy reset
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAD=FV=UXaZvZJOZwAguwi=iyYO1iMSvt8fdEsDhr96pgMXDYSg@mail.gmail.com>
Date: Wed, 13 Mar 2013 18:45:52 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <A763CC55-549D-4CCD-8EE8-2BCE17F84606@suse.de>
References: <1363136988-3704-1-git-send-email-agraf@suse.de> <CAD=FV=UXaZvZJOZwAguwi=iyYO1iMSvt8fdEsDhr96pgMXDYSg@mail.gmail.com>
To: Doug Anderson <dianders@chromium.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13.03.2013, at 18:28, Doug Anderson wrote:

> Alexander,
> 
> On Tue, Mar 12, 2013 at 6:09 PM, Alexander Graf <agraf@suse.de> wrote:
>> -       err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
>> -       if (err)
>> +       /* reset pulls the line down, then up again */
>> +       err = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, "ehci_vbus_gpio");
>> +       if (err) {
>>                dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
>> +               return;
>> +       }
>> +       mdelay(1);
>> +       __gpio_set_value(gpio, 1);
>> +       gpio_free(gpio);
> 
> Freeing the gpio is a little on the iffy side since you actually care
> about keeping the value.  Perhaps you can change this to
> devm_gpio_request_one() and avoid the free?  I was about to submit a
> patch to do just that (since otherwise you run into trouble if you
> ever defer the probe) but then ran across your patch.

I could also just return it when the function exits and only free it when we exit the probe function with a negative value. The reason I put it in here was that on probe deferral, the pin simply gets blocked.

However, I could probably also just completely take the gpio_free() out of this patch and resubmit, as it should be pretty much unrelated. Then you can patch it properly.


Alex

> 
> Thanks!
> 
> -Doug

