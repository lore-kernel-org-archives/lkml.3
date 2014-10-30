Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbaJ3A5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:57:43 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:51178 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbaJ3A5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1414629045.git.luto@amacapital.net>
References: <cover.1414629045.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 17:57:19 -0700
Message-ID: <CALCETrWfRMyMkReQmtbmK75jyAKDCGn7tWeqh2UBsuSKFAA+sQ@mail.gmail.com>
Subject: Re: [RFC 0/6] mm, x86: New special mapping ops
To: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, X86 ML <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 5:42 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This is an attempt to make the core special mapping infrastructure
> track what arch vdso code needs better than it currently does.  It
> adds:
>
> .start_addr_set: A callback to notify arch code that a special mapping
> was mremapped.  (CRIU does this.  Without something like this, it's
> somewhat broken for 64-bit userspace and completely broken for 32-bit
> userspace on Intel hardware.  Apparently no one has noticed the 64-bit
> breakage, and no one ever ported CRIU to 32-bit in the first place.)
>
> .fault: Directly fault handling on the vdso.  Imagine that!  It turns
> out that storing a list of struct page pointers in the special mapping
> data is awkward for pretty much everyone and completely precludes
> mapping things that aren't pages without dirty hacks.  (x86 uses dirty
> hacks for the HPET mapping.  See below.)

I should add that there's further motivation for this.  I want to change the x86
vdso code so that the HPET is only mapped if it's actually in use.  Getting
this right is delicate, but it's almost impossible without this change.

In particular, if the HPET gets selected due to TSC instability after
boot, then there's no good way to start allowing access right now.
I'd have to remap_pfn_range on all mms at (egads!) an unknown address,
whereas now I can just start accepting the reference in .fault.
Getting the other direction right is tricky, but it's doable in a
number of ways.

--Andy
