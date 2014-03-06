Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaCFPEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:04:13 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53779 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaCFPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:03:58 -0500
Message-ID: <53188E50.70808@gmail.com>
Date: Thu, 06 Mar 2014 16:03:44 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
References: <53022DB1.4070805@gmail.com>	<CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com> <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
In-Reply-To: <CA+55aFy4GvpFcboBiKdreU_Zh1RzynPoLxhvC9hijn60hkEZ3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 06:36 PM, Linus Torvalds wrote:
> Ok, sorry for the long delay, I was distracted (and hoping that Al
> would come up with a patch).
> 
> Anyway, attached is the patch I think we should do for this issue. It
> is fairly simple:
> 
>  - it adds a "f_pos_mutex" to the "struct file".
> 
>  - it adds a new FMODE_ATOMIC_POS flag to the file mode flags to mark
> things that need atomic f_pos updates
> 
>  - it makes the "struct fd" flags be two flags rather than one: the
> second flag is for "unlock f_pos_mutex when done"
> 
>  - it introduces "fd[get,put]_pos()" which gets the f_pos_mutex when required
> 
>  - it makes read/write/lseek use that.
> 
> It's pretty damn straightforward, I think, and is minimally serializing.
> 
> Al, comments? Yongzhi Pan, this is pretty much untested, but it's
> pretty simple and it does fix your test-case.

The original code (where Yongzhi Pan reported an issue) and
the multi_writer.c test code where both mine actually. Anyway,
I applied the patch to 3.14-rc5, and I (not withstanding the other
points raised by Al about the patch) I confirm that this patch makes 
the  problem that I'm seeing go away.

Thanks for looking at this, Linus.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
