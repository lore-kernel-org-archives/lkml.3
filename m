Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3J3QcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:32:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:1926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3J3QcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:32:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="382333300"
Message-ID: <52713584.60804@linux.intel.com>
Date: Wed, 30 Oct 2013 09:36:20 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com> <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 03:47 PM, Paul Zimmerman wrote:
>> From: David Cohen
>> Sent: Tuesday, October 29, 2013 2:53 PM
>>
>> These patches are a proposal to add gadget quirks in an immediate objective to
>> adapt f_fs when using DWC3 controller. But the quirk solution is generic and
>> can be used by other controllers to adapt gadget functions to their
>> non-standard restrictions.
>>
>> This change is necessary to make Android's adbd service to work on Intel
>> Merrifield with f_fs instead of out-of-tree android gadget.
>>
>> ---
>> David Cohen (3):
>>    usb: gadget: add quirks field to struct usb_gadget
>>    usb: ffs: check quirk to pad epout buf size when not aligned to
>>      maxpacketsize
>>    usb: dwc3: add quirk USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE to gadget
>>      driver
>>
>>   drivers/usb/dwc3/gadget.c  |  1 +
>>   drivers/usb/gadget/f_fs.c  | 17 +++++++++++++++++
>>   include/linux/usb/gadget.h |  5 +++++
>>   3 files changed, 23 insertions(+)
>
> Wouldn't it be simpler and safer to just do this unconditionally? Sure,
> you need it for DWC3 because the controller refuses to do an OUT transfer
> at all if the transfer size is less than maxpacketsize. But it's possible
> that other controllers allow the transfer, and it works in most cases,
> but if an error occurs and the host sends too much data, they could
> overrun the buffer and crash your device.
>
> For example, the DWC2 databook says "For OUT transfers, the Transfer
> Size field in the endpoint's Transfer Size register must be a multiple
> of the maximum packet size of the endpoint". But I don't think the
> controller enforces that, it is up to the programmer to do the right
> thing. So that controller probably needs this quirk also. There could be
> more like that which we don't know about.

Unfortunately DWC2 is a bad example... the driver couldn't even get out
of staging. If the author was reckless to ignore this restriction (s)he
should fix.
But I don't have enough data to tell it's better to waste everybody's
memory in this case in favor of DWC3. I'd still stick with the
exception.

>
> So unless the buffer allocation code is in a real fast path, I would
> suggest to just do the aligned buffer allocation always.

This code would affect embedded devices which value too much memory
consumption (and performance on handling it!). IMO we'd need to be more
careful prior to take such decision.

Br, David Cohen
