Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaLMPu4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 10:50:56 -0500
Received: from www.sr71.net ([198.145.64.142]:59702 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaLMPuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 10:50:55 -0500
Message-ID: <548C605D.2040106@sr71.net>
Date: Sat, 13 Dec 2014 07:50:53 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net> <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com> <548B60F4.6020903@sr71.net> <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com> <548B7764.2060608@sr71.net> <CALCETrVEDS9Os5P11ub+FxHsDACgDWnkC4N6yqquQSfUv-=3kw@mail.gmail.com> <548B8716.7000106@sr71.net> <CALCETrXt4yi6GC1f-gRYRYHuOue0-RfCWhQqJL0XK0hdUurDxA@mail.gmail.com>
In-Reply-To: <CALCETrXt4yi6GC1f-gRYRYHuOue0-RfCWhQqJL0XK0hdUurDxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 05:45 PM, Andy Lutomirski wrote:
> I was thinking of this:
> 
> + if (is_64bit_mm(mm)) {
> +       vaddr_space_size = 1ULL << __VIRTUAL_MASK_SHIFT;
> + bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_64;
> + /*
> + * __VIRTUAL_MASK takes the 64-bit addressing hole
> + * in to accout.  This is a noop on 32-bit.
> + */
> + addr &= __VIRTUAL_MASK;
> + return addr / bd_entry_virt_space;
> + } else {
> +       vaddr_space_size = (1ULL << 32);
> + bd_entry_virt_space = vaddr_space_size / MPX_BD_NR_ENTRIES_32;
> + return addr / bd_entry_virt_space;
> + }
> 
> Is there a scenario in which the return value ends up being insanely
> high?  If so, does it matter?

Yes, it will be insanely high for a 32-bit process.  The kernel could go
looking for the bounds directory entry at some bonkers virtual address
that makes no sense on 32-bit.

But, that bonkers address is still treated as coming from userspace.
The kernel will go and dereference it via a get_user(), fault, notice
the bad address and kill the process.
