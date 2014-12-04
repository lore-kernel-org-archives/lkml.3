Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaLDLlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:41:25 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2735 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaLDLlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:41:24 -0500
X-IronPort-AV: E=Sophos;i="5.07,515,1413270000"; 
   d="scan'208";a="52424771"
Message-ID: <54804861.2060407@broadcom.com>
Date: Thu, 4 Dec 2014 12:41:21 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: linux-next: manual merge of the driver-core tree with the net-next
 tree
References: <20141201181933.6dfaad66@canb.auug.org.au> <547C19ED.10201@broadcom.com> <20141203083655.GA5418@hudson.localdomain> <20141203105148.GA7633@hudson.localdomain> <547F06BC.8060000@broadcom.com> <20141203210659.GA8974@hudson.localdomain> <20141203214128.GB8974@hudson.localdomain> <20141204101915.GA9689@hudson.localdomain>
In-Reply-To: <20141204101915.GA9689@hudson.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-12-14 11:19, Jeremiah Mahler wrote:
> Arend,
> 
> I haven't heard if you have looked at this bug at all yet.  I was
> curious so I looked at it some more and I have some more information
> that might be helpful.
> 
> On Wed, Dec 03, 2014 at 01:41:28PM -0800, Jeremiah Mahler wrote:
>> On Wed, Dec 03, 2014 at 01:06:59PM -0800, Jeremiah Mahler wrote:
>>> Arend,
>>>
> [...]
>>>>>
>>>>> I took a look at the patch that is causing this problem (d32394fae95).
>>>>> My config negates everything in the patch except for a one line change
>>>>> to ath9k/pci.c.  If I remove this change (shown below) the problem goes
>>>>> away.
>>>>
>>>> Ok. But then it will likely crash when you cat one of the changed debugfs
>>>> files. Guess this commit needs to be reverted entirely.
>>>>
> [...]
> 
> Referring to the code snippet below, notice that both pci_set_drvdata()
> and dev_set_drvdata() are called.  If the call to dev_set_drvdata() is
> removed the bug goes away.
> 
>   drivers/net/wireless/ath/ath9k/pci.c
> 
>   861     SET_IEEE80211_DEV(hw, &pdev->dev);
>   862     pci_set_drvdata(pdev, hw);
>   863
>   864     sc = hw->priv;
>   865     sc->hw = hw;
>   866     sc->dev = &pdev->dev;
>   867     dev_set_drvdata(sc->dev, sc);
>   868     sc->mem = pcim_iomap_table(pdev)[0];
>   869     sc->driver_data = id->driver_data;
> 
> Translating the call to pci_set_drvdata() produces the following.
> 
>   pci_set_drvdata(pdev, hw);
>     (translating from include/linux/pci.h)
>     dev_set_drvdata(&pdev->dev, hw)
>       (translating from include/linux/device.h)
>       &pdev->dev->driver = hw;
> 
> And doing the same for dev_set_drvdata().
> 
>   dev_set_drvdata(sc->dev, sc)
>     (sc->dev = &pdev->dev)
>     dev_set_drvdata(&pdev->dev, sc)
>       (translating from include/linux/device.h)
>       &pdev->dev->driver = sc;
> 
> The same destination is being set with two different values.  Then calls
> to pci_get_drvdata(), which expect hw, are getting sc, and it breaks.

Yes, that was my suspicion as well. This is why I asked to revert the
patch entirely. I see that sc equals hw->priv so I know how to correct
it. However, with merge window around the corner it may be easier to do
a revert.

Regards,
Arend
