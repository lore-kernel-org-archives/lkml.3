Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaEWQlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:41:08 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:43212 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaEWQlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <537EB60E.40204@1h.com>
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
 <537EB60E.40204@1h.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 23 May 2014 09:40:44 -0700
Message-ID: <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com>
Subject: Re: Pondering per-process vsyscall disablement
To: Marian Marinov <mm@1h.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 7:44 PM, Marian Marinov <mm@1h.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 05/23/2014 02:04 AM, Andy Lutomirski wrote:
>> It would be nice to have a way for new programs to declare that they don't need vsyscalls.  What's the right way to
>> do this?  An ELF header entry in the loader?  An ELF header entry in the program?  A new arch_prctl?
>>
>> As background, there's an old part of the x86_64 ABI that allows programs to do gettimeofday, clock_gettime, and
>> getcpu by calling to fixed addresses of the form 0xffffffffff600n00 where n indicates which of those three syscalls
>> is being invoked.  This is a security issue.
>>
>> Since Linux 3.1, vsyscalls are emulated using NX and page faults.  As a result, vsyscalls no longer offer any
>> performance advantage over normal syscalls; in fact, they're much slower.  As far as I know, nothing newer than
>> 2012 will attempt to use vsyscalls if a vdso is present.  (Sadly, a lot of things will still fall back to the
>> vsyscall page if there is no vdso, but that shouldn't matter, since there is always a vdso.)
>>
>> Despite the emulation, they could still be used as a weird form of ROP gadget that lives at a fixed address.  I'd
>> like to offer a way for new runtimes to indicate that they don't use vsyscalls so that the kernel can selectively
>> disable emulation and remove the fixed-address executable code issue.
>>
>>
> Wouldn't it be more useful if the check is against a bitmask added as extended attribute for that executable?
> This way the administrators and will have the flexibility to simply add the new attribute to the executable.

I don't think this should be something configured by the
administrator, unless the administrator is the builder of a kiosky
thing like Chromium OS.  In that case, the administrator can use
vsyscall=none.

I think this should be handled by either libc or the toolchain, hence
the suggestions of a syscall or an ELF header.

--Andy
