Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3FKQIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:08:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20061 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3FKQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:08:35 -0400
Message-ID: <51B74B77.1000806@oracle.com>
Date: Tue, 11 Jun 2013 12:08:23 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.
References: <20130610202456.GA17822@phenom.dumpdata.com> <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com> <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com> <51B743EA.5020800@eu.citrix.com>
In-Reply-To: <51B743EA.5020800@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2013 11:36 AM, George Dunlap wrote:
> On 06/10/2013 10:06 PM, Konrad Rzeszutek Wilk wrote:
>> There are two tool-stack that can instruct the Xen PCI frontend
>> and backend to change states: 'xm' (Python code with a daemon),
>> and 'xl' (C library - does not keep state changes).
>>
>> With the 'xm', the path to disconnect a PCI device (xm pci-detach
>> <guest> <BDF>)is:
>>
>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 
>> 4(Connected)->5(Closing*).
>>
>> The * is for states that the tool-stack sets. For 'xl', it is similar:
>>
>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
>>
>> Both of them also tear down the XenBus structure, so the backend
>> state ends up going in the 3(Initialised) and calls 
>> pcifront_xenbus_remove.
>
> So I looked a little bit into this; there are actually two different 
> states that happen as part of this handshake.  In order to disonnect a 
> *device*, xl signals using the *bus* state, like this:
> * Wait for the *bus* to be in state 4(Connected)
> * Set the *device* state to 5(Closing)
> * Set the *bus* state to 7(Reconfiguring)
> * Wait for the *bus* state to return to 4(Connected)
>
> So are all of these states you see the *bus* state?  And why would you 
> disconnect the whole pci bus if you're only removing one device?

Correct. The stats I enumerated are *bus* states. Not per-device states.
I presume (and I hadn't checked xm) that Xend has some logic to only 
disconnect the bus if all of the PCI devices have been disconnected. In 
'xl' it does not do that.

The testing I did was just with one PCI device.
>
>  -George

