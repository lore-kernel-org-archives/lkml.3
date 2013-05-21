Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3EUPls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:41:48 -0400
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:50569 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3EUPlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:41:46 -0400
From: "Liu, Joseph" <Joseph.Liu@Emulex.Com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Zhang, LongX" <longx.zhang@intel.com>
CC: "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Subject: RE: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Topic: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
Thread-Index: Ac5CQUdmhbSX64FbRraxMqZGOLGlLwABCDYwBOhZoQAAE4z+sA==
Date: Tue, 21 May 2013 15:41:44 +0000
Message-ID: <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com>
In-Reply-To: <20130520224824.GA31740@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.74.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index ed4d094..7abefd9 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>>  	pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>>  	int retval;
>>  
>> -	/* If fatal, restore cfg space for possible link reset at upstream */
>> -	if (dev->error_state == pci_channel_io_frozen) {
>> -		dev->state_saved = true;
>> -		pci_restore_state(dev);
>> -		pcie_portdrv_restore_config(dev);
>> -		pci_enable_pcie_error_reporting(dev);
>> -	}
>> +	/* restore cfg space for possible link reset at upstream */
>> +	dev->state_saved = true;
>> +	pci_restore_state(dev);
>> +	pcie_portdrv_restore_config(dev);
>> +	pci_enable_pcie_error_reporting(dev);
>>  
>>  	/* get true return value from &status */
>>  	retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
>
>I think this patch changes the behavior in the case of a non-fatal error
>where one of the .error_detected() methods returned
>PCI_ERS_RESULT_NEED_RESET.  In that case, pcie_portdrv_slot_reset()
>previously did not restore config space, but after your patch, it *will*
>restore it.  We need an explanation of why this is safe. 

Here is my understanding of this part of the patch:

I think your concern here should not be an issue. Whether it is a non-fatal error or a fatal error, as long as one of the .error_detected() method from the downstream drivers involved returns a PCI_ERS_RESULT_NEED_RESET, it should trump all others and a slot reset should be performed, even though it was originally due to a non-fatal error reported or only one of the downstream drivers requests it. In the case of AER driver, this should be implemented in the broadcast_error_message() with pci_walk_bus() by passing in the report_error_detected() function, and merging the results into the result_data->result...

In any case, the fact that this pcie_portdrv_slot_reset() being invoked should be considered as a aftermath of a slot reset has been performed, thus the restore of config space should be performed after the reset. I suppose the restore should be to the same state as fresh power-on states, right?

Thanks,
Joe Liu, Ph.D.
Senior Principal Engineer
Emulex Corporation

