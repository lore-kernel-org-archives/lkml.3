Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaK0DNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:13:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50144 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaK0DNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:13:12 -0500
MIME-Version: 1.0
Message-ID: <b4d424e6-81b2-4b21-ab2f-3d403a455f57@default>
Date: Wed, 26 Nov 2014 19:13:02 -0800 (PST)
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: <bp@suse.de>
Cc: <konrad.wilk@oracle.com>, <x86@kernel.org>, <gregkh@linuxfoundation.org>,
        <david.vrabel@citrix.com>, <stable@vger.kernel.org>,
        <rshendershot@mchsi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- bp@suse.de wrote:

> On Wed, Nov 26, 2014 at 07:39:26AM -0500, boris ostrovsky wrote:
> > https://lkml.org/lkml/2014/11/25/973 is all I have right now.
> 
> Ok, so the Code: section from this splat says:
> 
>   25:   55                      push   %ebp
>   26:   89 e5                   mov    %esp,%ebp
>   28:   83 ec 08                sub    $0x8,%esp
>   2b:*  80 3d c0 ee 97 01 00    cmpb   $0x0,0x197eec0           <--
> trapping instruction
>   32:   89 1c 24                mov    %ebx,(%esp)
>   35:   89 74 24 04             mov    %esi,0x4(%esp)
>   39:   74 12                   je     0x4d
>   3b:   8b 1c 24                mov    (%esp),%ebx
>   3e:   8b                      .byte 0x8b
>   3f:   74                      .byte 0x74
> 
> which I can correlate to the dis_ucode_ldr test here:
> 
>         .loc 1 134 0
>         .loc 1 137 0
>         cmpb    $0, dis_ucode_ldr+1073741824    #, *_11
>         je      .L46    #,
> 
> 
> so we must be faulting when accessing that dis_ucode_ldr thing. But
> you
> said that accessing it through its virtual address doesn't fix the
> issue
> either. Which is very very strange...


I was confusing you: accessing dis_ucode_ldr by virtual address does work on PV. But we then fail later, in load_ucode_intel_ap(), because it also tries to use __pa_nodebug() which can't be used by PV.

So if accessing dis_ucode_ldr by virtual address is acceptable (although I don't think it is?) then we can stick dis_ucode_ldr=1 into xen_start_kernel() and then things look OK.

A better solution may be to replace cpuid in x86_guest() with 'return pv_info.paravirt_enabled' (or paravirt_enabled(), I guess). I gave it a quick spin (32-bit only) and it seems to work. I'll see how my overnight tests behave.

-boris

