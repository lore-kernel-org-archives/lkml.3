Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3GVQVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:21:41 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:54522 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932561Ab3GVQVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:21:39 -0400
X-TM-IMSS-Message-ID: <669bdbee0017620e@nsa.gov>
Message-ID: <51ED5BD2.7080601@tycho.nsa.gov>
Date: Mon, 22 Jul 2013 12:20:34 -0400
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, leosilva@linux.vnet.ibm.com,
        shpedoikal@gmail.com, xen-devel@lists.xen.org, mail@srajiv.net,
        adlai@linux.vnet.ibm.com, tpmdd@sirrix.com, PeterHuewe@gmx.de
Subject: Re: [PATCH v4] drivers/tpm: add xen tpmfront interface
References: <1372714468-28120-1-git-send-email-dgdegra@tycho.nsa.gov> <51ED4D4A.3060705@citrix.com>
In-Reply-To: <51ED4D4A.3060705@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 11:18 AM, David Vrabel wrote:
> On 01/07/13 22:34, Daniel De Graaf wrote:
>> This is a complete rewrite of the Xen TPM frontend driver, taking
>> advantage of a simplified frontend/backend interface and adding support
>> for cancellation and timeouts.  The backend for this driver is provided
>> by a vTPM stub domain using the interface in Xen 4.3.
> [...]
>> --- /dev/null
>> +++ b/Documentation/xen-tpmfront.txt
>
> Suggest putting this in Documentation/tpm/.

OK.

>> --- /dev/null
>> +++ b/drivers/char/tpm/xen-tpmfront.c
> [...]
>> +static void backend_changed(struct xenbus_device *dev,
>> +		enum xenbus_state backend_state)
>> +{
>> +	int val;
>
> Hrm. I don't like how every front/back pair invents their own variation
> of the state machine.
>
> Please document the front and back state machines in
> xen/include/public/io/tpmif.h (and the correspoding copy in Linux).

Is there a standard state machine that would allow devices to avoid
inventing their own?

Otherwise, this is what I plan to add to the header:
/*
  * Xenbus state machine
  *
  * Device open:
  *   1. Both ends start in XenbusStateInitialising
  *   2. Backend transitions to InitWait (frontend does not wait on this step)
  *   3. Frontend populates ring-ref, event-channel, feature-protocol-v2
  *   4. Frontend transitions to Initialised
  *   5. Backend maps grant and event channel, verifies feature-protocol-v2
  *   6. Backend transitions to Connected
  *   7. Frontend verifies feature-protocol-v2, transitions to Connected
  *
  * Device close:
  *   1. State is changed to XenbusStateClosing
  *   2. Frontend transitions to Closed
  *   3. Backend unmaps grant and event, changes state to InitWait
  */

>> +
>> +	switch (backend_state) {
>> +	case XenbusStateInitialised:
>> +	case XenbusStateConnected:
>
> 		if (dev->state == XenbusStateConnected)
> 			break;
>
> Perhaps?

Sure, although the spurious invocation is not seen with the mini-os
backend and running this code twice is harmless.

>> +		if (xenbus_scanf(XBT_NIL, dev->otherend,
>> +				"feature-protocol-v2", "%d", &val) < 0)
>> +			val = 0;
>> +		if (!val) {
>> +			xenbus_dev_fatal(dev, -EINVAL,
>> +					"vTPM protocol 2 required");
>> +			return;
>> +		}
>> +		xenbus_switch_state(dev, XenbusStateConnected);
>> +		break;
>> +
>> +	case XenbusStateClosing:
>> +	case XenbusStateClosed:
>> +		device_unregister(&dev->dev);
>> +		xenbus_frontend_closed(dev);
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +}
>
> David

-- 
Daniel De Graaf
National Security Agency
