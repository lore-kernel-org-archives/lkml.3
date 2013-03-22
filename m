Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3CVQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:15:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480Ab3CVQPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:15:12 -0400
Message-ID: <514C8388.3050200@suse.cz>
Date: Fri, 22 Mar 2013 17:15:04 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Takashi Iwai <tiwai@suse.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Oliver Neukum <oneukum@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pciehp: Add pciehp_surprise module option
References: <s5h38vqjhk6.wl%tiwai@suse.de> <1363802953.24132.513.camel@bling.home> <s5hr4j9q48d.wl%tiwai@suse.de>
In-Reply-To: <s5hr4j9q48d.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.3.2013 20:08, Takashi Iwai wrote:
> At Wed, 20 Mar 2013 12:09:13 -0600,
> Alex Williamson wrote:
>>
>> On Wed, 2013-03-20 at 15:02 +0100, Takashi Iwai wrote:
>>> We encountered a problem that on some HP machines the Realtek PCI-e
>>> card reader device appears only when you inserted a card before the
>>> cold boot.  While debugging, it turned out that the device is actually
>>> handled via PCI-e hotplug in some level.  The device sends a presence
>>> change notification, and pciehp receives it, but it's ignored because
>>> of lack of the hotplug surprise (PCI_EXP_SLTCAP_HPS) capability bit.
>>> Once when this check passes, everything starts working -- the device
>>> appears upon plugging the card properly.
>>>
>>> There are a few other bug reports indicating the similar problems
>>> (e.g. on recent Dell laptops), and I guess the culprit is same.
>>>
>>> This patch adds a new module option, pciehp_surprise, to pciehp as a
>>> workaround.  When pciehp_surprise=1 is given, pciehp handles the
>>> presence change as the device on/off as if PCI_EXP_SLTCAP_HPS is set.
>>> Unless it's set explicitly, there is no impact on the existing
>>> behavior.
>>>
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> ---
>>>  drivers/pci/hotplug/pciehp.h      | 3 ++-
>>>  drivers/pci/hotplug/pciehp_core.c | 3 +++
>>>  2 files changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
>>> index 2c113de..314f3be 100644
>>> --- a/drivers/pci/hotplug/pciehp.h
>>> +++ b/drivers/pci/hotplug/pciehp.h
>>> @@ -44,6 +44,7 @@ extern bool pciehp_poll_mode;
>>>  extern int pciehp_poll_time;
>>>  extern bool pciehp_debug;
>>>  extern bool pciehp_force;
>>> +extern bool pciehp_surprise;
>>>  
>>>  #define dbg(format, arg...)						\
>>>  do {									\
>>> @@ -122,7 +123,7 @@ struct controller {
>>>  #define MRL_SENS(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_MRLSP)
>>>  #define ATTN_LED(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_AIP)
>>>  #define PWR_LED(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_PIP)
>>> -#define HP_SUPR_RM(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS)
>>> +#define HP_SUPR_RM(ctrl)	(pciehp_surprise || ((ctrl)->slot_cap & PCI_EXP_SLTCAP_HPS))
>>>  #define EMI(ctrl)		((ctrl)->slot_cap & PCI_EXP_SLTCAP_EIP)
>>>  #define NO_CMD_CMPL(ctrl)	((ctrl)->slot_cap & PCI_EXP_SLTCAP_NCCS)
>>>  #define PSN(ctrl)		((ctrl)->slot_cap >> 19)
>>> diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
>>> index 7d72c5e..c3a574e 100644
>>> --- a/drivers/pci/hotplug/pciehp_core.c
>>> +++ b/drivers/pci/hotplug/pciehp_core.c
>>> @@ -42,6 +42,7 @@ bool pciehp_debug;
>>>  bool pciehp_poll_mode;
>>>  int pciehp_poll_time;
>>>  bool pciehp_force;
>>> +bool pciehp_surprise;
>>>  
>>>  #define DRIVER_VERSION	"0.4"
>>>  #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
>>> @@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
>>>  module_param(pciehp_poll_mode, bool, 0644);
>>>  module_param(pciehp_poll_time, int, 0644);
>>>  module_param(pciehp_force, bool, 0644);
>>> +module_param(pciehp_surprise, bool, 0644);
>>>  MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
>>>  MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
>>>  MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
>>>  MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if OSHP is missing");
>>> +MODULE_PARM_DESC(pciehp_surprise, "Force to set hotplug-surprise capability");
>>>  
>>>  #define PCIE_MODULE_NAME "pciehp"
>>>  
>>
>> Please no.  Can we quirk just the device with the problem?
> 
> It'd be good to have a static quirk in the end, yes.

Alex, Matthew, would it work for you to have this debug / band-aid
option _and_ have a list of either machines' dmi strings that have this
problem, or devices' PCI IDs (*), and enable the surprise event handling
for such machines / devices automatically?  The option would be still
useful for debugging, to be able to easily find out if given machine has
this problem and needs to be added to the quirk list.

(*) It would probably make more sense to have a list of dmi strings,
because it's the PCIe controller that does not set the capability bit
when it should. The device (Realtek card reader in this case) seems to
behave correctly. The machines in question have been laptops or
all-in-one PCs so far, so there should be no problem with dmi matches.

Thanks,
Michal
