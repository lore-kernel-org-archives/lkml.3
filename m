Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822Ab3CVSDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 14:03:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41636 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422633Ab3CVSDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 14:03:42 -0400
Message-ID: <514C9CF1.7060505@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 13:03:29 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca> <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca> <1363870366.3312.1.camel@pasglop> <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@mail.gmail.com> <CACxGe6uCKRH8jcGJW+oYt+T33XT_MGzaxmtkNdekMooGqBYTEw@mail.gmail.com>
In-Reply-To: <CACxGe6uCKRH8jcGJW+oYt+T33XT_MGzaxmtkNdekMooGqBYTEw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032218-5806-0000-0000-000020725419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2013 05:28 AM, Grant Likely wrote:
> On Thu, Mar 21, 2013 at 8:07 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Thu, Mar 21, 2013 at 12:52 PM, Benjamin Herrenschmidt
>> <benh@kernel.crashing.org> wrote:
>>> On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
>>> kexec comes to mind (all 4 variants of fs2dt.c (yuck !)), dtc, various
>>> powerpc-utils (bootloader configuration etc...), and more.
>>>
>>> We also need to test the new code with hotplug, I'll see if I can get
>>> somebody at IBM to give it a spin.
>>
>> Thanks
> 
> Actually, this will be broken. I missed adding hooks to the property
> add/remove paths. It will be fixed in v3.
> 
> BTW, I'd really like to revisit the locking semantics and reference
> counting of OF_DYNAMIC. It is incredibly painful it is for driver
> authors to get right. What is the device_node lifecycle on pseries? Do
> we really need to be doing of_node_get/put() every time we walk the
> tree, or is there a different model that can be used?
> 

With respect to nodes for memory, cpu's, and PCI devices the lifecycle
can be completely dynamic. All of these are capable of being moved
between partitions on a pseries system and thus they can be added/removed
from the device tree at any point.

Almost any property of the device tree can be update at partition migration
or suspension (this is HMC/pHyp initiated, not Linux suspension). We don't
have reference counts on properties though so that doesn't matter here, but
more on that later...

> Bear with me as I think through this out-loud...
> 
> How about instead of doing get/put by default every time, we have an
> explicit mutex that needs to be grabbed if there is a potential that
> the code will be dealing with dynamic nodes. For device drivers this
> will almost never be true because the node ref counts will already
> have been incremented when the device was created (well before probe
> occurs). Plus the ref count won't be decremented again until the point
> of struct device removal.
> 
> The other scenario is when searching for nodes there is the potential
> that any node in the system could disappear mid-search, and in most
> cases it won't even be one of the nodes that is being searched for.
> For the non-matching nodes that shouldn't be a problem because the
> lock is held while traversing past them. No worries about them
> dropping out from under us. It's when one of the matching nodes might
> disappear that problems could happen.
> 
> But for the vast majority of use cases that simply isn't going to
> happen. We aren't removing individual nodes from a passed in .dtb (at
> least not yet). I'm not going to base design decisions on that, but it
> seems like the the current scheme is optimized for the wrong use case.
> 
> Would it be reasonable to expect that the caller explicitly grab a
> lock to hold off node removal tree wide? Then only increment the
> refcount on nodes that are actually cared about?
>

I don't any issues with moving to a scheme like this but I would ask that
this perhaps be part of a different patch set. I started looking at
all the device tree manipulation we do in pseries and would appreciate
more time go through all the code and test once you had a patch ready.

Since we're talking about reference counts and I mentioned reference counts
for properties earlier...

We don't ever free old property values, mainly I assume since we don't keep
reference counts and can't know when it is safe to do so. The problem I
am starting to see on pseries is that we are getting very large properties.
One of the biggest culprits is the property on pseries systems to describe
the memory on the system in the device tree. These are big and getting
bigger as memory increases, additionally this property is update every
time memory is DLPAR added or removed from the system which can lead to
leaving a bunch of memory that should be free'ed.

Given that, is there (or has there been) any discussion on adding reference
counts to properties in the device tree? With the myriad ways to get at
the value of a property this may not be feasible but I would like to hear
any thoughts from the community.

-Nathan
 

