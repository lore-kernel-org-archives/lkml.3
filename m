Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3C3MXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:23:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3C3MXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:23:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 3/7] USB: EHCI: make ehci-s5p a separate driver
Date: Sat, 30 Mar 2013 12:22:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
References: <Pine.LNX.4.44L0.1303291534190.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291534190.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301222.54337.arnd@arndb.de>
X-Provags-ID: V02:K0:fsQ9GHGX5BBrJRQ2JpiUS3AwCFqvGBeGqW+4CyI8Qjc
 RgMSgchakVxkyQC1BIzZWRVPFROhaAcRTCqJrFweOIvprhuksM
 6K4jdc2KuYsxlHA5E9GgIcnst/9tyOzBwzMSqk5N6/w/yvQBmP
 nd30e46abHbvFKp0+NBe1hi+z8MR8AoKHoZTx+hUluse3IPOiQ
 l4EZ2niKtYm3JCTOJUsDVFQdAeHLa+WbAYpYYP1VLaS7JY0Oux
 CtKTaiqnaVspuwFoQtccRcshfpA379/ZUB8kzhWPvHsq7gEVCX
 JwnLk3yyLnyPe/1aYcGL038HsogDf72ajDfTOXu0MN2B5mRT/9
 XvECKS6n+6ZsEnSGdlZo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:
> On Thu, 28 Mar 2013, Arnd Bergmann wrote:

> 
> Personally, I would have left these two functions the way they were and 
> relied on the compiler to inline them when appropriate.  Eliminating 
> them just makes the code more complicated.

Yes, makes sense. I'm leaving the change in now, because I don't
see a strong reason to undo the change, and the two functions
will likely get collapsed into a single line each after the move
to the phy subsystem is complete.

> >  static int s5p_ehci_probe(struct platform_device *pdev)
> >  {
> > +	struct usb_hcd *hcd ;
> >  	struct s5p_ehci_platdata *pdata = pdev->dev.platform_data;
> > +	const struct hc_driver *driver = &s5p_ehci_hc_driver;
> >  	struct s5p_ehci_hcd *s5p_ehci;
> > -	struct usb_hcd *hcd;
> 
> What's the reason for these changes?  There's no need for the "driver" 
> variable, and improper whitespace was added to the declaration of 
> "hcd".

I'll let Manjunath answer this, I have no idea. My suspicion is that
it was a misguided attempt to work around a checkpatch warning for
an overly long line.

I've reverted the above changes now for v4.

> > @@ -153,16 +117,12 @@ static int s5p_ehci_probe(struct platform_device *pdev)
> >  		s5p_ehci->otg = phy->otg;
> >  	}
> >  
> > -	s5p_ehci->dev = &pdev->dev;
> > -
> > -	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
> > -					dev_name(&pdev->dev));
> > +	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
> 
> s5p_ehci is not initialized correctly.  The devm_kzalloc() call was 
> left in and to_s5p_ehci() was not called.

Oh crap.

I checked that Manjunath had fixed this bug in the other drivers, but
missed it here. I updated it for v4 now.

> Was anybody able to test this patch?

I thought that Manjunath had received hardware for it now, but it's pretty
evident that the patch was not tested. The Ack from Jingoo Han was for an
older version that did not contain the change to .extra_priv_size.

	Arnd
