Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3FRAeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:34:12 -0400
Received: from atlmailgw1.ami.com ([63.147.10.40]:32499 "EHLO
	atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3FRAeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:34:07 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 20:34:07 EDT
X-AuditID: ac1060b2-b7f996d0000061b5-ab-51bfa77968cb
From: Zachary Bobroff <zacharyb@ami.com>
To: "'Matt Fleming'" <matt@console-pimps.org>, Jan Beulich <JBeulich@suse.com>
CC: Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <JLee@suse.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86, efi: retry ExitBootServices() on failure
Thread-Topic: [PATCH] x86, efi: retry ExitBootServices() on failure
Thread-Index: AQHOZnAqhIBWC10AuUqEyEUoHkYO0Zk0FHKAgAXZuoCAAAcVAIAACL6AgAAMY4CAABjOAIAAc6uQ
Date: Tue, 18 Jun 2013 00:18:18 +0000
Message-ID: <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
 <1371139233.6523.272.camel@linux-s257.site>
 <20130617092107.GA5440@console-pimps.org>
 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
 <20130617101745.GB8569@console-pimps.org>
 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
 <20130617123052.GE8569@console-pimps.org>
In-Reply-To: <20130617123052.GE8569@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.98.201]
Content-Type: text/plain; charset="us-ascii"
content-transfer-encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsWyRiBhhm7l8v2BBm/mC1v83POQzeLJw+/s
	Fm0PbzFaXN41h82if/sLdotvV6cxWVx9OJvFYsHGR4wOHB5nGt8weize85LJY92Nr+we67dc
	ZfH4vEkugDWqgdEmMS8vvySxJFUhJbU42VYpoCizLDG5UkkhM8VWyVBJoSAnMTk1NzWvxFYp
	saAgNS9FyY5LAQPYAJVl5imk5iXnp2TmpdsqeQb761pYmFrqGirZhWSkKmTmpeUX5SaWZObn
	KSTn55UAVaemAEUVEqawZjSe+MBa0KtfsazhBHsD4zy1LkZODgkBE4kvB24zQ9hiEhfurWfr
	YuTiEBJYzCTx9eRNKOcwo8S0rd9Zuxg5ONgENCRe7LUCaRAR8JFYff0gE0gNs8BcJolFK18w
	gSSEBZwkOvtes0AUOUt877/GCmFHSUzcvw2shkVAVWLZ1Y9sIDN5BfwlXrz2hth1h0li45mT
	YDWcAmYSFxt3MYLYjEDXfT+1BizOLCAucevJfCaIqwUkluw5D/WBqMTLx/9YIWxFiRMdjVD1
	OhILdn9ig7C1JZYtfA1WzysgKHFy5hOWCYxis5CMnYWkZRaSlllIWhYwsqxiFEosyclNzMxJ
	LzfUS8zN1EvOz93ECElBm3Ywtlw0P8QowMGoxMObILY/UIg1say4MvcQowQHs5IIb+zEfYFC
	vCmJlVWpRfnxRaU5qcWHGF2BwTKRWYobFHfAxBBvbGCAm6MkzrvzyhF/IYF0YLrKTk0tSC2C
	mcPEwSnVwHjpHk97yHHztffFhZ39lZ1X3nzr//S1XKnzn+zY9zbZnR2WVga61w4uDwwJn6jq
	Lsr1ye/sTtd/q6Uldny64jBLXfJJ4WkZGXfOXSwLlx7/U1v5tWZycUKgTfyLSRdZ9OySt3Xq
	TZhf+dU2VTb8/RI37+5tzFM8y7WeimoHXRU38Cxi92eoU2Ipzkg01GIuKk4EAOJnZShnAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

>> Why a single retry is having reasonable guarantees to work when the original one failed (nothing prevents an event handler to do another allocation the next time through).

This patch is being submitted because of the potential issues that occur when 3rd party option ROMs are signaled by the ExitBootServices event. At the time they are signaled, they can perform any number of actions that would change the EFI Memory map.  This wasn't actually seen with our default implementation of our firmware, it was seen when this plug-in card's option rom was run.

We only need to retry once because of what is in the UEFI specification 2.3.1 Errata C.  The exact verbiage is as follows:

