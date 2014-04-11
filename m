Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaDKVQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:16:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60090 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaDKVQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:16:42 -0400
Message-ID: <53485BB8.1000106@mit.edu>
Date: Fri, 11 Apr 2014 14:16:40 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com>
In-Reply-To: <53483487.6030103@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:29 AM, H. Peter Anvin wrote:
> On 04/11/2014 11:27 AM, Brian Gerst wrote:
>> Is this bug really still present in modern CPUs?  This change breaks
>> running 16-bit apps in Wine.  I have a few really old games I like to
>> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.
> 
> It is not a bug, per se, but an architectural definition issue, and it
> is present in all x86 processors from all vendors.
> 
> Yes, it does break running 16-bit apps in Wine, although Wine could be
> modified to put 16-bit apps in a container.  However, this is at best a
> marginal use case.

I wonder if there's an easy-ish good-enough fix:

Allocate some percpu space in the fixmap.  (OK, this is ugly, but
kvmclock already does it, so it's possible.)  To return to 16-bit
userspace, make sure interrupts are off, copy the whole iret descriptor
to the current cpu's fixmap space, change rsp to point to that space,
and then do the iret.

This won't restore the correct value to the high bits of [er]sp, but it
will at least stop leaking anything interesting to userspace.

--Andy
