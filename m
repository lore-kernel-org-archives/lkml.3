Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaLHShy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:37:54 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:42202 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaLHShw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:37:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141208182012.GE22149@ZenIV.linux.org.uk>
References: <20141204202011.GO29748@ZenIV.linux.org.uk>
	<20141208164650.GB29028@node.dhcp.inet.fi>
	<20141208175805.GB22149@ZenIV.linux.org.uk>
	<20141208180824.GC22149@ZenIV.linux.org.uk>
	<CA+55aFxwrH4vsyw2ix=HqDK9Z=fw98xtOL8=57prm8qgVmAFfA@mail.gmail.com>
	<20141208182012.GE22149@ZenIV.linux.org.uk>
Date: Mon, 8 Dec 2014 10:37:51 -0800
X-Google-Sender-Auth: qmdLsByH0TetpN6qwkzuJa4LW0s
Message-ID: <CA+55aFxrrTV-xBbvEzVKsXRVKyvZhQZj-6BNDpTsG4J5k6CJEg@mail.gmail.com>
Subject: Re: [RFC][PATCHES] iov_iter.c rewrite
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 10:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I certainly had missed that insanity during the analysis - we don't do
> a lot of O_DIRECT IO to/from kernel addresses of any sort...  This
> codepath allows it ;-/  Ability to trigger it is equivalent to ability
> to run any code in kernel mode, so it's not an additional security hole,
> but...

Is there any chance we could just return EINVAL for this case?

Who does O_DIRECT on module load anyway? If this is only for
finit_module(), that uses "kernel_read()", and maybe we could just
make sure that the kernel_read() function never ever uses the
direct-IO paths?

[ Time passes, I look at the code ]

Oh crap. So the reason it triggers seems to be that we basically get a
random file descriptor that we didn't open, and then we have

  vfs_read() ->
  xfs_file_operations->read() ->
  ew_sync_read() ->
  xfs_file_operations->read_iter()
  xfs_file_read_iter()

and we are stuck with this iterator that really just wants to do copies.

How about we make "kernel_read()" just clear O_DIRECT? Does that fix
it to just use copies?

                      Linus
