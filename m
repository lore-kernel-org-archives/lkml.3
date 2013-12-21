Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3LUAlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:41:45 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:33599 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3LUAlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:41:44 -0500
MIME-Version: 1.0
Date: Fri, 20 Dec 2013 16:41:43 -0800
X-Google-Sender-Auth: rE21YtMAYCzyLVYLaLyvResYBIw
Message-ID: <CA+55aFzYZEmNEHQVgWS6usVnDVi-8ar7ZzP+eUGrqoO2OP66kA@mail.gmail.com>
Subject: Broken initrd compression settings in 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So commit 1bf49dd4be0b ("./Makefile: export initial ramdisk
compression config option") seems to be totally broken.

And I'm not saying that because Jan fixed a make-3.80 incompatibility
in commit 7ac181568342 ("fix build with make 3.80")

I'm saying that because it sets and exports the INITRD_COMPRESS
environment variable completely incorrectly, as far as I can tell.

And it looks like nobody noticed, because apparently dracut didn't use
to care about that INITRD_COMPRESS environment variable at all. But as
of a F20 update yesterday, apparently dracut actually does care, and
as a result nothing actually works.

That setting is f*cking moronic. It sets INITRD_COMPRESS to 'lz4' if
RD_LZ4 is set. But RD_LZ4 is *always* set (unless you go into some
expert settings), so basically what that commit does is to always set
INITRD_COMPRESS to lz4.

Why is that wrong?

It's wrong because

 (a) most sane people don't even have lz4 _installed_, so dracut won't
actually succeed

 (b) there's no way to select the compression level (unlike the
INITRAMFS_COMPRESSION thing that actually has a choice)

 (c) even if you *do* have lz4, it doesn't actually work, because
while that causes the new F20 dracut to compress the initramfs with
lz4, the end result is completely broken, because the F20 "lsinitrd"
scripts don't understand the end result, so now the whole kernel
install fails.

Now, it could be argued that this is a F20 bug, and the fact that F20
has a dracut that can generate a lz4 initrd, but has other tools that
then cannot handle it is arguably indeed a buglet in F20. So the (c)
part is arguably a F20 problem.

HOWEVER.

(a) and (b) are very much kernel bugs.

I'm going to remove that export of INITRD_COMPRESS, since right now
that value is broken and useless. No way does it make sense to
mindlessly default to a compressor that most people don't have, and
that doesn't work with most tools.

             Linus
