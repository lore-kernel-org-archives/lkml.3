Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517AbaGOCqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 22:46:40 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:35912 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaGOCqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 22:46:37 -0400
MIME-Version: 1.0
In-Reply-To: <53C45857.6050605@zytor.com>
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
 <53C40D83.3090501@zytor.com> <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com>
 <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com>
 <CALCETrU9dmM+bsQYwULjiqw5+erKsu5yUmHJDGYUW1wpcdp-5Q@mail.gmail.com>
 <CALCETrWG-dQL8ipJ8cO3wfbYKA=mAv3CS4-1JFwmBXF3pUbAwg@mail.gmail.com> <53C45857.6050605@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 19:46:16 -0700
Message-ID: <CALCETrUrAZsoPttFhAd384OJ27ixwC_NCYFMWuMzyDqoKBmTmQ@mail.gmail.com>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 3:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/14/2014 02:35 PM, Andy Lutomirski wrote:
>> Presumably the problem is here:
>>
>> ENTRY(xen_iret)
>>     pushq $0
>> 1:    jmp hypercall_iret
>> ENDPATCH(xen_iret)
>>
>> This seems rather unlikely to work on the espfix stack.
>>
>> Maybe espfix64 should be disabled when running on Xen and Xen should
>> implement its own espfix64 in the hypervisor.
>
> Perhaps the first question is: is espfix even necessary on Xen?  How
> does the Xen PV IRET handle returning to a 16-bit stack segment?
>

Test case here:

https://gitorious.org/linux-test-utils/linux-clock-tests/source/dbfe196a0f6efedc119deb1cdbb0139dbdf609ee:

It's sigreturn_32 and sigreturn_64.  Summary:

(sigreturn_64 always fails unless my SS patch is applied.  results
below for sigreturn_64 assume the patch is applied.  This is on KVM
(-cpu host) on Sandy Bridge.)

On Xen with espfix, both OOPS intermittently.

On espfix-less kernels (Xen and non-Xen), 16-bit CS w/ 16-bit SS
always fails.  Native (32-bit or 64-bit, according to the binary) CS
with 16-bit SS fails for sigreturn_32, but passes for sigreturn_64.  I
find this somewhat odd.  Native ss always passes.

So I think that Xen makes no difference here, aside from the bug.

That being said, I don't know whether Linux can do espfix64 at all
when Xen is running -- for all I know, the IRET hypercall switches
stacks to a Xen stack.

--Andy
