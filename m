Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaHMMoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:44:16 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:38735 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaHMMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:44:15 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
Date: Wed, 13 Aug 2014 14:44:14 +0200
Message-ID: <CAJfpegts+jjLDqOYnK7SmcWnbmuwYBfgt4CXHWhVdxNjz1vA1g@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously (v2)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 3:27 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
> Hi,
>
> There is a long-standing demand for synchronous behaviour of fuse_release:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=19343889
> http://sourceforge.net/mailarchive/message.php?msg_id=29814693
>
> A year ago Avati and me explained why such a feature would be useful:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=29889055
> http://sourceforge.net/mailarchive/message.php?msg_id=29867423
>
> In short, the problem is that fuse_release (that's called on last user
> close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
> ACK from userspace. Consequently, there is a gap when user regards the
> file released while userspace fuse is still working on it. An attempt to
> access the file from another node leads to complicated synchronization
> problems because the first node still "holds" the file.

Tying RELEASE to close(2) is not going to work.  Look at all the
places that call fput() (or fdput() in recent kernels), those are all
potential triggers for RELEASE, some realistic, some not quite, but
all are certainly places that a synchronous release could block
*instead* of close.

Which just means, that close will still be asynchronous with release
some of the time.  So it's not clear to me what is to be gained from
this patchset.

Thanks,
Miklos
