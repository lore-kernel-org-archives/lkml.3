Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaBTKoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:44:39 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:46804 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBTKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:44:37 -0500
Message-ID: <5305DC92.8050706@linaro.org>
Date: Thu, 20 Feb 2014 11:44:34 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 1/1] ACPI, PCI, ISA: Call ISA-specific code only for
 architectures which support ISA.
References: <1392806122-23318-1-git-send-email-tomasz.nowicki@linaro.org> <3640027.L0fXHYxIB5@vostro.rjw.lan>
In-Reply-To: <3640027.L0fXHYxIB5@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.02.2014 17:11, Rafael J. Wysocki wrote:
> On Wednesday, February 19, 2014 11:35:22 AM Tomasz Nowicki wrote:
>> This commit moves ISA-specific code to separate function and makes that
>> function depend on CONFIG_{E}ISA so that we do not have to maintain
>> acpi_isa_irq_to_gsi() function for architectures which do not support ISA.
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>> ---
>>   drivers/acpi/pci_irq.c |   35 +++++++++++++++++++++++++----------
>>   1 file changed, 25 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
>> index 361b40c..0a553a0 100644
>> --- a/drivers/acpi/pci_irq.c
>> +++ b/drivers/acpi/pci_irq.c
>> @@ -370,6 +370,30 @@ static struct acpi_prt_entry *acpi_pci_irq_lookup(struct pci_dev *dev, int pin)
>>   	return NULL;
>>   }
>>
>> +#if IS_ENABLED(CONFIG_ISA) || IS_ENABLED(CONFIG_EISA)
>> +static int acpi_isa_register_gsi(struct pci_dev *dev)
>> +{
>> +	u32 dev_gsi;
>> +
>> +	/* Interrupt Line values above 0xF are forbidden */
>> +	if (dev->irq > 0 && (dev->irq <= 0xF) &&
>> +	    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
>> +		dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
>> +			 pin_name(dev->pin), dev->irq);
>> +		acpi_register_gsi(&dev->dev, dev_gsi,
>> +				  ACPI_LEVEL_SENSITIVE,
>> +				  ACPI_ACTIVE_LOW);
>> +		return 0;
>> +	}
>> +	return -EINVAL;
>> +}
>> +#else
>> +static inline int acpi_isa_register_gsi(struct pci_dev *dev)
>> +{
>> +	return -ENODEV;
>> +}
>> +#endif
>> +
>>   int acpi_pci_irq_enable(struct pci_dev *dev)
>>   {
>>   	struct acpi_prt_entry *entry;
>> @@ -416,16 +440,7 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>>   	 * driver reported one, then use it. Exit in any case.
>>   	 */
>>   	if (gsi < 0) {
>> -		u32 dev_gsi;
>> -		/* Interrupt Line values above 0xF are forbidden */
>> -		if (dev->irq > 0 && (dev->irq <= 0xF) &&
>> -		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
>> -			dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
>> -				 pin_name(pin), dev->irq);
>> -			acpi_register_gsi(&dev->dev, dev_gsi,
>> -					  ACPI_LEVEL_SENSITIVE,
>> -					  ACPI_ACTIVE_LOW);
>> -		} else {
>> +		if (acpi_isa_register_gsi(dev)) {
>
> The curly brackets are not necessary here and you can even move the below into
> acpi_isa_register_gsi().
Right, the curly brackets can be removed.

My intention was to print warning when ISA is not supported too, and do 
not put dev_warn() into both version of acpi_isa_register_gsi(). So I 
would leave code below as it is.
>
>>   			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
>>   				 pin_name(pin));
>>   		}
>>
>
