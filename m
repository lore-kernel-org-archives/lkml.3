Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3KKThZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:37:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47909 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab3KKThW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:37:22 -0500
Message-ID: <528131E7.2060509@zytor.com>
Date: Mon, 11 Nov 2013 11:37:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/kaslr] x86, kaslr: Provide randomness functions
References: <1381450698-28710-4-git-send-email-keescook@chromium.org>	<tip-5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3@git.kernel.org>	<20131111182046.GA14961@gmail.com>	<20131111183101.GA16051@gmail.com> <CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com>
In-Reply-To: <CAGXu5jL96B4+McO=K9dptu81m+bdKWOZ8YS9x7+SZxkjfUsg9Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 11:32 AM, Kees Cook wrote:
>>>
>>> Why aren't the 3 sources of entropy XOR-ed together?
> 
> Ah, excellent suggestion. There's no reason they couldn't be. I can
> rework that function to do that.
> 
>>> Also, we talked about also adding system dependent entropy sources, such
>>> as memory layout or the DMI table - none of that seems to have happened.
> 
> It seemed like those things didn't contribute as much entropy as the 3
> already in use, but I could investigate how to distill those things
> down into entropy. Perhaps just XORing the start and length of every
> e820 area? DMI I'll need to dig into...
> 

DMI and ACPI are relatively straightforward: they are really just blocks
of memory with magic pointers.  Since you don't actually need to parse
them, it is mostly just a matter of finding those blocks of memory and
hashing them.

You could also hash the BDA - the first 0x500 bytes of memory - although
that starts to get into the "what about weird nontraditional platforms"
space.

A *MAJOR* issue with DMI and ACPI is that the way they are located is
firmware dependent: there is a search algorithm defined for BIOS
platforms, whereas on EFI I believe it requires doing runtime calls to
find things.

Of course, perhaps we could just hash struct boot_params as a starting
point?

	-hpa

