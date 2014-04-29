Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaD2EiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:38:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaD2Eh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:37:59 -0400
Message-ID: <535F2C66.9090902@zytor.com>
Date: Mon, 28 Apr 2014 21:36:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Lutomirski <amluto@gmail.com>
CC: comex <comexk@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com> <535EDEC5.7030209@zytor.com> <535EDF67.3090501@linux.intel.com> <CAObL_7HVOjpgp0=Ot9ih2tb6x7xv6MGstu-Krad+rrO4cVqyTg@mail.gmail.com> <CAObL_7FZRji6ivcVvTQ4r=KULCA760fr_wKqkjaYKGL=KLOQRA@mail.gmail.com> <535F108C.9010001@linux.intel.com> <535F205F.9040101@zytor.com>
In-Reply-To: <535F205F.9040101@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 08:45 PM, H. Peter Anvin wrote:
> 
> OK, so I found a bug in ldttest.c -- it sets CS to an LDT segment, but
> it never sets SS to an LDT segment.  This means that it should really
> have zero footprint versus the espfix code, and implies that we instead
> have another bug involved.  Why the espfix code should have any effect
> whatsoever is a mystery, however... if it indeed does?
> 
> I have uploaded a fixed ldttest.c, but it seems we might be chasing more
> than that...
> 

With the test fixed, the bug was easy to find: we can't compare against
__KERNEL_DS in the doublefault handler, because both SS and the image on
the stack have the stack segment set to zero (NULL).

With that both ldttest and run16 pass with the doublefault code, even
with randomization turned back on.

I have pushed out the fix.

There are still things that need fixing: we need to go through the
espfix path even when returning from NMI/MC (which fortunately can't
nest with taking an NMI/MC on the espfix path itself, since in that case
we will have been interrupted while running in the kernel with a kernel
stack.)

(Cc: Rostedt because of the NMI issue.)

	-hpa

