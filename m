Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3H3D1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:27:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45601 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3H3D1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:27:50 -0400
Message-ID: <522010E4.7080709@zytor.com>
Date: Thu, 29 Aug 2013 20:26:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Alan Stern <stern@rowland.harvard.edu>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        arnd.bergmann@linaro.org, olof@lixom.net, benh@kernel.crashing.org
Subject: Re: Memory synchronization vs. interrupt handlers
References: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org> <521E5D58.5070708@zytor.com> <20130829235136.GX3871@linux.vnet.ibm.com>
In-Reply-To: <20130829235136.GX3871@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 04:51 PM, Paul E. McKenney wrote:
> On Wed, Aug 28, 2013 at 01:28:08PM -0700, H. Peter Anvin wrote:
>> On 08/28/2013 12:16 PM, Alan Stern wrote:
>>> Russell, Peter, and Ingo:
>>>
>>> Can you folks enlighten us regarding this issue for some common 
>>> architectures?
>>
>> On x86, IRET is a serializing instruction; it guarantees hard
>> serialization of absolutely everything.
> 
> So a second interrupt from this same device could not appear to happen
> before the IRET, no matter what device and/or I/O bus?  Or is IRET
> defined to synchronize all the way out to the whatever device is
> generating the next interrupt?

The second interrupt from this same device can occur as soon as the EOI
cycle is done, which happens before the IRET.  The EOI cycle is an I/O
operation and since integer operations to memory are strongly ordered
that implies all other effects are globally visible.

In addition, there is usually synchronization that happens due to
reading an interrupt status register or something else.

>> I would expect architectures that have weak memory ordering to put
>> appropriate barriers in the IRQ entry/exit code.
> 
> Adding a few on CC.  Also restating the question as I understand it:
> 
> 	Suppose that a given device generates an interrupt on CPU 0,
> 	but that before CPU 0's interrupt handler completes, this device
> 	wants to generate a second interrupt on CPU 1.  This can happen
> 	as soon as CPU 0's handler does an EOI or equivalent.
> 
> 	Can CPU 1's interrupt handler assume that all the in-memory effects
> 	of CPU 0's interrupt handler will be visible, even if neither
> 	interrupt handler uses locking or memory barriers?
> 

On x86 it certainly can.

	-hpa


