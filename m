Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbbANONt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:13:49 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34672 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbbANONr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:13:47 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Calvin Owens <calvinowens@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Organization: D03
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
X-Hashcash: 1:20:150114:pfeiner@google.com::uS6SXc3Hz6jJ+CG3:00000000000000000000000000000000000000000000QXS
X-Hashcash: 1:20:150114:kirill.shutemov@linux.intel.com::aO63R2TbYdfFB68T:0000000000000000000000000000000znV
X-Hashcash: 1:20:150114:adobriyan@gmail.com::uZPqbSDyYdxVj82z:00000000000000000000000000000000000000000020dy
X-Hashcash: 1:20:150114:kernel-team@fb.com::1hnMAguf5jMYqES7:00000000000000000000000000000000000000000002Pxs
X-Hashcash: 1:20:150114:grant.likely@secretlab.ca::VDT+tJsdYbWZV/Gv:0000000000000000000000000000000000002jW+
X-Hashcash: 1:20:150114:calvinowens@fb.com::JfbbReQUoPrfzuL9:000000000000000000000000000000000000000000047Cv
X-Hashcash: 1:20:150114:akpm@linux-foundation.org::0dWJ/95azceSmFqY:0000000000000000000000000000000000004/4I
X-Hashcash: 1:20:150114:siddhesh.poyarekar@gmail.com::96xlgVhFuHfza2Rd:0000000000000000000000000000000005DZH
X-Hashcash: 1:20:150114:linux-kernel@vger.kernel.org::u/GK51n4HYos89wP:0000000000000000000000000000000005Wej
X-Hashcash: 1:20:150114:viro@zeniv.linux.org.uk::Bu+rVh2dMEMEiDio:000000000000000000000000000000000000007JYA
X-Hashcash: 1:20:150114:ebiederm@xmission.com::7qp5kCMVtBKgVJaP:0000000000000000000000000000000000000000CPZF
X-Hashcash: 1:20:150114:oleg@redhat.com::xBcuAjCHN1r5w9xG:00DOFl
Date: Wed, 14 Jan 2015 15:13:44 +0100
In-Reply-To: <1421194829-28696-1-git-send-email-calvinowens@fb.com> (Calvin
	Owens's message of "Tue, 13 Jan 2015 16:20:29 -0800")
Message-ID: <87oaq1v49z.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2015, Calvin Owens <calvinowens@fb.com> wrote:

> Commit b76437579d1344b6 ("procfs: mark thread stack correctly in
> proc/<pid>/maps") introduced logic to mark thread stacks with the
> "[stack:%d]" marker in /proc/<pid>/maps.
>
> This causes reading /proc/<pid>/maps to take O(N^2) time, where N is
> the number of threads sharing an address space, since each line of
> output requires iterating over the VMA list looking for ranges that
> correspond to the stack pointer in any task's register set. When
> dealing with highly-threaded Java applications, reading this file can
> take hours and trigger softlockup dumps.
>
> Eliminating the "[stack:%d]" marker is not a viable option since it's
> been there for some time, and I don't see a way to do the stack check
> more efficiently that wouldn't end up making the whole thing really
> ugly.

Just thinking out loud: Could one simply mark a VMA as being used for
stack during the clone call (is there room in vm_flags, or does
VM_GROWSDOWN already tell the whole story?), and then write the TID into
a new field in the VMA - I think one could make a union with vm_pgoff so
as not to enlarge the structure.

This would allow eliminating the loop over tasks in vm_is_stack.

Rasmus
