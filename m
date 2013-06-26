Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3FZMQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:16:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49597 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3FZMQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:16:32 -0400
Message-ID: <51CADB9D.3070206@ti.com>
Date: Wed, 26 Jun 2013 17:46:29 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: host: xhci-plat: Enable XHCI_SPURIOUS_SUCCESS quirk
 for xhci-plat
References: <1372237137-17351-1-git-send-email-george.cherian@ti.com> <20130626090213.GQ12640@arwen.pp.htv.fi>
In-Reply-To: <20130626090213.GQ12640@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2013 2:32 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Jun 26, 2013 at 02:28:57PM +0530, George Cherian wrote:
>> Synopsis xhci controllers with hci_version > 0.96 gives spurious success
>> events on short packet completion. During webcam capture the
>> "ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
>> The same application works fine with synopsis controllers hci_version 0.96.
>>
>> Signed-off-by: George Cherian<george.cherian@ti.com>
>> ---
>>   drivers/usb/host/xhci-plat.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index 93ad67e..e63c6d3 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -25,6 +25,16 @@ static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
>>   	 * dev struct in order to setup MSI
>>   	 */
>>   	xhci->quirks |= XHCI_BROKEN_MSI;
>> +
>> +	/*
>> +	 * In some xhci controllers which follows xhci 1.0 spec gives a spurious
>> +	 * success event after a short transfer. This quirk will ignore such
>> +	 * spurious event. Hit this issue in synopsis xhci controllers with
>> +	 * hci_version > 0.96
>> +	 */
>> +
>> +	if (xhci->hci_version > 0x96)
>> +		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
>>   }
> doesn't look like the correct way to do this. What if enabling that
> quirk on hosts which don't have the quirk cause problems ?
For a controller which does not have this issue will never get a 
spurious success for short packet ( and that too for only ISOCH).

per this commit ad808333d Intel xhci: Ignore spurious successful event.

This spurious successful event behavior isn't technically disallowed by
the xHCI specification, so make the xHCI driver just ignore the spurious
completion event.
> I would suggest adding a platform_data which (in our case) dwc3 will
> pass to xhci-plat. Then you can do proper revision detection of the
> synopsys controller and set the quirk only on the failing hosts.
>
> BTW, do you have the STARS number for this errata ?
No STARS number yet.


Regards
-George
