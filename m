Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbANOxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:53:21 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:59423 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbANOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:53:19 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Organization: D03
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<87oaq1v49z.fsf@rasmusvillemoes.dk>
	<CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
X-Hashcash: 1:20:150114:ebiederm@xmission.com::ksTSdl/+Bgf/3DWL:000000000000000000000000000000000000000005zt
X-Hashcash: 1:20:150114:siddhesh.poyarekar@gmail.com::spSu4M/iTnc2XnBw:0000000000000000000000000000000000c7P
X-Hashcash: 1:20:150114:pfeiner@google.com::QK4Umvk8a3XPuo7w:00000000000000000000000000000000000000000001NmO
X-Hashcash: 1:20:150114:linux-kernel@vger.kernel.org::suQcgRC/C9SdUZIC:0000000000000000000000000000000001O97
X-Hashcash: 1:20:150114:grant.likely@secretlab.ca::p6miFdfu4zTKn46Y:0000000000000000000000000000000000001ml4
X-Hashcash: 1:20:150114:kirill.shutemov@linux.intel.com::I0WNSICvtXCUtqEf:00000000000000000000000000000027Rw
X-Hashcash: 1:20:150114:adobriyan@gmail.com::wb2fxftMFysNEaKd:0000000000000000000000000000000000000000002Gq4
X-Hashcash: 1:20:150114:kernel-team@fb.com::BdvqE6eodP1zY70T:00000000000000000000000000000000000000000002GRT
X-Hashcash: 1:20:150114:akpm@linux-foundation.org::XnqKIDYYwqYNjAub:00000000000000000000000000000000000047pP
X-Hashcash: 1:20:150114:calvinowens@fb.com::why+nENl3XUYEp2G:00000000000000000000000000000000000000000004x7H
X-Hashcash: 1:20:150114:viro@zeniv.linux.org.uk::W6EoCz2menlQ6HgE:000000000000000000000000000000000000005Nx5
X-Hashcash: 1:20:150114:oleg@redhat.com::48FdyTxbPJXEys1g:006sWg
Date: Wed, 14 Jan 2015 15:53:16 +0100
In-Reply-To: <CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
	(Siddhesh Poyarekar's message of "Wed, 14 Jan 2015 20:07:06 +0530")
Message-ID: <87fvbdv2g3.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14 2015, Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com> wrote:

> On 14 January 2015 at 19:43, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>> Just thinking out loud: Could one simply mark a VMA as being used for
>> stack during the clone call (is there room in vm_flags, or does
>> VM_GROWSDOWN already tell the whole story?), and then write the TID into
>> a new field in the VMA - I think one could make a union with vm_pgoff so
>> as not to enlarge the structure.
>
> vm_flags does not have space IIRC (that was my first approach at
> implementing this) and VM_GROWSDOWN is not sufficient.

Looking at include/linux/mm.h:

#define VM_GROWSDOWN    0x00000100      /* general info on the segment */
#define VM_PFNMAP       0x00000400      /* Page-ranges managed without "struct page", just pure PFN */
#define VM_DENYWRITE    0x00000800      /* ETXTBSY on write attempts.. */

It would seem that 0x00000200 is available (unless defined and used
somewhere else).

> If we can make a union with vm_pgoff like you say, we probably don't
> need a flag value; a non-zero value could indicate that it is a thread
> stack.

Well, only when combined with checking vm_file for being NULL. One would
also need to ensure that vm_pgoff is 0 for any non-stack,
non-file-backed VMA. At which point it is somewhat ugly. 

> One problem with caching the value on clone like this though is that
> the stack could change due to a setcontext, but AFAICT we don't care
> about that for the process stack either.

If it is important, I guess one could update the info when a task calls
setcontext.

Rasmus
