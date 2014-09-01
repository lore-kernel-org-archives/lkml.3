Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbaIAQqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:46:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65389 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbaIAQqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:46:46 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5404A2F2.3090908@roeck-us.net>
Date: Mon, 01 Sep 2014 09:46:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: Tree for Aug 23
References: <20140823080422.7895575c@canb.auug.org.au> <20140825045741.GA29723@roeck-us.net> <20140901155804.GT27892@worktop.ger.corp.intel.com>
In-Reply-To: <20140901155804.GT27892@worktop.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 08:58 AM, Peter Zijlstra wrote:
> On Sun, Aug 24, 2014 at 09:57:41PM -0700, Guenter Roeck wrote:
>> On Sat, Aug 23, 2014 at 08:04:22AM +1000, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20140822:
>>>
>>> The mfd tree gained a build failure so I used the version from
>>> next-20140822.
>>>
>>> The usb-gadget tree gained a conflict against the usb-gadget-fixes tree.
>>>
>>> The pwm tree gained a build failure for which I reverted a couple of
>>> commits.
>>>
>>> The staging tree still had its build failure for which I applied a
>>> fix patch.
>>>
>>> Non-merge commits (relative to Linus' tree): 1435
>>>   1372 files changed, 34371 insertions(+), 25442 deletions(-)
>>>
>>
>> Images build from this tree crash in mips, mips64, and sparc64 qemu tests
>> with memory allocation errors. For mips, bisect points to commit ef31563e950c
>> (locking,arch,mips: Fold atomic_ops).
>>
>> # bad: [eeed658b5a92d957aab7bdb7c469a90016420c7d] Add linux-next specific files for 20140823
>> # good: [7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9] Linux 3.17-rc1
>> git bisect start 'HEAD' 'v3.17-rc1'
>> # good: [a364ac83d553cd223cf1b898a738594f866242ac] Merge remote-tracking branch 'input/next'
>> git bisect good a364ac83d553cd223cf1b898a738594f866242ac
>> # bad: [6804e0868ce1f5f55a16270de65587e35b80231e] Merge remote-tracking branch 'usb-gadget/next'
>> git bisect bad 6804e0868ce1f5f55a16270de65587e35b80231e
>> # bad: [8590e100eca66f5763b4c8a5775e38e4a0c9939d] Merge branch 'x86/xsave'
>> git bisect bad 8590e100eca66f5763b4c8a5775e38e4a0c9939d
>> # good: [e71e79457b79a52827039d9d7f253321bfd342bd] perf symbols: Don't demangle parameters and such by default
>> git bisect good e71e79457b79a52827039d9d7f253321bfd342bd
>> # bad: [100b1cb29333c8ac37e68025b291e4b273c8ad43] Merge branch 'locking/core'
>> git bisect bad 100b1cb29333c8ac37e68025b291e4b273c8ad43
>> # bad: [c6470150dff9aff682063890c9b8eac71b695def] locking,arch,sh: Fold atomic_ops
>> git bisect bad c6470150dff9aff682063890c9b8eac71b695def
>> # good: [50f853e38b0b90a5703ab14b70e20eb5a8ccd5de] locking,arch,hexagon: Fold atomic_ops
>> git bisect good 50f853e38b0b90a5703ab14b70e20eb5a8ccd5de
>> # good: [d6dfe2509da935a15583cace7cd3837b1e8addef] locking,arch,metag: Fold atomic_ops
>> git bisect good d6dfe2509da935a15583cace7cd3837b1e8addef
>> # bad: [e69a0ef76627005e3e83d0e086e6bb1d247bb65b] locking,arch,mn10300: Fold atomic_ops
>> git bisect bad e69a0ef76627005e3e83d0e086e6bb1d247bb65b
>> # bad: [ef31563e950c60bb41b97c2b61c32de874f3c949] locking,arch,mips: Fold atomic_ops
>> git bisect bad ef31563e950c60bb41b97c2b61c32de874f3c949
>> # first bad commit: [ef31563e950c60bb41b97c2b61c32de874f3c949] locking,arch,mips: Fold atomic_ops
>>
>> Reverting the first bad commit fixes the problem for mips and mips64.
>>
>> For sparc64, given the above, I did not bother to bisect, but just reverted
>> commit 4f3316c (locking,arch,sparc: Fold atomic_ops). This fixes the problem
>> for sparc64.
>
> Urgh, I take it this is still current? Would you perhaps have these qemu
> images available so I can try and fix this?
>
>
Yes, the problem is still seen in next-140829. See qemu test results at
http://server.roeck-us.net:8010/builders.

I provided sparc64 images at http://server.roeck-us.net/qemu/sparc64/.
The README file includes instructions on how to run the image in qemu
and how to build a kernel.

I can do the same for mips and mips64 if needed; let me know.

Thanks,
Guenter

