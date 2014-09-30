Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaI3VlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:41:00 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:63316 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaI3VjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:20 -0400
Message-ID: <542B2305.9060805@fds-team.de>
Date: Tue, 30 Sep 2014 23:39:17 +0200
From: Sebastian Lackner <sebastian@fds-team.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412105369.git.luto@amacapital.net> <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net>
In-Reply-To: <c4b7904ef2ddd3dec27400d18bcd00badb4dcedf.1412105369.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.2014 21:40, Andy Lutomirski wrote:
> what would happen.  Apparently Wine sometimes does this (!), and, if
> an IRET return happens, Wine will segfault.
> 
> I think that Wine should be fixed to stop setting NT when a syscall
> happens, but handling NT more gracefully is still nice.
> 

Just to give some more background about this issue: Wine has no influence
if the NT flag is set or not - as Wine doesn't trace each individual opcode,
there is no chance to know, if a Windows program messes up the EFLAGS. This
happens in closed source Windows applications, so its not really Wines fault.

I think the current approach should be fine, but if other people prefer one of
the solutions without additional overhead on syscall entry:

At least for Wine it would also be absolutely fine, when the application would
just get a proper signal (if adding the retry IRET is too complicated). I've
attached the url to an additional example program, which shows that currently
the signal handler is unable to process such a fault, and a proof-of-concept
patch to clear the NT flags at least for the signal handler. Such a patch
doesn't fix the potential issues with EFI though.

Example program:
http://ix.io/ezl

Proof-of-concept patch:
http://ix.io/ezm

Regards,
Sebastian

