Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab3CVAPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:15:17 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40873 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3CVAPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:15:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130322000803.GG21522@ZenIV.linux.org.uk>
References: <20130321202635.GA16406@redhat.com>
	<CA+55aFwyK4uDgSKUpXBGS5zi16qd8STtrGi3kndunYi40dnj+A@mail.gmail.com>
	<20130321203639.GC16406@redhat.com>
	<20130321204704.GZ21522@ZenIV.linux.org.uk>
	<20130321210255.GD16406@redhat.com>
	<CA+55aFxysZEw6fw8+LobMgfzeHuGSSs+hyrUr_frTOjaCGJFLQ@mail.gmail.com>
	<20130321221256.GA30620@redhat.com>
	<CA+55aFx+O13YuJsZyrTS6O9Kws=1ff-knsSv9rV8wTf8yBrPJg@mail.gmail.com>
	<20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<20130322000803.GG21522@ZenIV.linux.org.uk>
Date: Thu, 21 Mar 2013 17:15:12 -0700
X-Google-Sender-Auth: BUqQyJ5FZTO8Ac5gyFfeef1So6k
Message-ID: <CA+55aFwd=oTFEfryRs6FgDDHmcw1TM=YkkiDrcWrz-zuFpB26w@mail.gmail.com>
Subject: Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 5:08 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Not really.  Do that and yes, this deadlock goes away.  But the locking
> order in general goes to hell - we order directory inodes by "which dentry
> is an ancestor of another?"  So we have no warranty that we won't get
> alias1/foo/bar/baz < alias2/foo.  Take rename_lock() on those two and
> have it race with rmdir alias2/foo/bar/baz (locks alias2/foo/bar, then
> alias2/foo/bar/baz) and rmdir alias2/foo/bar (locks alias2/foo and
> alias2/foo/bar).  Oops - we have a cycle now...

Hmm. But again, that can't actually happen here. We're in /proc. You
can't move the entries around. Also, we only changed the locking order
for the "inode is identical" case where we take only *one* lock, we
didn't change it for the cases where we take multiple locks (and order
them topologically).

So I agree that we need to avoid aliased directories in the *general*
case. I'm just arguing that for the specific case of /proc, we should
be ok. No?

             Linus
