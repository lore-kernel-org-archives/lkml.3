Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3LBBF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:05:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57795 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751989Ab3LBBFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:05:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] PCI / tg3: Give up chip reset and carrier loss handling if PCI device is not present
Date: Mon, 02 Dec 2013 02:18:50 +0100
Message-ID: <3652057.Ek7BjA2Oi2@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <7807315.7cU9KldDtM@vostro.rjw.lan> <1385930359.6988.7.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 01, 2013 12:39:19 PM Michael Chan wrote:
> On Sun, 2013-12-01 at 02:34 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Modify tg3_chip_reset() and tg3_close() to check if the PCI network
> > adapter device is accessible at all in order to skip poking it or
> > trying to handle a carrier loss in vain when that's not the case.
> > Introduce a special PCI helper function pci_device_is_present()
> > for this purpose.
> > 
> > Of course, this uncovers the lack of the appropriate RTNL locking
> > in tg3_suspend() and tg3_resume(), so add that locking in there
> > too.
> > 
> > These changes prevent tg3 from burning a CPU at 100% load level for
> > solid several seconds after the Thunderbolt link is disconnected from
> > a Matrox DS1 docking station. 
> 
> I'm not familiar with the DS1.  Does the tg3 device get removed through
> tg3_remove_one() in this case?

Yes, this is a normal removal except that the device is gone physically when
it happens.

Thunderbolt cable disconnect is like a power failure for all devices on
the link (that is, all devices in the DS1 in this particular case).

> What happens when you reconnect the DS1?

Well, it works.  ACPIPHP just waits for the removal to complete and then it
handles the hot-add event and the device works normally after that.

The only problem is that without the patch the hot-removal takes a few seconds
and quite a lot of CPU power due to the tight loop spinning in tg3_carrier_off()
called by tg3_close(), while with the patch it just happens almost instantaneously.

And in the Thunderbolt disconnect case doing the entire tg3_chip_reset() is
pointless anyway, because the config space of the device is not available then.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
