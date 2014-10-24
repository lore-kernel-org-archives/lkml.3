Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaJXOLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:11:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:57502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaJXOLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:11:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,780,1406617200"; 
   d="scan'208";a="595279286"
Date: Fri, 24 Oct 2014 17:10:51 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lee Jones <lee.jones@linaro.org>, Darren Hart <dvhart@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Use ACPI companion to match only the first
 physical device
Message-ID: <20141024141051.GT1484@lahna.fi.intel.com>
References: <1414141950-228930-1-git-send-email-mika.westerberg@linux.intel.com>
 <2356721.6lgfg38MC8@vostro.rjw.lan>
 <1442328.iYt6Cj5IOV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1442328.iYt6Cj5IOV@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 04:20:41PM +0200, Rafael J. Wysocki wrote:
> > +static bool acpi_companion_match(const struct device *dev)
> > +{
> > +	struct acpi_device *adev;
> > +	bool ret;
> > +
> > +	adev = ACPI_COMPANION(dev);
> > +	if (!adev)
> > +		return false;
> > +
> > +	if (list_empty(&adev->pnp.ids))
> > +		return false;
> > +
> > +	ret = true;
> 
> On a second thought, should we return true if the list of physical devices is
> empty?  That surely means ACPI_COMPANION(dev) lied to us?

I didn't consider that it is even possible but yes, in that case we
should not return true here.

> 
> > +	mutex_lock(&adev->physical_node_lock);
> > +	if (!list_empty(&adev->physical_node_list)) {
> > +		const struct acpi_device_physical_node *node;
> > +
> > +		node = list_first_entry(&adev->physical_node_list,
> > +					struct acpi_device_physical_node, node);
> > +		if (node->dev != dev)
> > +			ret = false;
> 
> And that may be simply
> 
> 		ret = node->dev == dev;

OK.

> > +	}
> > +	mutex_unlock(&adev->physical_node_lock);
> > +
> > +	return ret;
> > +}
> > +
