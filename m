Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3GXRJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:09:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:35778 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3GXRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:09:33 -0400
X-IronPort-AV: E=Sophos;i="4.89,736,1367971200"; 
   d="scan'208";a="37157308"
Message-ID: <51F00A4A.5060005@citrix.com>
Date: Wed, 24 Jul 2013 18:09:30 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
CC: <konrad.wilk@oracle.com>, <tpmdd-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <leosilva@linux.vnet.ibm.com>,
        <shpedoikal@gmail.com>, <xen-devel@lists.xen.org>, <mail@srajiv.net>,
        <adlai@linux.vnet.ibm.com>, <tpmdd@sirrix.com>, <PeterHuewe@gmx.de>
Subject: Re: [PATCH v4] drivers/tpm: add xen tpmfront interface
References: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov> <51ED4D4A.3060705@citrix.com> <51ED5BD2.7080601@tycho.nsa.gov>
In-Reply-To: <51ED5BD2.7080601@tycho.nsa.gov>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/13 17:20, Daniel De Graaf wrote:
> On 07/22/2013 11:18 AM, David Vrabel wrote:
>> On 01/07/13 22:34, Daniel De Graaf wrote:
>>> This is a complete rewrite of the Xen TPM frontend driver, taking
>>> advantage of a simplified frontend/backend interface and adding support
>>> for cancellation and timeouts.  The backend for this driver is provided
>>> by a vTPM stub domain using the interface in Xen 4.3.
>> [...]
>>> --- /dev/null
>>> +++ b/Documentation/xen-tpmfront.txt
>>
>> Suggest putting this in Documentation/tpm/.
> 
> OK.
> 
>>> --- /dev/null
>>> +++ b/drivers/char/tpm/xen-tpmfront.c
>> [...]
>>> +static void backend_changed(struct xenbus_device *dev,
>>> +        enum xenbus_state backend_state)
>>> +{
>>> +    int val;
>>
>> Hrm. I don't like how every front/back pair invents their own variation
>> of the state machine.
>>
>> Please document the front and back state machines in
>> xen/include/public/io/tpmif.h (and the correspoding copy in Linux).
> 
> Is there a standard state machine that would allow devices to avoid
> inventing their own?

That would be nice wouldn't it?  But, no, there isn't one -- even
netfront and blkfront are different.

> Otherwise, this is what I plan to add to the header:
> /*
>  * Xenbus state machine
>  *
>  * Device open:
>  *   1. Both ends start in XenbusStateInitialising
>  *   2. Backend transitions to InitWait (frontend does not wait on this
> step)
>  *   3. Frontend populates ring-ref, event-channel, feature-protocol-v2
>  *   4. Frontend transitions to Initialised
>  *   5. Backend maps grant and event channel, verifies feature-protocol-v2
>  *   6. Backend transitions to Connected
>  *   7. Frontend verifies feature-protocol-v2, transitions to Connected
>  *
>  * Device close:
>  *   1. State is changed to XenbusStateClosing
>  *   2. Frontend transitions to Closed
>  *   3. Backend unmaps grant and event, changes state to InitWait
>  */

That's good, thanks.

David
