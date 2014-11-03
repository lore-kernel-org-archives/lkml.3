Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaKCTEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:04:30 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:42982 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKCTE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
	<20141031084220.GA29085@infradead.org>
	<CALCETrXdPV5+qJ438Ky=tfBiEmqeeTYNuukQS7TcjbEwDgzwGQ@mail.gmail.com>
	<CA+55aFxUdjsm0gC0ULaOq_RhDLjWp=RDOE_O9qXdQRPqJUrZVA@mail.gmail.com>
	<20141103083447.GA8617@infradead.org>
	<CALCETrUjbfSiPUvTzTfOVAbxy5dy3PpKnnC+h4P_+FOeibTgDw@mail.gmail.com>
	<CAH_=xobsXZq9M-vXDN_+cQmvRLtgPOzHMbrnzsEToMgLD5CoxA@mail.gmail.com>
Date: Mon, 3 Nov 2014 11:04:27 -0800
X-Google-Sender-Auth: 5T8ZaoggkKDj-FcmF0qUbmBqTwE
Message-ID: <CA+55aFw29MUj+w46yneut2yxXOH1RQmDud5KL8V-SPyPWm1WqA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Rannaud <e@nanocritical.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 10:49 AM, Eric Rannaud <e@nanocritical.com> wrote:
>
> Isn't it because they are essentially emulating an atomic open()
> capable of creating a file with inherited ACLs, according to
> relatively complex rules? open *can* be used with O_CREAT|O_RDONLY
> (touch(1) might do that), which would naively translate into:

Oh, so you don't actually need any file contents at all?

If that is actually a real usage, then maybe we should just say that
"O_TMPFILE|O_RDONLY" is fine, and remove the check that it has to be
writable.

That check was always a sanity-check, because people felt that a
temp-file you can't write to is an insane concept. But if there is a
real use case for it, then clearly it's not completely insane. Just
odd.

It's just that single

                if (!(acc_mode & MAY_WRITE))
                        return -EINVAL;

test in build_open_flags(), right?

I'd take a tested patch to remove that (where "tested" means: "yes, I
actually did that unwritable file descriptor thing, and it actually
solved the problem and worked for samba or whatever")

                     Linus
