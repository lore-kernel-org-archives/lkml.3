Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3CAHlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:41:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3CAHlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:41:15 -0500
Message-ID: <51305B99.6080806@suse.de>
Date: Fri, 01 Mar 2013 08:41:13 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        Frederik Himpe <fhimpe@vub.ac.be>, Oliver Neukum <oneukum@suse.de>,
        David Haerdeman <david@hardeman.nu>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
References: <1361182193-31894-1-git-send-email-hare@suse.de> <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com> <5124820D.2080900@suse.de> <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com> <5125C45A.5020208@suse.de> <CAErSpo5j3Qge5Q2S+hyMGOcmoN77V0T=1+6OJdNJfJdnvT8wgg@mail.gmail.com>
In-Reply-To: <CAErSpo5j3Qge5Q2S+hyMGOcmoN77V0T=1+6OJdNJfJdnvT8wgg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 10:13 PM, Bjorn Helgaas wrote:
> [+cc Andy]
>
> On Wed, Feb 20, 2013 at 11:53 PM, Hannes Reinecke <hare@suse.de> wrote:
>> On 02/20/2013 05:57 PM, Yinghai Lu wrote:
>>>
>>> On Tue, Feb 19, 2013 at 11:58 PM, Hannes Reinecke <hare@suse.de> wrote:
>>>>>
>>>>>
>>>> Apparently this device is meant to use MSI _only_ so the BIOS developer
>>>> didn't feel the need to assign an INTx here.
>>>>
>>>> According to PCI-3.0, section 6.8 (Message Signalled Interrupts):
>>>>>
>>>>> It is recommended that devices implement interrupt pins to
>>>>> provide compatibility in systems that do not support MSI
>>>>> (devices default to interrupt pins). However, it is expected
>>>>> that the need for interrupt pins will diminish over time.
>>>>> Devices that do not support interrupt pins due to pin
>>>>> constraints (rely on polling for device service) may implement
>>>>> messages to increase performance without adding additional pins. >
>>>>> Therefore, system configuration software must not assume that a
>>>>> message capable device has an interrupt pin.
>>>>
>>>>
>>>> Which sounds to me as if the implementation is valid...
>>>
>>>
>>> it seems you mess pin with interrupt line.
>>>
>>> current code:
>>>           unsigned char irq;
>>>
>>>           pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq);
>>>           dev->pin = irq;
>>>           if (irq)
>>>                   pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
>>>           dev->irq = irq;
>>>
>>> so if the device does not have interrupt pin implemented, pin should be
>>> zero.
>>> and  pin and irq in dev should
>>> be all 0.
>>>
>> But the device _has_ an interrupt pin implemented.
>> The whole point here is that the interrupt line is _NOT_ zero.
>>
>> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
>> Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04) (prog-if 30
>> [XHCI])
>>          Subsystem: Hewlett-Packard Company Device [103c:179b]
>>          Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>          Interrupt: pin A routed to IRQ 255
>>          Region 0: Memory at d4720000 (64-bit, non-prefetchable) [size=64K]
>>          Capabilities: [70] Power Management version 2
>>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>                  Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
>>          Capabilities: [80] MSI: Enable- Count=1/8 Maskable- 64bit+
>>                  Address: 0000000000000000  Data: 0000
>>
>> So at one point we have to decide that ->irq is not valid, despite it being
>> not set to zero.
>> An alternative fix would be this:
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index 68a921d..4a480cb 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -469,6 +469,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>                  } else {
>>                          dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>>                                   pin_name(pin));
>> +                       dev->irq = 0;
>>                  }
>>                  return 0;
>>          }
>>
>> Which probably is a better solution, as here ->irq is _definitely_
>> not valid, so we should reset it to '0' to avoid confusion on upper
>> layers.
>
> I didn't like the pci_read_irq() change because the PCI spec doesn't
> say anything about any PCI_INTERRUPT_LINE values being invalid.
>
> I like this solution better, but I still don't quite understand it.
> We have the following code in acpi_pci_irq_enable().  We have
> previously tried to look up "gsi," but the _PRT doesn't mention this
> device, so we have "gsi == -1" at this point:
>
>          /*
>           * No IRQ known to the ACPI subsystem - maybe the BIOS /
>           * driver reported one, then use it. Exit in any case.
>           */
>          if (gsi < 0) {
>                  u32 dev_gsi;
>                  /* Interrupt Line values above 0xF are forbidden */
>                  if (dev->irq > 0 && (dev->irq <= 0xF) &&
>                      (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
>                          dev_warn(&dev->dev, "PCI INT %c: no GSI -
> using ISA IRQ %d\n",
>                                   pin_name(pin), dev->irq);
>                          acpi_register_gsi(&dev->dev, dev_gsi,
>                                            ACPI_LEVEL_SENSITIVE,
>                                            ACPI_ACTIVE_LOW);
>                  } else {
>                          dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>                                   pin_name(pin));
>                  }
>
>                  return 0;
>          }
>
> 1) I don't know where the restriction of 0x1-0xF came from.
> Presumably this value of dev->irq came from PCI_INTERRUPT_LINE, and I
> don't know what forbids values > 0xF.  The test was added by Andy
> Grover in the attached commit.  This is ancient history; probably Andy
> doesn't remember either :)
>
This is most likely due to ISA compability. Cf ACPI 4.0,
section 5.2.12.4 Platforms with APIC and Dual 8259 Support:

 > Systems that support both APIC and dual 8259 interrupt models
 > must map global system interrupts 0-15 to the 8259 IRQs 0-15,
 > except where Interrupt Source Overrides are provided (see section
 > 5.2.10.8, “Interrupt Source Overrides”). This means that I/O APIC
 > interrupt inputs 0-15 must be mapped to global system interrupts
 > 0-15 and have identical sources as the 8259 IRQs 0-15 unless
 > overrides are used. This allows a platform to support OSPM
 > implementations that use the APIC model as well as OSPM
 > implementations that use the 8259 model (OSPM will only use
 > one model; it will not mix models).
 > When OSPM supports the 8259 model, it will assume that all
 > interrupt descriptors reporting global system interrupts 0-15
 > correspond to 8259 IRQs. In the 8259 model all global system
 > interrupts greater than 15 are ignored. If OSPM implements APIC
 > support, it will enable the APIC as described by the APIC
 > specification and will use all reported global system interrupts
 > that fall within the limits of the interrupt inputs defined by
 > the I/O APIC structures. For more information on hardware
 > resource configuration see section 6, “Configuration.”

> 2) The proposed change (setting "dev->irq = 0" when we didn't find
> anything in the _PRT and dev->irq > 0xF) throws away some information,
> and I fear it could break systems.  For example, what would happen if
> a system put an IOAPIC pin number in a device's PCI_INTERRUPT_LINE and
> omitted the device from _PRT?  Is it possible the device would still
> work as-is (with acpi_pci_irq_enable() doing nothing), but would break
> if we set dev->irq = 0?
>
How so? It would still be required to get an interrupt from 
somewhere, and if ACPI doesn't know about it where should the
information come from?

> 3) I don't understand why the xhci init fails in the first place.  It
> looks like the "request interrupt 255 failed" message is from
> xhci_try_enable_msi(), but that function tries to enable MSI-X, then
> MSI, then falls back to legacy interrupts, where we get the error.
> But the device supports MSI, so I don't know why we even fall back to
> trying legacy interrupts.  Hannes, do you have any insight into that?
> Obviously I'm missing something here.
>
Hehe. Due to overly clever design.
xhci actually sets up interrupts _twice_, once per request_irq() in 
the generic code and a second time during xhci_run.
But as the first call fails it'll never ever run the second part.

I'll be sending a patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
