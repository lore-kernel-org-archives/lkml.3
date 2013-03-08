Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab3CHAVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:21:16 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57715 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872Ab3CHAVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130307223610.GA2494@redhat.com>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
	<20130307213819.GB19543@redhat.com>
	<CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
	<20130307220333.GA31039@redhat.com>
	<20130307223610.GA2494@redhat.com>
Date: Thu, 7 Mar 2013 16:21:13 -0800
X-Google-Sender-Auth: -SycsNo9jTdi7R0RZf72hisQni0
Message-ID: <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
Subject: Re: pipe_release oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 2:36 PM, Dave Jones <davej@redhat.com> wrote:
>
> The hits keep on coming..
>
> [  255.609172] BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
> [  255.610393] IP: [<ffffffff811bad62>] pipe_release+0x42/0xd0

Ok, I think this is the same issue as your fasync thing.

So add a "if (pipe) { }" in pipe_release() too.

It's a bit odd, becuse we always allocate an inode->i_pipe whenever we
associate the file with any of the pipe operations, so I don't see how
that NULL i_pipe happens. But we do have that "free_pipe_info() if
there are no readers or writers" logic and I bet that's what triggers
this somehow. I just don't see what the exact sequence is.

                    Linus
