Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab3F0QXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:23:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:64876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3F0QXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:23:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,953,1363158000"; 
   d="scan'208";a="360566010"
Date: Thu, 27 Jun 2013 19:27:40 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Message-ID: <20130627162739.GY9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
 <20130627135405.GW9294@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627135405.GW9294@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:54:05PM +0300, Mika Westerberg wrote:
> I think that we can get this working so that we add a new flag to struct
> pci_dev, something like 'no_additional_hotplug_bus_space' and in this quirk
> set that.
> 
> Then in __pci_bus_size_bridges() we do:
> 
> 	pci_bridge_check_ranges(bus);
> 	if (bus->self->is_hotplug_bridge &&
> 	    !bus->self->no_additional_hotplug_bus_space) {
> 		additional_io_size  = pci_hotplug_io_size;
> 		additional_mem_size = pci_hotplug_mem_size;
> 	}
> 
> This should prevent the problem this patch was trying to solve. Does that
> work for you?

Forget about that -- It looks like these messages are harmless:

    pcieport 0000:0a:05.0: BAR 8: can't assign mem (size 0x200000)
    pcieport 0000:0a:05.0: BAR 9: can't assign mem pref (size 0x200000)

It just means that we tried to allocate the resource but failed because the
bridge has that window closed, if I got it right. If user doesn't want to
see those, he/she can always pass 'pci=hpmensize=0,hpiosize=0' in the
kernel command line.

With pcibios_resource_survey_bus() fix, looks like this quirk is not needed
at all.
