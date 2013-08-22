Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3HVSsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:48:13 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:55332 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3HVSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:48:11 -0400
MIME-Version: 1.0
In-Reply-To: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
References: <b121a1082bf3365fda22a131782147c169c969f5.1377112282.git.luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:48:10 -0700
X-Google-Sender-Auth: 8vCSMfSqLw9cDIV4zyjnllhcLxc
Message-ID: <CA+55aFzXNU-eJ7KeZyv5YYKKtm8iorG-o3QtD7NXx0GTzuH+Bw@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 12:14 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So let's be careful for now: only allow linkat(..., AT_EMPTY_PATH)
> if the target is I_LINKABLE.

So I really detest this just because it's such a special case. Now
this is only useful for that one special case, and the thing very
fundamentally checks that one special case in a place that is
impossible to check for the /proc case, so the proc case remains
totally separate.

Which just bothers me.

I think we could easily at least allow the "file->f_creds ==
current->creds" case (and yes, I literally mean comparing the pointers
- not only is it cheaper, but it literally means "nothing odd has
happened in between opening and the lookup").

And I'm wondering if we shouldn't actually do that at "path_init"
time. Right now the code says:

                /* Caller must check execute permissions on the
starting path component */
                struct fd f = fdget_raw(dfd);

and then uses the struct file mindlessly.

I'm wondering if we should just do some validation in that place, and say:

 - for directories, we require exec permissions here
 - for everything else, we require that f->f_cred == current->cred check.

I dunno. But that I_LINKABLE thing just bothers me. It screams "I'm
hacky" to me.

               Linus
