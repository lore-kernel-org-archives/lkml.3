Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3CVK2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:28:42 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33139 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3CVK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@mail.gmail.com>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
 <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca>
 <1363870366.3312.1.camel@pasglop> <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 22 Mar 2013 10:28:20 +0000
X-Google-Sender-Auth: _4NfZh-E7doKxKMK_brWuhxqVK4
Message-ID: <CACxGe6uCKRH8jcGJW+oYt+T33XT_MGzaxmtkNdekMooGqBYTEw@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 8:07 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Mar 21, 2013 at 12:52 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
>> kexec comes to mind (all 4 variants of fs2dt.c (yuck !)), dtc, various
>> powerpc-utils (bootloader configuration etc...), and more.
>>
>> We also need to test the new code with hotplug, I'll see if I can get
>> somebody at IBM to give it a spin.
>
> Thanks

Actually, this will be broken. I missed adding hooks to the property
add/remove paths. It will be fixed in v3.

BTW, I'd really like to revisit the locking semantics and reference
counting of OF_DYNAMIC. It is incredibly painful it is for driver
authors to get right. What is the device_node lifecycle on pseries? Do
we really need to be doing of_node_get/put() every time we walk the
tree, or is there a different model that can be used?

Bear with me as I think through this out-loud...

How about instead of doing get/put by default every time, we have an
explicit mutex that needs to be grabbed if there is a potential that
the code will be dealing with dynamic nodes. For device drivers this
will almost never be true because the node ref counts will already
have been incremented when the device was created (well before probe
occurs). Plus the ref count won't be decremented again until the point
of struct device removal.

The other scenario is when searching for nodes there is the potential
that any node in the system could disappear mid-search, and in most
cases it won't even be one of the nodes that is being searched for.
For the non-matching nodes that shouldn't be a problem because the
lock is held while traversing past them. No worries about them
dropping out from under us. It's when one of the matching nodes might
disappear that problems could happen.

But for the vast majority of use cases that simply isn't going to
happen. We aren't removing individual nodes from a passed in .dtb (at
least not yet). I'm not going to base design decisions on that, but it
seems like the the current scheme is optimized for the wrong use case.

Would it be reasonable to expect that the caller explicitly grab a
lock to hold off node removal tree wide? Then only increment the
refcount on nodes that are actually cared about?

g.
