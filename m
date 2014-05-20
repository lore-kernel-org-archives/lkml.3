Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaETJf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:35:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:47648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaETJf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:35:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,873,1392192000"; 
   d="scan'208";a="534734603"
Message-ID: <537B24B8.9050303@linux.intel.com>
Date: Tue, 20 May 2014 12:47:36 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, Dan Williams <dan.j.williams@intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com> <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com> <20140520010137.GA8146@kroah.com>
In-Reply-To: <20140520010137.GA8146@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:01 AM, Greg KH wrote:
> On Thu, May 08, 2014 at 07:25:55PM +0300, Mathias Nyman wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Add a command line switch for disabling ehci port switchover.  Useful
>> for working around / debugging xhci incompatibilities where ehci
>> operation is available.
>>
>> Reference: http://marc.info/?l=linux-usb&m=138920063001509&w=2
>>
>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Cc: Holger Hans Peter Freyther <holger@moiji-mobile.com>
>> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> ---
>>  Documentation/kernel-parameters.txt |  3 +++
>>  drivers/usb/host/pci-quirks.c       | 15 +++++++++++++--
>>  2 files changed, 16 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 4384217..fc3403114 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -2251,6 +2251,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>  
>>  	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
>>  
>> +	noxhci_port_switch
>> +			[USB] Use EHCI instead of XHCI where available
>> +
> 
> Ugh, I really don't like new command line options.
> 
> Especially one that isn't very well documented.  Why would someone want
> to enable this?  What problem is it solving?  Can we detect this
> automatically and do it for the user?  Is this just for prototype
> hardware that has not shipped?  What hardware needs this?
> 
> I need a whole lot more documentation at the very least before I will
> apply this.
> 

On Intel hardware with both ehci and xhci controllers we can select if a usb2 port
is controlled by ehci or xhci. This capability can be checked from Intel xhci pci
config space. Xhci driver checks this on boot and switches over the supported ports.

This is a feature in Intel Panther point and later chipsets, in shipped hardware.
Its working quite well in most cases, but sometimes vendors claim they support
switchover, but then forget to connect some wires, and the usb2 port ends up dead
after switching.

A recently found case is the Sony VAIO T-series. (I'll send you a different patch
for that shortly)
http://marc.info/?l=linux-usb&m=139993106029340&w=2

This is the extreme case that the usb2 ports appears completely dead.
Other reasons are that some devices might work better under ehci than xhci,
and users want to enforce the ehci opton. For powermanagement developers it's nice
to disable switchover as it turns out some hardware are quirky with port
switchover and suspend/resume. (might need to turn port back to ehci before
suspending).

I don't think we can detect this automatically.

Dan, can you add more documentation to this patch?

-Mathias
