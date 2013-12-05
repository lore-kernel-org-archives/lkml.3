Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab3LERZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:25:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956Ab3LERZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:25:28 -0500
Date: Thu, 5 Dec 2013 18:23:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131205172355.GA25780@redhat.com>
References: <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com> <20131204111125.GA26552@redhat.com> <529F51D9.7010001@zytor.com> <20131204164817.GA5271@redhat.com> <529F5E47.3040108@zytor.com> <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com> <20131204174328.GA8082@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204174328.GA8082@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04, Oleg Nesterov wrote:
>
> And/Or. Are you still saying that on x86 (and powerpc?) we do not need
> these pte games at all and uprobe_write_opcode() can simply do:
>
> 		/* Break the mapping unless the page is already anonymous */
> 		ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
>
> 		// this page can't be swapped out due to page_freeze_refs()
> 		copy_to_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
> 		
> 		set_page_dirty_lock(page);

This is almost off-topic, but I am wondering if (in the long term)
we can avoid this "insert the bp into every mm" altogether.

Instead, uprobe_write_opcode() should only unmap this page and set
SWP_UPROBE_ENTRY. The probed application should install the page
with breakpoints itself on demand during the fault, do_swap_page()
->non_swap_entry() can do this.

This also allows to share the patched page, uprobes should read it
at uprobe_register() time, make a copy, add the breakpoint, and keep
it for do_swap_page().

Perhaps. Not sure this is really possible, and of course this is not
that simple, and the filtering complicates this even more. And we
should ensure that the application itself or ptracer can't write to
this page (or even cow it), but this doesn't look too hard.

Oleg.

