Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaGOQAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:00:43 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41406 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaGOQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <53C54DDC.8060302@zytor.com>
References: <195642a5e9fd4515ad8ca4cd8bcffd4900df5790.1405437568.git.luto@amacapital.net>
 <20140715153801.GX3403@laptop.dumpdata.com> <53C54DDC.8060302@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Jul 2014 09:00:19 -0700
Message-ID: <CALCETrXucLLf8RH_yocV3jpsKPMaqmP3gM2os=kEQ=wjwT0S6Q@mail.gmail.com>
Subject: Re: [PATCH] x86_64,xen,espfix: Initialize espfix on secondary CPUs
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:50 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/15/2014 08:38 AM, Konrad Rzeszutek Wilk wrote:
>>
>> I think just disallowing would be preferrable.
>>
>
> So I have yet to hear anyone talk about what the Xen PV IRET does for
> 16-bit stack segments.  Can we get the answer for that, please?
>

If I'm reading the right thing, it does:

 59 .Lforce_iret:
60         /* Mimic SYSRET behavior. */
61         movq  8(%rsp),%rcx            # RIP
62         movq  24(%rsp),%r11           # RFLAGS
63         ALIGN
64 /* No special register assumptions. */
65 iret_exit_to_guest:
66         addq  $8,%rsp
67 .Lft0:  iretq

while running on Xen's stack.  IOW, it leaks bits 31:16 of the Xen
stack, and there's nothing the guest can do about it short of using a
user-mode trampoline or disabling 16-bit stack segments entirely.

See:

http://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=xen/arch/x86/x86_64/entry.S;h=a3ed216b390c2e87a21ff377850ee34ee7f2bc74;hb=HEAD

and (search for do_iret):

http://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=xen/arch/x86/traps.c;h=677074b4e628ed99d407b1045d859355e590d604;hb=HEAD

>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
