Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbaAOPfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:35:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:36275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaAOPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:35:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,663,1384329600"; 
   d="scan'208";a="459253900"
Message-ID: <52D6ACBC.2090700@linux.intel.com>
Date: Wed, 15 Jan 2014 17:43:56 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 00/10] xhci: re-work command queue management
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com> <063D6719AE5E284EB5DD2968C1650D6D45938C@AcuExch.aculab.com> <52D5281F.4080108@linux.intel.com> <063D6719AE5E284EB5DD2968C1650D6D45B31F@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D45B31F@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 02:37 PM, David Laight wrote:
> From: Mathias Nyman
> ...
>>> The fact that you are having to allocate memory ion an ISR ought also to be
>>> ringing alarm bells.
>>
>> It did.
>> Other options are as you said to use a 'software command ring'. Either
>> just pre-allocate a full command ring (64 trbs * sizeof(struct
>> xhci_command)), roughly 2300 bytes when driver loads,
>> or then a smaller pool of commands just used for ISR submitted commands.
>> (We then need to either either expand pool, or start allocating in isr
>> if pool is empty)
>
> If you pre-allocate mapping 1-1 with the command ring entries
> you don't need many of the fields of xhci_command at all.
> So the allocated size will be much smaller.

True, then the struct list_head could be removed.
Even the trb pointer could be removed if the command ring stays in one 
segment(just use the trb - base as an index )

...

> Looking at the number of fields in xci_command, why do you need the
> caller to pass a structure at all?
> Just make the fields parameters to the 'send a command' function
> along with a parameter that says whether it can sleep (in kmalloc()
> or if the ring is full depending on the implementation).

Command completion events only tell which trb completed and its status. 
The structure is needed to map the trb to the right completion so that 
the  caller can continue running, check status and move on.

The xhci_command fields forISR allocated commands are really not used 
that much. Only status is used if the command timeouts. But we want 
these command structures on the command list to make sure eveything else 
works (timeout works, commands completion events are in the same order 
as commands on our command list etc)

So in a way we're allocating memory in ISR which is not really even used.

I'll try to create something to that avoid that

-Mathias


