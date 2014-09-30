Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaI3Wa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:30:26 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:48035 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaI3WaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:30:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410010019290.4455@nanos>
References: <cover.1412105369.git.luto@amacapital.net> <alpine.DEB.2.11.1410010019290.4455@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Sep 2014 15:30:02 -0700
Message-ID: <CALCETrVnjyEbwKzmhCTWNyj-tKWgEp34St+CAUs-dZZQZ4iCNQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] x86_64,entry: Clear NT on entry and speed up switch_to
To: Thomas Gleixner <tglx@linutronix.de>
Cc: X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 3:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 30 Sep 2014, Andy Lutomirski wrote:
>> Anish Bhatt noticed that user programs can set RFLAGS.NT before
>> syscall or sysenter, and the kernel entry code doesn't filter out
>> NT.  This causes kernel C code and, depending on thread flags, the
>> exit slow path to run with NT set.
>>
>> The former is a little bit scary (imagine calling into EFI with NT
>> set), and the latter will fail with #GP and send a spurious SIGSEGV.
>>
>> One answer would be "don't do that".  But the kernel can do better
>> here.
>>
>> These patches, which I'm not completely thrilled by, filter NT on
>> all kernel entries.  For syscall (both bitnesses), this is free.
>> For sysenter, it costs 15 cycles or so.  As a consolation prize, we
>> can speed up context switches by avoiding saving and restoring flags.
>
> That's a nice reason not to do any of the other ugly variants.

We could do something hideous:

Don't filter NT in sysexit or on context switch.  Instead, handle it
in bad_iret.

Up side: all common cases are maximally fast.

Down side: Ugly.  And malicious processes can leak NT, causing return
to a different process to fault, thereby adding a thousand or two
cycles (or possibly a lot more if the fault hits in the middle of
espfix64.  Egads.)

This is not intended to be a serious suggestion...

--Andy
