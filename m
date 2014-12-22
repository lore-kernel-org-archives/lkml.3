Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaLVUNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:13:46 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64678 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbaLVUNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:13:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1412222101530.1680@pobox.suse.cz>
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es> <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es> <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
 <20141222183615.4193722q3opf4uj3@webmail.upv.es> <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
 <alpine.LNX.2.00.1412222047090.1680@pobox.suse.cz> <CALCETrU0BjPJjG8ohm6-KA-wR+DGjmoFOd4MkNqEQRtXxz6iqw@mail.gmail.com>
 <alpine.LNX.2.00.1412222101530.1680@pobox.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 12:13:22 -0800
Message-ID: <CALCETrWGaB-ftJC+6yZtCfmAq50bx5JnxorLDTNyhkGWNN-8yQ@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
To: Jiri Kosina <jkosina@suse.cz>
Cc: Hector Marco Gisbert <hecmargi@upv.es>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:03 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 22 Dec 2014, Andy Lutomirski wrote:
>
>> It could be worth having a mode that goes all out: randomize every
>> single allocation independently in, say, a 45 or 46-byte range.  That
>> would be about as strong ASLR as we could possibly have, it would
>> result in guard intervals around mmap data allocations (which has real
>> value), and it would still leave plenty of space for big address space
>> hogs like the Chromium sandbox.
>>
>> The main downside would be lots of memory used for page tables.
>
> Plus get_random_int() during every mmap() call.

If that's actually a problem, then I think we should fix
get_random_int.  Chacha20 can generate 64 bits in a few cycles.

> Plus the resulting VA
> space fragmentation.

I think the main cost of fragmentation would be the page tables and
vmas.  2^45 bytes is a lot of bytes.

We could tone it down a bit if we dedicated a range to mmapped data
and tried to pack it reasonably densely.  We could even do a fair
amount of merging for data-heavy applications if we gave MAP_PRIVATE |
MAP_ANONYMOUS, PROT_READ | PROT_WRITE mappings a decent chance of
ending up next to each other.

Anyway, this would be a knob.  The database people would presumably turn it off.

--Andy
