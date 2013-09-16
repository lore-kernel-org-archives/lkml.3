Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3IPIFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:05:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:52883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab3IPIFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,913,1371106800"; 
   d="scan'208";a="378737987"
Date: Mon, 16 Sep 2013 11:10:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 2/2] gpio / ACPI: add support for GPIO operation regions
Message-ID: <20130916081048.GM7393@intel.com>
References: <1379085280-2211-1-git-send-email-mika.westerberg@linux.intel.com>
 <1379085280-2211-2-git-send-email-mika.westerberg@linux.intel.com>
 <1AE640813FDE7649BE1B193DEA596E880246367A@SHSMSX101.ccr.corp.intel.com>
 <20130915065151.GK7393@intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024639E4@SHSMSX101.ccr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802463A46@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802463A46@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 01:21:53AM +0000, Zheng, Lv wrote:
> > A pseudo device may be created to access the GPIO operation region fields provided by one GPIO device.
> > The pseudo device may have other functions to access other GPIO operation region fields provided by other GPIO devices, or even worse to
> > access other ACPI provided value-adds.
> > So hierarchically the pseudo device only requires CPU, thus should not be under the GPIO device, which means the GPIO operation regions
> > have nothing to do with the GPIO devices' ACPI handle.
> 
> Sorry for the wording.
> It's better to say the GPIO operation region users haven't strict
> relationship to the GPIO operation region providers.
> As the installation is to provide GPIO operation regions to the users, it
> shouldn't relate to the providers' ACPI handle.

If I understand you correctly you mean that there might be multiple users
(different devices) for the same GPIO operation region, right?

That shouldn't be a problem as far as I can tell.

What comes to the hierarchy you refer, I'm not sure if that is a problem
either (unless I'm missing something). The GPIO can be used anywhere in the
ASL, it doesn't have to be descendant of the GPIO device. You only need to
do something like this:

	// Assert the GPIO
	Store(1, \_SB.PCI0.SHD3)

In other words, use the fully qualified name.

Typically when the GPIO device _REG() is called it sets some variable like
AVBL to true which is then checked in the code that uses the GPIO:

	If (LEqual (\_SB.PCI0.GPO0.AVBL, One))
	{
		Store (Zero, \_SB.PCI0..SHD3)
	}

So if there is no driver, this part of the code is never called.
