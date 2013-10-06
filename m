Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3JFVeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:34:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3JFVd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:33:59 -0400
Date: Sun, 6 Oct 2013 22:33:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] apparently broken RLIMIT_CORE
Message-ID: <20131006213358.GZ13318@ZenIV.linux.org.uk>
References: <20131006004331.GY13318@ZenIV.linux.org.uk>
 <CA+55aFy8TAeeTA0YVRs8w=MjUC0idvNqB+9BcLWVLPw_LEQajg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy8TAeeTA0YVRs8w=MjUC0idvNqB+9BcLWVLPw_LEQajg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 01:42:05PM -0700, Linus Torvalds wrote:
> On Sat, Oct 5, 2013 at 5:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> >         In other words, the size of notes section is ignored for
> > RLIMIT_CORE purposes.  Is that intentional?
> 
> I doubt it is intentional, but I also cannot really feel that we care
> deeply. Afaik we don't really honor the size limit exactly anyway, ie
> we tend to check only at page boundaries etc. So do we really care?

It's actually easier to put the counter of already written data into
coredump_params and have a new primitive both check that we won't
exceed the limit and update that counter, rather than doing it manually
(and somewhat inconsistently) in load_elf_binary() and the stuff it
calls.  As the matter of fact, after that change we get code looking
so:
        if (!elf_core_write_extra_phdrs(cprm, offset))
                goto end_coredump;

        size = cprm->written;
        /* write out the notes section */
        if (!write_note_info(&info, cprm))
                goto end_coredump;

        if (elf_coredump_extra_notes_write(cprm))
                goto end_coredump;

        /* Align to page */   
        if (!dump_seek(cprm->file, dataoff - cprm->written))
                goto end_coredump;

        cprm->written = size;
        for (vma = first_vma(current, gate_vma); vma != NULL;
                        vma = next_vma(vma, gate_vma)) {
and that's the only remaining reason to have size as local variable at all.
IOW, making the it consistent would mean getting rid of this "save and restore
cprm->written" thing around write_note_info()/elf_coredump_extra_notes_write()
in there...

Objections?

PS: I've ended up modifying aout32 coredump code (after fixing the bitrot in
there), now the problem is how to test it.  I'm grabbing something I hadn't
seen in a _long_ time - i386 Slackware 2.3; that should still contain live
a.out toolchain and as long as it's run under KVM and isolated from network...
