Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3BZNuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:50:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3BZNuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:50:02 -0500
Message-ID: <512CBD88.5020008@suse.de>
Date: Tue, 26 Feb 2013 14:50:00 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] pci: do not try to assign irq 255
References: <1361182193-31894-1-git-send-email-hare@suse.de> <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com> <5124820D.2080900@suse.de> <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com> <5125C45A.5020208@suse.de> <20130226132905.GB24959@hardeman.nu>
In-Reply-To: <20130226132905.GB24959@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 02:29 PM, David Härdeman wrote:
> On Thu, Feb 21, 2013 at 07:53:14AM +0100, Hannes Reinecke wrote:
>> On 02/20/2013 05:57 PM, Yinghai Lu wrote:
>>> it seems you mess pin with interrupt line.
>>>
>>> current code:
>>>          unsigned char irq;
>>>
>>>          pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq);
>>>          dev->pin = irq;
>>>          if (irq)
>>>                  pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
>>>          dev->irq = irq;
>>>
>>> so if the device does not have interrupt pin implemented, pin should be zero.
>>> and  pin and irq in dev should
>>> be all 0.
>>>
>> But the device _has_ an interrupt pin implemented.
>> The whole point here is that the interrupt line is _NOT_ zero.
>>
> ...
>>
>> So at one point we have to decide that ->irq is not valid, despite it
>> being not set to zero.
>> An alternative fix would be this:
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index 68a921d..4a480cb 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -469,6 +469,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>                 } else {
>>                         dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>>                                  pin_name(pin));
>> +                       dev->irq = 0;
>>                 }
>>                 return 0;
>>         }
>>
>> Which probably is a better solution, as here ->irq is _definitely_
>> not valid, so we should reset it to '0' to avoid confusion on upper
>> layers.
>>
>
> Is there any agreement on how to proceed?
>
I would actually prefer the second solution, as the ACPI code gives
some better guarantees here. With the original solution it _might_ 
be that on non-ACPI systems an interrupt 255 is valid, so it might
incur unwanted regressions.

However, for an ACPI system we only have the two choices, assigning
an interrupt via ACPI tables or use a default GSI value.
If both failed the interrupt definitely is not valid and can safely
be reset to 0.

But this would need a formal ACK from the ACPI gods ...
Len? Rafael?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
