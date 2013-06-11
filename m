Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3FKNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:04:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab3FKNEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:04:09 -0400
Message-ID: <51B7203A.8030601@oracle.com>
Date: Tue, 11 Jun 2013 09:03:54 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: George Dunlap <george.dunlap@eu.citrix.com>
CC: Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.
References: <20130610202456.GA17822@phenom.dumpdata.com> <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com> <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com> <51B6EDDF02000078000DCFB7@nat28.tlf.novell.com> <51B6E711.2000001@eu.citrix.com>
In-Reply-To: <51B6E711.2000001@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/11/2013 5:00 AM, George Dunlap wrote:
> On 06/11/2013 08:29 AM, Jan Beulich wrote:
>>>>> On 10.06.13 at 23:06, Konrad Rzeszutek Wilk 
>>>>> <konrad.wilk@oracle.com> wrote:
>>> There are two tool-stack that can instruct the Xen PCI frontend
>>> and backend to change states: 'xm' (Python code with a daemon),
>>> and 'xl' (C library - does not keep state changes).
>>>
>>> With the 'xm', the path to disconnect a PCI device (xm pci-detach
>>> <guest> <BDF>)is:
>>>
>>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 
>>> 4(Connected)->5(Closing*).
>>>
>>> The * is for states that the tool-stack sets. For 'xl', it is similar:
>>>
>>> 4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)
>>>
>>> Both of them also tear down the XenBus structure, so the backend
>>> state ends up going in the 3(Initialised) and calls 
>>> pcifront_xenbus_remove.
>>>
>>> When a PCI device is plugged in (xm pci-attach <guest> <BDF>)
>>> both of them follow the same pattern:
>>> 2(InitWait*), 3(Initialized*), 4(Connected*)->4(Connected).
>>>
>>> [xen-pcifront ignores the 2,3 state changes and only acts when
>>> 4 (Connected) has been reached]
>>>
>>> The problem is that git commit 3d925320e9e2de162bd138bf97816bda8c3f71be
>>> ("xen/pcifront: Use Xen-SWIOTLB when initting if required") introduced
>>> a mechanism to initialize the SWIOTLB when the Xen PCI front moves to
>>> Connected state. It also had some aggressive seatbelt code check that
>>> would warn the user if one tried to change to Connected state without
>>> hitting first the Closing state:
>>>
>>>   pcifront pci-0: PCI frontend already installed!
>>>
>>> However, that code can be relaxed and we can continue on working
>>> even if the frontend is instructed to be the 'Connected' state with
>>> no devices and then gets tickled to be in 'Connected' state again.
>>>
>>> In other words, this 4(Connected)->5(Closing)->4(Connected) state
>>> was expected, while 4(Connected)->.... anything but 
>>> 5(Closing)->4(Connected)
>>> was not. This patch removes that aggressive check and allows
>>> Xen pcifront to work with the 'xl' toolstack.
>>
>> I actually think this shouldn't be worked around here, but fixed in
>> xl. Any device removed from a guest should be driven towards
>> the "Closed" state.

There is also the per-device state. Those are moved to the 5 (Closing), 
while the
whole connection is still in the 4(Connected) state. In essence all of 
the per-device states
are closed, it is just that the global state is still Connected.


>
> Yeah, that seems pretty obvious to me.  The weird thing is that this 
> wasn't noticed before -- does this work in 4.2?  Have you been doing 
> this test all along, or has it only broken recently?

I just reproduced this in Xen 4.2. I believe that the reason I did not 
see this before was b/c I was using 'xm'
primarily.
>
> I've reproduced it on one of my test boxes; let me see if I can sort 
> it out.

OK.
>
>  -George
>

