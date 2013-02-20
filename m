Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934725Ab3BTH6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:58:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934651Ab3BTH6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:58:08 -0500
Message-ID: <5124820D.2080900@suse.de>
Date: Wed, 20 Feb 2013 08:58:05 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        Frederik Himpe <fhimpe@vub.ac.be>, Oliver Neukum <oneukum@suse.de>,
        David Haerdeman <david@hardeman.nu>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: do not try to assign irq 255
References: <1361182193-31894-1-git-send-email-hare@suse.de> <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
In-Reply-To: <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 08:40 PM, Yinghai Lu wrote:
> On Mon, Feb 18, 2013 at 2:09 AM, Hannes Reinecke <hare@suse.de> wrote:
>> The PCI config space reseves a byte for the interrupt line,
>> so irq 255 actually refers to 'not set'.
>> However, the 'irq' field for struct pci_dev is an integer,
>> so the original meaning is lost, causing the system to
>> assign an interrupt '255', which fails.
>>
>> So we should _not_ assign an interrupt value here, and
>> allow upper layers to fixup things.
>>
>> This patch make PCI devices with MSI interrupts only
>> (like the xhci device on certain HP laptops) work properly.
>
> looks like the bios does not provide _PRT for device in ACPI.
>
Correct.

> also according to PCI spec, BIOS *must* set interrupt line.
>
Apparently this device is meant to use MSI _only_ so the BIOS 
developer didn't feel the need to assign an INTx here.

According to PCI-3.0, section 6.8 (Message Signalled Interrupts):
 > It is recommended that devices implement interrupt pins to
 > provide compatibility in systems that do not support MSI
 > (devices default to interrupt pins). However, it is expected
 > that the need for interrupt pins will diminish over time.
 > Devices that do not support interrupt pins due to pin
 > constraints (rely on polling for device service) may implement
 > messages to increase performance without adding additional pins. 
 > Therefore, system configuration software must not assume that a
 > message capable device has an interrupt pin.

Which sounds to me as if the implementation is valid...
And in either case, I've added the relevant details plus patch
to bnc#52591.
Including ACPI dump, so you can check for yourself.

And correct me if I'm wrong, of course :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
