Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaBECfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:35:04 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50695 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaBECfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:35:01 -0500
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
Date: Tue, 4 Feb 2014 18:35:00 -0800
Message-ID: <CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
Subject: Re: [RFCv2 00/10] xhci: re-work command queue management
From: Dan Williams <dan.j.williams@intel.com>
To: David Laight <David.Laight@aculab.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 6:25 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Mathias Nyman
>> Only changes since v1 are fixing smatch warnings and errors.
>>   patch 01/10
>>     Check for null return from alloc_command, release lock in error path and
>>     don't dereference possible null pointer in error path.
>>
>>   patch 04/10
>>     release lock in xhci_stop_dev() error path.
>>
>> This is the second attempt to re-work and solve the issues in xhci command
>> queue management that Sarah has descibed earlier:
>>
>> Right now, the command management in the xHCI driver is rather ad-hock.
>> Different parts of the driver all submit commands, including interrupt
>> handling routines, functions called from the USB core (with or without the
>> bus bandwidth mutex held).
>> Some times they need to wait for the command to complete, and sometimes
>> they just issue the command and don't care about the result of the command.
>>
>> The places that wait on a command all time the command for five seconds,
>> and then attempt to cancel the command.
>> Unfortunately, that means if several commands are issued at once, and one of
>> them times out, all the commands timeout, even though the host hasn't gotten
>> a chance to service them yet.
>>
>> This is apparent with some devices that take a long time to respond to the
>> Set Address command during device enumeration (when the device is plugged in).
>> If a driver for a different device attempts to change alternate interface
>> settings at the same time (causing a Configure Endpoint command to be issued),
>> both commands timeout.
>>
>> Instead of having each command timeout after five seconds, the driver should
>> wait indefinitely in an uninterruptible sleep on the command completion.
>> A global command queue manager should time whatever command is currently
>> running, and cancel that command after five seconds.
>>
>> If the commands were in a list, like TDs currently are, it may be easier to keep
>> track of where the command ring dequeue pointer is, and avoid racing with events.
>> We may need to have parts of the driver that issue commands without waiting on
>> them still put the commands in the command list.
>>
>> The Implementation:
>> -------------------
>>
>> First step is to create a list of the commands submitted to the command queue.
>> To accomplish this each command is required to be submitted with a properly
>> filled command structure containing completion, status variable and a pointer to
>> the command TRB that will be used.
>
> I think it would be much simpler to allocate a parallel array to the actual
> hardware command ring that contains the additional information for the request
> (instead of allocating it pre-request).
> This would immediately solve any problems allocating the memory from interrupt
> context and failing to free in correctly in all the code paths.
>
> A similar solution could be used for the transfer rings thus removing the
> need to the 'td' list - which there are reports of it failing to find transfers
> and the code paths for aborting isoch transfers are badly broken.
>
> Adding another list that will have its own set of bugs seems retrograde top me.

What bugs?  Please be specific.  The problem to be addressed is not
the allocation of commands, but that timeouts of one command eat the
timeout periods of subsequent commands.  I'm thinking a
single-threaded workqueue better models what the hardware is doing.
See my comments in patch 1, but that is orthogonal to how the command
contexts are allocated.
