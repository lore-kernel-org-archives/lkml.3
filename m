Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaLDKTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:19:23 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62749 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaLDKTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:19:19 -0500
Date: Thu, 4 Dec 2014 02:19:15 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the driver-core tree with the
 net-next tree
Message-ID: <20141204101915.GA9689@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org
References: <20141201181933.6dfaad66@canb.auug.org.au>
 <547C19ED.10201@broadcom.com>
 <20141203083655.GA5418@hudson.localdomain>
 <20141203105148.GA7633@hudson.localdomain>
 <547F06BC.8060000@broadcom.com>
 <20141203210659.GA8974@hudson.localdomain>
 <20141203214128.GB8974@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203214128.GB8974@hudson.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend,

I haven't heard if you have looked at this bug at all yet.  I was
curious so I looked at it some more and I have some more information
that might be helpful.

On Wed, Dec 03, 2014 at 01:41:28PM -0800, Jeremiah Mahler wrote:
> On Wed, Dec 03, 2014 at 01:06:59PM -0800, Jeremiah Mahler wrote:
> > Arend,
> > 
[...]
> > > >
> > > >I took a look at the patch that is causing this problem (d32394fae95).
> > > >My config negates everything in the patch except for a one line change
> > > >to ath9k/pci.c.  If I remove this change (shown below) the problem goes
> > > >away.
> > > 
> > > Ok. But then it will likely crash when you cat one of the changed debugfs
> > > files. Guess this commit needs to be reverted entirely.
> > > 
[...]

Referring to the code snippet below, notice that both pci_set_drvdata()
and dev_set_drvdata() are called.  If the call to dev_set_drvdata() is
removed the bug goes away.

  drivers/net/wireless/ath/ath9k/pci.c

  861     SET_IEEE80211_DEV(hw, &pdev->dev);
  862     pci_set_drvdata(pdev, hw);
  863
  864     sc = hw->priv;
  865     sc->hw = hw;
  866     sc->dev = &pdev->dev;
  867     dev_set_drvdata(sc->dev, sc);
  868     sc->mem = pcim_iomap_table(pdev)[0];
  869     sc->driver_data = id->driver_data;

Translating the call to pci_set_drvdata() produces the following.

  pci_set_drvdata(pdev, hw);
    (translating from include/linux/pci.h)
    dev_set_drvdata(&pdev->dev, hw)
      (translating from include/linux/device.h)
      &pdev->dev->driver = hw;

And doing the same for dev_set_drvdata().

  dev_set_drvdata(sc->dev, sc)
    (sc->dev = &pdev->dev)
    dev_set_drvdata(&pdev->dev, sc)
      (translating from include/linux/device.h)
      &pdev->dev->driver = sc;

The same destination is being set with two different values.  Then calls
to pci_get_drvdata(), which expect hw, are getting sc, and it breaks.

-- 
- Jeremiah Mahler
