Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3HYUXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 16:23:40 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:33749 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab3HYUXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 16:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130825200605.GC27005@ZenIV.linux.org.uk>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
	<CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
	<20130822201530.GL31117@1wt.eu>
	<CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
	<CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
	<CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
	<CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
	<20130823010726.GP27005@ZenIV.linux.org.uk>
	<20130825033741.GX27005@ZenIV.linux.org.uk>
	<CA+55aFxaKGcpdxKXK_axqyFz_oCvFm1Q=_fJLq8di97x_-cCig@mail.gmail.com>
	<20130825200605.GC27005@ZenIV.linux.org.uk>
Date: Sun, 25 Aug 2013 13:23:37 -0700
X-Google-Sender-Auth: csVT9qtySXRdZ2pghSgR4SGNSEU
Message-ID: <CA+55aFyXq9kry7EtcnXOd_DWDVkDvVRWKLAfLOYHVsdY4RRJ8A@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 1:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Timestamp updates, chmod/chown, xattr mess...

Ok, so that's just too much details.

So I'll just go back to square one, and wonder if we could/should just
make the rule be that in order to be in that LAST_BIND case, you
really have to have f_cred match your own credentials. Or have
CAP_SEARCH.

And just not have any new LOOKUP_xyz flags at all. No special cases,
no different semantics for different ops, just check f_cred. Because
if you had the permissions to do the original open (ie f_cred matches
your current credentials), then that shows that you originally had all
the pathname permissions, and you are still the same person.

And yeah, you may have opened in for reading (so the file is
technically read-only), but obviously we're re-doing all the inode
permission checks anyway, so the only thing /proc/<pid>/fd/<n> really
gave you was the path traversal. So we shouldn't bother with "the file
descriptor is only readable", because that is simply *irrelevant*.

So it means that the case Andi brought up (truncating or
open-for-write a fd that we only had open for reading) would continue
to be allowed, because while it "sounds odd", there is no actual
problem.

And CAP_SEARCH is very much about that path lookup again. So it's
consistent with the notion that "ok, you may do odd things to file
descriptors through /proc, but we check that you cannot avoid the
pathname lookup rules".

And then we do exactly the same to flink(). So then we're all
consistent again. Not the consistency Andy worried about, but that's
the consistency that was was the security worries with flink are all
about. Because the issues with the "use the file descriptor, not the
path to the file descriptor" really are *not* about the endpoint
itself (since we will re-do the permission check for that particular
inode anyway), but about the path leading up to that end-point.

                    Linus
