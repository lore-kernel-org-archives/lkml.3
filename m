Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaLIH42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:56:28 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:34472 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaLIH40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:56:26 -0500
Date: Tue, 9 Dec 2014 15:56:19 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>,
        Marek =?iso-8859-1?Q?Kord=EDk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clear bridge MEM_64 flag if one child does not
 support it
Message-ID: <20141209075619.GA23327@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1418075552-26495-1-git-send-email-yinghai@kernel.org>
 <1418079372.13358.9.camel@kernel.crashing.org>
 <CAE9FiQX-vMu5+Kr09ngr95WvtoZTUSL5R2+NiVFeiN6q-BXLLg@mail.gmail.com>
 <20141209001119.GA24661@shangw>
 <20141209022601.GA16207@richard>
 <CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWz=vdR=QSkoEs5XjUxg_y4vJgnChQAc1-U_9xzfQpknQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120907-0033-0000-0000-000000B274FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 11:20:59PM -0800, Yinghai Lu wrote:
>On Mon, Dec 8, 2014 at 6:26 PM, Wei Yang <weiyang@linux.vnet.ibm.com> wrote:
>> On Tue, Dec 09, 2014 at 11:11:19AM +1100, Gavin Shan wrote:
>>>
>>>I'm going to give it a spin and Richard, could you please apply Yinghai's
>>>patch to see if your SRIOV code can work properly?
>>>
>>
>> I did a quick test on my machine. This patch doesn't affect the MMIO
>> allocation on out platform, so SRIOV works fine.
>>
>> I will spend more time to read the patch to get more understanding about the
>> problem.
>
>Hi Marek,
>
>Can you boot following branch with "debug ignore_loglevel pci=realloc"
>on your setup?
>
>git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>for-pci-allocate-fit-3.18
>
>it has
>8f74af9: PCI, x86: Allocate mmio near end of free range
>1ff91c1: PCI: Don't allocate small resource in big free space.
>108b43b: resources: Add allocate_resource_fit()
>b6a22f0: resources: Make find_resource could return just fit resource
>cf50e16: resources: Split out __allocate_resource()
>
>on top the v3.18, and it will allocate resource in fit way.

Hi, Yinghai

Just spent some time to understand the problem and your patch.

Two comments to this patch:
1. realloc_head is not necessary here
2. In case we have two MEM BAR under a bus, one is MEM64|PREF and one is PREF,
after this patch, the MEM64 flag will be cleared, right? If so, this may fall
back to the same situation in bug 74151.

I am looking at the bugzilla and try to understand the root cause for this
allocation failure. Currently I don't get the reason. In my mind, the resource
will be sized in the non-pref bridge window. But seems not. I have asked more
info in the bugzilla, so that I could understand the problem. (Yeah, maybe I
am not that smart, if one of you would help me understand the problem, I am
happy to offer you a cup of coffee :-) )

Bjorin,

As you mentioned in another thread, "5b28541552ef is taking the wrong
approach". (http://www.spinics.net/lists/linux-pci/msg37374.html) Maybe I
don't catch it clearly. Put a 32bit prefetchable resource in a 32bit
non-prefetchable bridge window is a bad idea? But in my mind, if the bridge
prefetchable window is 64bit, we can't put a 32bit prefetchable resource in
it.

I am trying to catch up with the updates of the bug, if I missed something
just let me know.

>
>Thanks
>
>Yinghai

-- 
Richard Yang
Help you, Help me

