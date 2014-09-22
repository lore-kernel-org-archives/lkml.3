Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaIVNrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:47:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:59959 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaIVNrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,571,1406617200"; 
   d="scan'208";a="479176673"
Date: Mon, 22 Sep 2014 16:45:35 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices
 addresses
Message-ID: <20140922134535.GZ1786@lahna.fi.intel.com>
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <20140922104555.GQ1786@lahna.fi.intel.com>
 <542023C8.8080802@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542023C8.8080802@metafoo.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:27:36PM +0200, Lars-Peter Clausen wrote:
> On 09/22/2014 12:45 PM, Mika Westerberg wrote:
> >On Fri, Sep 05, 2014 at 04:02:19PM +0200, Jean-Michel Hautbois wrote:
> >>Some I2C devices have multiple addresses assigned, for example each address
> >>corresponding to a different internal register map page of the device.
> >>So far drivers which need support for this have handled this with a driver
> >>specific and non-generic implementation, e.g. passing the additional address
> >>via platform data.
> >>
> >>This patch provides a new helper function called i2c_new_secondary_device()
> >>which is intended to provide a generic way to get the secondary address
> >>as well as instantiate a struct i2c_client for the secondary address.
> >>
> >>The function expects a pointer to the primary i2c_client, a name
> >>for the secondary address and an optional default address. The name is used
> >>as a handle to specify which secondary address to get.
> >>
> >>The default address is used as a fallback in case no secondary address
> >>was explicitly specified. In case no secondary address and no default
> >>address were specified the function returns NULL.
> >>
> >>For now the function only supports look-up of the secondary address
> >>from devicetree, but it can be extended in the future
> >>to for example support board files and/or ACPI.
> >>
> >>Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> >
> >Sorry, just noticed this one.
> >
> >Srinivas (CC'd) and I did similar patch series here:
> >
> >http://patchwork.ozlabs.org/patch/338342/

Sorry I gave wrong link. That one is older version.

Here is the current:

http://patchwork.ozlabs.org/patch/386409/
http://patchwork.ozlabs.org/patch/386410/

> >
> >We should probably collaborate on this one to get both DT and ACPI
> >supported.
> 
> Yes. The idea was to keep the interface of the API generic so it can be used
> by ACPI or other device topology description mechanisms as well.
> 
> But it looks as if the ACPI case is a bit more complex and we may need a
> revision of the API. How for example in the ACPI case do you know which
> address is which, when different parts of a chip are addressed using
> different addresses?

Unfortunately there is no way in ACPI 5.0 to find out which is which. So
we trust the ordering of I2cSerialBus() resources. Even that has been
problematic because some vendors then list things like SMBus ARA
addresses there in random order :-(

Our API has following signature:

int i2c_address_by_index(struct i2c_client *client, int index,
			 struct i2c_board_info *info,
			 struct i2c_adapter **adapter)

and we use index to find out which address to use.

Note also that in ACPI it is possible that the I2cSerialBus() resource
points to another I2C host controller, so we need to have 'adapter'
parameter as well.
