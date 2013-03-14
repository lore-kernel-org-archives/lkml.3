Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934461Ab3CNAaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:30:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab3CNAaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:30:16 -0400
Subject: Re: [PATCH] USB: ehci-s5p: Fix phy reset
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CAD=FV=W331nkdJJhXrXe739o+-iBSzGAS6anu+C_mmix0MbAUg@mail.gmail.com>
Date: Thu, 14 Mar 2013 01:30:09 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <D288652A-C975-46D5-92D8-048463C15AAB@suse.de>
References: <1363136988-3704-1-git-send-email-agraf@suse.de> <CAD=FV=UXaZvZJOZwAguwi=iyYO1iMSvt8fdEsDhr96pgMXDYSg@mail.gmail.com> <A763CC55-549D-4CCD-8EE8-2BCE17F84606@suse.de> <CAD=FV=W331nkdJJhXrXe739o+-iBSzGAS6anu+C_mmix0MbAUg@mail.gmail.com>
To: Doug Anderson <dianders@chromium.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13.03.2013, at 18:59, Doug Anderson wrote:

> Alexander,
> 
> On Wed, Mar 13, 2013 at 10:45 AM, Alexander Graf <agraf@suse.de> wrote:
>> 
>>>> +       gpio_free(gpio);
>>> 
>>> Freeing the gpio is a little on the iffy side since you actually care
>>> about keeping the value.  Perhaps you can change this to
>>> devm_gpio_request_one() and avoid the free?  I was about to submit a
>>> patch to do just that (since otherwise you run into trouble if you
>>> ever defer the probe) but then ran across your patch.
>> 
>> I could also just return it when the function exits and only free it when we exit the probe function with a negative value. The reason I put it in here was that on probe deferral, the pin simply gets blocked.
>> 
>> However, I could probably also just completely take the gpio_free() out of this patch and resubmit, as it should be pretty much unrelated. Then you can patch it properly.
> 
> Sure, if you want to resubmit without the gpio_free() I'll submit a
> new patch atop yours with the change to devm and people can see if
> they like it...

Hrm. So when I remove the gpio_free() again, I can't find the USB hub anymore. If I however postpone the whole reset procedure until after the potential deferral, it works (see patch below).

Any idea what is going on here?


Alex


diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index f692f70..b29b2b8 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -136,8 +136,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
        if (!pdev->dev.coherent_dma_mask)
                pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
-       s5p_setup_vbus_gpio(pdev);
-
        s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
                                GFP_KERNEL);
        if (!s5p_ehci)
@@ -157,6 +155,8 @@ static int s5p_ehci_probe(struct platform_device *pdev)
                s5p_ehci->otg = phy->otg;
        }
 
+       s5p_setup_vbus_gpio(pdev);
+
        s5p_ehci->dev = &pdev->dev;
 
        hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,