The ExitBootServices() function is called by the currently executing EFI OS loader image to terminate all boot services. On success, the loader becomes responsible for the continued operation of the system. All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES must be signaled before ExitBootServices() returns EFI_SUCCESS. The events are only signaled once even if ExitBootServices() is called multiple times.

Since the firmware will only signal the ExitBootServices event once, the code that has the potential to change the memory map will only be signaled on the first call to exit boot services.

>>Can we know why increased the size of double *mem_map is big enough? Does there have any real guarantee to be sufficient?  And, why would doubling the increment be necessary here, but not in __get_map()?

Thinking of this as "doubling the increment" is not very clear.  I think a better way to think about this is that the GetMemoryMap is going to return the number of MemoryMap Entries, in bytes.  Then the "doubling the increment" can be thought of as us saying we want to allocate space for two additional Efi Memory Map Descriptors.  

Here is the logic for why we need space for the two additional Efi Memory Map Descriptors is as follows:
First, we should think of the size that is returned from the GetMemoryMap as being the number of bytes to contain the current memory map.  Once we have the size of the current memory map, we, the kernel, have to perform an allocation of memory so that we can store the current memory map into some memory that will not be overwritten. That allocation has the possibility of increasing the current memory map count by one efi_memory_desc_t structure.  Since we are going to call low_alloc, which itself calls getmemorymap to determine the lowest address that is available before it performs out requested allocation, we have to increase the memory map by another entry to account for the possibility that its allocation ill increase the memory map by another entry. 

It may make more sense to consider trying to allocate the space with AllocateMaxAddress as the type.  The allocation routine will allocate space using the address supplied as the maximum(upper bound).  It is my understanding that you need this memory map at some low address, perhaps you know the upper bound of where it could exist?  This would remove any problems that are being created by low_alloc actually doing another allocation and changing the size of the memory map we just were told we needed.

>> The get_map label is being placed such that the size doesn't get adjusted anymore, yet it is supposed to deal with an allocation having happened during ExitBootServices(), which could have grown the map.

Whatever memory operations that are performed during the ExitBootServices function should be properly reflected by our call to "GetMemoryMap" the second time through.  If their operations increased the number of descriptors that GetMemoryMap will return, we should encounter the EFI_BUFFER_TOO_SMALL case and reallocate,  If the operations decreased the number of Efi Memory Descriptors, then the current allocation will be okay, it just may contain unused space at the end of the allocated area.

> > What value would you suggest for the retry?
In reality 2 times is probably enough.  However, if you guys feel you want to try it more times like grub is, that should be fine.  You can read the original response up above.

Best Regards,
Zach
-----Original Message-----
From: Matt Fleming [mailto:matt@console-pimps.org] 
Sent: Monday, June 17, 2013 8:31 AM
To: Jan Beulich
Cc: Zachary Bobroff; Matt Fleming; Matthew Garrett; Joey Lee; linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; stable@vger.kernel.org
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure

On Mon, 17 Jun, at 12:02:05PM, Jan Beulich wrote:
> >>> On 17.06.13 at 12:17, Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > What value would you suggest for the retry?
> 
> I'd be considering something like 5...10, but this to some degree 
> depends on what odd kinds of behavior this in fact needs to cover.

I genuinely don't see how picking numbers (seemingly) at random is an improvement over the simple case of "if ExitBootServices() returns an error, you get one more try". Unless you're aware of firmware that requires calling ExitBootServices() multiple times? The grub ChangeLog that Joey linked to is not particularly enlightening.

The scenario that this patch addresses is a very clear one, where the firmware event handlers that respond to the initial ExitBootServices event allocate/free memory, thereby invalidating the memory map cookie we passed to ExitBootServices(), and requiring us to call
ExitBootServices() a second time. 

I'm not saying that retrying once is the only solution that will ever make sense. But certainly until we start seeing reports of problems and understand why firmware might want us to invoke ExitBootServices() multiple times, it seems like the most straight forward option.

--
Matt Fleming, Intel Open Source Technology Center

The information contained in this message may be confidential and proprietary to American Megatrends, Inc.  This communication is intended to be read only by the individual or entity to whom it is addressed or by their designee. If the reader of this message is not the intended recipient, you are on notice that any distribution of this message, in any form, is strictly prohibited.  Please promptly notify the sender by reply e-mail or by telephone at 770-246-8600, and then delete or destroy all copies of the transmission.
