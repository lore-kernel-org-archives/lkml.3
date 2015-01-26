Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbbAZUom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:44:42 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60992 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbbAZUoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:44:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
Date: Mon, 26 Jan 2015 12:44:33 -0800
X-Google-Sender-Auth: 5lusolZXpEWdTIWDTJFGKwzfc1E
Message-ID: <CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Junio C Hamano <gitster@pobox.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 8:32 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>
> I went to do the Fedora 3.19-rc6 build this morning and it failed in
> our buildsystem with:
>
> + '[' '!' -f /builddir/build/SOURCES/patch-3.19-rc6.xz ']'
> + case "$patch" in
> + unxz
> + patch -p1 -F1 -s
> symbolic link target '../../../../../include/dt-bindings' is invalid
> error: Bad exit status from /var/tmp/rpm-tmp.mWE3ZL (%prep)

Ugh. I don't see anything we can do about this on the git side, and I
do kind of understand why 'patch' would be worried about '..' files.
In a perfect world, patch would parse the filename and see that it
stays within the directory structure of the project, but that is a
rather harder thing to do than just say "no dot-dot files".

The short-term fix is likely to just use "git apply" instead of "patch".

The long-term fix? I dunno. I don't see us not using symlinks, and a
quick check says that every *single* symlink we have in the kernel
source tree is one that points to a different directory using ".."
format. And while I could imagine that "patch" ends up counting the
dot-dot entries and checking that it's all inside the same tree it is
patching, I could also easily see patch *not* doing that. So using
"git apply" _might_ end up being the long-term fix too.

I suspect that if "patch" cannot apply even old-style kernel patches
due to the symlinks we have in the tree, and people end up having to
use "git apply" for them, I might end up starting to just use
rename-patches (ie using "git diff -M") for the kernel.

I've considered that for a while already, because "patch" _does_ kind
of understand them these days, although I think it gets the
cross-rename case wrong because it fundamentally works on a
file-by-file basis. But if "patch" just ends up not working at all,
the argument for trying to maintain backwards compatibility gets
really weak.

                                   Linus
