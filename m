Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3FLNr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:47:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:48481 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3FLNr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:47:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,852,1363132800"; 
   d="scan'208";a="30684960"
Message-ID: <51B87BDF.1080101@eu.citrix.com>
Date: Wed, 12 Jun 2013 14:47:11 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.
References: <20130610202456.GA17822@phenom.dumpdata.com> <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com> <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com> <51B743EA.5020800@eu.citrix.com> <51B74B77.1000806@oracle.com> <51B74DA9.7060509@eu.citrix.com> <20130612134504.GG2918@phenom.dumpdata.com>
In-Reply-To: <20130612134504.GG2918@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 14:45, Konrad Rzeszutek Wilk wrote:
> On Tue, Jun 11, 2013 at 05:17:45PM +0100, George Dunlap wrote:
>> On 06/11/2013 05:08 PM, konrad wilk wrote:
>>> On 6/11/2013 11:36 AM, George Dunlap wrote:
>>>> On 06/10/2013 10:06 PM, Konrad Rzeszutek Wilk wrote:
>>>>> There are two tool-stack that can instruct the Xen PCI frontend
>>>>> and backend to change states: 'xm' (Python code with a daemon),
>>>>> and 'xl' (C library - does not keep state changes).
>>>>>
>>>>> With the 'xm', the path to disconnect a PCI device (xm pci-detach
>>>>> <guest> <BDF>)is:
>>>>>
>>>>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)->
>>>>> 4(Connected)->5(Closing*).
>>>>>
>>>>> The * is for states that the tool-stack sets. For 'xl', it is similar:
>>>>>
>>>>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
>>>>>
>>>>> Both of them also tear down the XenBus structure, so the backend
>>>>> state ends up going in the 3(Initialised) and calls
>>>>> pcifront_xenbus_remove.
>>>> So I looked a little bit into this; there are actually two different
>>>> states that happen as part of this handshake.  In order to disonnect a
>>>> *device*, xl signals using the *bus* state, like this:
>>>> * Wait for the *bus* to be in state 4(Connected)
>>>> * Set the *device* state to 5(Closing)
>>>> * Set the *bus* state to 7(Reconfiguring)
>>>> * Wait for the *bus* state to return to 4(Connected)
>>>>
>>>> So are all of these states you see the *bus* state?  And why would you
>>>> disconnect the whole pci bus if you're only removing one device?
>>> Correct. The stats I enumerated are *bus* states. Not per-device states.
>>> I presume (and I hadn't checked xm) that Xend has some logic to only
>>> disconnect the bus if all of the PCI devices have been disconnected. In
>>> 'xl' it does not do that.
>>>
>>> The testing I did was just with one PCI device.
>> Ah, OK -- I see now.  The problem is that the code in the Linux side
>> didn't know about the whole "4->7->8->4" thing to unplug a device.
>> In all likelihood, if you had used xm with two devices (so that the
>> bus didn't get disconnected), then you would have run across the
>> same error.
>>
>> So at least part of the problem *is* a bug in Linux.
> Good! Bjorn, would you be OK Ack-ing the patch I sent (attached here
> for reference) or putting it in your queue for Linus?
>
> My plan would be to send it to Linus in the 3.11 merge window.

One nit -- "to work with the 'xl' toolstack" -- didn't we theorize this 
would also be broken with xm if you had two devices passed through?

  -George
