Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3HAVzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab3HAVzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:55:41 -0400
Message-ID: <51FAD959.4000803@redhat.com>
Date: Thu, 01 Aug 2013 17:55:37 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org, indou.takao@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] pci: Tune secondary bus reset timing
References: <20130801164652.16145.79918.stgit@bling.home>  <20130801165557.16145.57324.stgit@bling.home> <51FAD338.5000306@redhat.com> <1375393280.31262.254.camel@ul30vt.home>
In-Reply-To: <1375393280.31262.254.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 05:41 PM, Alex Williamson wrote:
> On Thu, 2013-08-01 at 17:29 -0400, Don Dutile wrote:
>> On 08/01/2013 12:55 PM, Alex Williamson wrote:
>>> The PCI spec indicates that with stable power, reset needs to be
>>> asserted for a minimum of 1ms (Trst).  Seems like we should be able
>>> to assume power is stable for a runtime secondary bus reset.  The
>>> current code has always used 100ms with no explanation where that
>>> came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
>>> that seems to be a misinterpretation of the PCIe spec, where hot
>>> reset is implemented by TS1 ordered sets containing the hot reset
>>> command.  After a 2ms delay the state machine enters the detect state,
>>> but to generate a link down, only two consecutive TS1 hot reset
>>> ordered sets are requred.  1ms should be plenty for that.
>>>
>>> After reset is de-asserted we must wait for devices to complete
>>> initialization.  The specs refer to this as "recovery time" (Trhfa).
>>> For PCI this is 2^25 clock cycles or 2^26 for PCI-X.  For minimum
>>> bus speeds, both of those come to 1s.  PCIe "softens" this
>>> requirement with the Configuration Request Retry Status (CRS)
>>> completion status.  Theoretically we could use CRS to shorten the
>>> wait time.  We don't make use of that here, using a fixed 1s delay
>>> to allow devices to re-initialize.
>> Unfortunately, I don't think CRS is widely supported to make it worth
>> the additional checking&  use, atm.
>>
>>>
>>> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
>>> ---
>>>    drivers/pci/pci.c |   15 +++++++++++++--
>>>    1 file changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>> index 3e71887..a5c6a9b 100644
>>> --- a/drivers/pci/pci.c
>>> +++ b/drivers/pci/pci.c
>>> @@ -3291,11 +3291,22 @@ void pci_reset_bridge_secondary_bus(struct pci_dev *dev)
>>>    	pci_read_config_word(dev, PCI_BRIDGE_CONTROL,&ctrl);
>>>    	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
>>>    	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>>> -	msleep(100);
>>> +	/*
>>> +	 * PCI spec v3.0 7.6.4.2 requires minimum Trst of 1ms.
>>> +	 */
>>> +	msleep(1);
>>>
>>>    	ctrl&= ~PCI_BRIDGE_CTL_BUS_RESET;
>>>    	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
>>> -	msleep(100);
>>> +
>>> +	/*
>>> +	 * Trhfa for conventional PCI is 2^25 clock cycles.
>>> +	 * Assuming a minimum 33MHz clock this results in a 1s
>>> +	 * delay before we can consider subordinate devices to
>>> +	 * be re-initialized.  PCIe has some ways to shorten this,
>>> +	 * but we don't make use of them yet.
>>> +	 */
>>> +	ssleep(1);
>> Can't bus speed be determined from (config space) status bits, so
>> this time can be minimized, esp. on modern, PCIe busses/links ?
>> Not too many 33Mhz, legacy PCI busses that this type of
>> timing is desired, or will be done to (for device assignment/vfio). :-/
>
> Just like CRS, is it worth it?  The PCIe spec seems to indicate a 1s
> Trhfa regardless of bus speed.  Even if it didn't, we'd need to walk
> down through all the subordinate buses to find a least common
> denominator.  It seems sufficiently complicated to save it for a later
> optimization.  Thanks,
>
> Alex
>
ya sure.. I figured you had the spec memorized w/all these reset patches
you've worked on! ;-)

>>>    }
>>>    EXPORT_SYMBOL_GPL(pci_reset_bridge_secondary_bus);
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

