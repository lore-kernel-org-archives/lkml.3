Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaKCStu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:49:50 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:52661 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKCStq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:49:46 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
 <5452B241.5010603@amacapital.net> <CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
 <CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
 <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
 <20141031084220.GA29085@infradead.org> <CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
 <CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
 <20141103083447.GA8617@infradead.org> <CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
From: Eric Rannaud <e@nanocritical.com>
Date: Mon, 3 Nov 2014 10:49:24 -0800
Message-ID: <CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
To: Andy Lutomirski <luto@amacapital.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 9:06 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> That doesn't help because we explicitly reject O_RDONLY when combined
>> with O_TMPFILE.
>
> I think I'm missing something.  How is an O_RDONLY temporary file
> useful?  Wouldn't you want an O_RDWR tempfile with mode 0400 or
> something like that?

Isn't it because they are essentially emulating an atomic open()
capable of creating a file with inherited ACLs, according to
relatively complex rules? open *can* be used with O_CREAT|O_RDONLY
(touch(1) might do that), which would naively translate into:

        fd = open(dir, O_TMPFILE|O_RDONLY, 0600)
        fsetxattr(fd, "...")
        fsetxattr(fd, "...")
        linkat(AT_FDCWD, "/proc/self/fd/...", ..., AT_SYMLINK_FOLLOW)
        return fd;

Now this would be happening on the server, and the only reason why it
would be important to ensure that fd is O_RDONLY, is that smbd does
not do its own bookkeeping of how each file handle was opened, and
would rather have the kernel enforce O_RDONLY?

With O_TMPFILE as implemented now, smbd would have to do open(dir,
O_TMPFILE|O_RDWR, 0600), but internally keep track that O_RDONLY was
requested by the client on that fd, and block any writes to fd itself.
