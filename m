Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3GBKlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:41:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:26678 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3GBKlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,980,1363158000"; 
   d="scan'208";a="363430554"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
Subject: RE: [PATCH 5/6] PCI: acpiphp: look _RMV method a bit deeper in the
 hierarhcy
Content-Transfer-Encoding: 7bit
Message-Id: <20130702104406.4473EE0090@blue.fi.intel.com>
Date: Tue,  2 Jul 2013 13:44:06 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Westerberg wrote:
> The acpiphp driver finds out whether the device is hotpluggable by checking
> whether it has _RMV method behind it (and if it returns 1). However, at
> least Acer Aspire S5 with Thunderbolt host router has this method placed
> behind device called EPUP (endpoint upstream port?) and not directly behind
> the root port as can be seen from the ASL code below:
> 
> Device (RP05)
> {
> 	...
> 	Device (HRUP)
> 	{
> 		Name (_ADR, Zero)
> 		Name (_PRW, Package (0x02)
> 		{
> 			0x09,
> 			0x04
> 		})
> 		Device (HRDN)
> 		{
> 			Name (_ADR, 0x00040000)
> 			Name (_PRW, Package (0x02)
> 			{
> 				0x09,
> 				0x04
> 			})
> 			Device (EPUP)
> 			{
> 				Name (_ADR, Zero)
> 				Method (_RMV, 0, NotSerialized)
> 				{
> 					Return (One)
> 				}
> 			}
> 		}
> 	}
> 
> If we want to support such machines we must look for the _RMV method a bit
> deeper in the hierarchy. Fix this by changing pcihp_is_ejectable() to check
> few more devices down from the root port.

We found that this approach is broken. We've got false positive: host
bridge itself was detected as hotplugable slot %) I think it's not
acceptable.

Mika has tried few more approaches, but we haven't found anything better
then hardcoded path like in original workaround patch[1]. It's not generic
at all, but safe from false positives.

Any thoughts?

[1] http://article.gmane.org/gmane.linux.kernel.pci/19102

-- 
 Kirill A. Shutemov
