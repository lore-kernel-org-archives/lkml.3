Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3EMNrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:47:12 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:65515 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3EMNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:47:10 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Cc: EUNBONG SONG <eunb.song@samsung.com>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs\@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: EXT4 regression caused 4eec7
In-Reply-To: <20130513133036.GB4845@thunk.org>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17> <20130513131809.GG400@quack.suse.cz> <20130513133036.GB4845@thunk.org>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 13 May 2013 17:47:05 +0400
Message-ID: <87bo8fxa92.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 09:30:36 -0400, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, May 13, 2013 at 03:18:09PM +0200, Jan Kara wrote:
> > Grumble. In this case I think bitfields are not worth the trouble with gcc.
> > It's a pitty we have to spend additional 8 bytes for every journal_head but
> > we'll survive... I'll send Ted a partial revert and add a comment so that
> > we won't repeat this mistake in future.
> 
> Or just switch things to use explicit 32-bit boolean operations.
> Sounds the safest way to go is to simply not trust bitfields to be
> something gcc is competent to compile correctly, and just open code it
> in standard C.  (Large portions of ext4 and e2fsprogs do this
> manually, for historical reasons, and it sounds like we have a good
> reason to do it going forward.)
> 
> Jan, Dmitry --- I still have in my tree a revert for commit 4eec708d2:
> ext4: use io_end for multiple bios, since I belive Dmitry still
> bisected a regression for xfstests 299.  Dmitry, can you confirm that
> you are definitely seeing a regression here?
Yes, this patch provoke use-after-free which detected by slab sanity checks.
>  Jan, do you mind if we
> try to figure out how to fix this during the next development cycle,
> since it was part of your much longer, extensive patch series anyway?
> 
> I've determined that the reason why I didn't see a problem was because
> xfstests 299 was failing earlier on the baseline, and crashing my
> regression tests. So I simply commented it out just so I could
> complete the testing.  It seems that xfstests 299 is problematic for
> me, and I need to focus on how to make it pass successfully.  (Dmitry,
> when I revert the commit which you identified, xfstests 299 is *still*
> failing for me....) 
In fact generic/299 always succeed for me, but it produce warning
WARNING: at fs/ext4/inode.c:3218 ext4_ext_direct_IO
and complains from slab debug. But it was missed because i've missed
this error in the logs and forget to check /proc/sys/kernel/tained.
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
