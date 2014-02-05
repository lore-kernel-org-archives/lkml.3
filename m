Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaBEQsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:48:30 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56770 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaBEQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:48:29 -0500
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6B8B7E@AcuExch.aculab.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B532A@AcuExch.aculab.com>
	<CAPcyv4gWnaK+s5zSu58Kue2ZiTTr4YC6pJG0n_Tu2Cm4RXOR=A@mail.gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F6B8B7E@AcuExch.aculab.com>
Date: Wed, 5 Feb 2014 08:48:25 -0800
Message-ID: <CAPcyv4gerLT1uuUre9L4minu6u4HYRFSYD2s-bo_7H9UH64QYQ@mail.gmail.com>
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

On Wed, Feb 5, 2014 at 1:22 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Dan Williams
>> > Adding another list that will have its own set of bugs seems retrograde top me.
>>
>> What bugs?  Please be specific.  The problem to be addressed is not
>> the allocation of commands, but that timeouts of one command eat the
>> timeout periods of subsequent commands.  I'm thinking a
>> single-threaded workqueue better models what the hardware is doing.
>> See my comments in patch 1, but that is orthogonal to how the command
>> contexts are allocated.
>
> No software is bug free.
> The best way to get reasonably bug-free software is the KISS principle
> (Keep It Simple Stupid).

I find this condescending.

Perhaps you did not mean for it to come out that way, but this is far
from a specific technical argument.

> You just seem to be adding a lot of additional complexity.
> Maybe it would look better if more of the code was factored out of the
> call sites.
>
> IIRC at the moment every call site has to:
> 1) find the trb address that will be used (massive layer break).
> 2) actually write the trb (through several layers of function call).
> 3) sort out any timeout (I didn't really look into this bit).
> 4) ring the bell.

I think there is room to push these pre-requisites down.

> ISTM that the call site should just be a single function call.
> If you do that the implementation of the timeouts/completions is
> removed from the callers.

Yes, but I think we need to centralize the context under which
commands are submitted.  The complicating factor is the mix of
synchronous command submission and interrupt driven asynchronous
command queuing.  I think we can simplify it by making it all
submitted from a single event queue context.  I'm investigating if
that is a workable solution...
