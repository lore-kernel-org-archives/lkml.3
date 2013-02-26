Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3BZNgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:36:10 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:53322 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab3BZNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:35:57 -0500
Date: Tue, 26 Feb 2013 14:29:05 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Hannes Reinecke <hare@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: do not try to assign irq 255
Message-ID: <20130226132905.GB24959@hardeman.nu>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
	Frederik Himpe <fhimpe@vub.ac.be>, Oliver Neukum <oneukum@suse.de>,
	linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
References: <1361182193-31894-1-git-send-email-hare@suse.de>
 <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
 <5124820D.2080900@suse.de>
 <CAE9FiQXHteymDNzu0GqWtVSVhu3g2hCT+K9e5tB1mR-OBX1ffA@mail.gmail.com>
 <5125C45A.5020208@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5125C45A.5020208@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 07:53:14AM +0100, Hannes Reinecke wrote:
>On 02/20/2013 05:57 PM, Yinghai Lu wrote:
>>it seems you mess pin with interrupt line.
>>
>>current code:
>>         unsigned char irq;
>>
>>         pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq);
>>         dev->pin = irq;
>>         if (irq)
>>                 pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
>>         dev->irq = irq;
>>
>>so if the device does not have interrupt pin implemented, pin should be zero.
>>and  pin and irq in dev should
>>be all 0.
>>
>But the device _has_ an interrupt pin implemented.
>The whole point here is that the interrupt line is _NOT_ zero.
>
...
>
>So at one point we have to decide that ->irq is not valid, despite it
>being not set to zero.
>An alternative fix would be this:
>
>diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>index 68a921d..4a480cb 100644
>--- a/drivers/acpi/pci_irq.c
>+++ b/drivers/acpi/pci_irq.c
>@@ -469,6 +469,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>                } else {
>                        dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>                                 pin_name(pin));
>+                       dev->irq = 0;
>                }
>                return 0;
>        }
>
>Which probably is a better solution, as here ->irq is _definitely_
>not valid, so we should reset it to '0' to avoid confusion on upper
>layers.
>

Is there any agreement on how to proceed?

-- 
David Härdeman
