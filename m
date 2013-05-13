Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3EMMH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:07:57 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57404 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3EMMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:07:56 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Zheng Liu <gnehzuil.liu@gmail.com>, EUNBONG SONG <eunb.song@samsung.com>
Cc: Tony Luck <tony.luck@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
In-Reply-To: <20130513112633.GA3168@gmail.com>
References: <12945098.35291368438804981.JavaMail.weblogic@epv6ml07> <20130513112633.GA3168@gmail.com>
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 13 May 2013 16:07:50 +0400
Message-ID: <87fvxrxeuh.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013 19:26:34 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> On Mon, May 13, 2013 at 09:53:25AM +0000, EUNBONG SONG wrote:
> > 
> > 
> > > Hi all,
> > 
> > > First of all I couldn't reproduce this regression in my sand box.  So
> > > the following speculation is only my guess.  I suspect that the commit
> > > (ae4647fb) isn't root cause.  It just uncover a potential bug that has
> > > been there for a long time.  I look at the code, and found two
> > > suspicious stuff in jbd2.  The first one is in do_get_write_access().
> > > In this function we forgot to lock bh state when we check b_jlist ==
> > > BJ_Shadow.  I generate a patch to fix it, and I really think it is the
> > > root cause.  Further, in __journal_remove_journal_head() we check
> > > b_jlist == BJ_None.  But, when this function is called, bh state won't
> > > be locked sometimes.  So I suspect this is why we hit a BUG in
> > > jbd2_journal_put_journal_head().  But I don't have a good solution to
> > > fix this until now because I don't know whether we need to lock bh state
> > > here, or maybe we should remove this assertation.
> > >
> > > So, generally, Tony, Eunbong, could you please try the following patch?
> > >
> > > Thanks in advance,
> > >                                                 - Zheng
> > 
> > 
> > Hi, I tested your patch. Unfortunately, the same problem was reproduced.
> > Thanks.
> 
> Thanks for trying this patch.  Could you please repost the dmesg log for
> me?  I want to make sure whether the second suspicious stuff causes this
> regression or not.  Further, that would be great if you could try to
> comment this line as the following?
AFAIK  following assertion was triggered jh->b_transaction != NULL
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 886ec2f..a9e3779 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2453,7 +2453,7 @@ static void __journal_remove_journal_head(struct
> buffer_head *bh)
>         J_ASSERT_JH(jh, jh->b_transaction == NULL);
>         J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
>         J_ASSERT_JH(jh, jh->b_cp_transaction == NULL);
> -       J_ASSERT_JH(jh, jh->b_jlist == BJ_None);
> +       /*J_ASSERT_JH(jh, jh->b_jlist == BJ_None);*/
>         J_ASSERT_BH(bh, buffer_jbd(bh));
>         J_ASSERT_BH(bh, jh2bh(jh) == bh);
>         BUFFER_TRACE(bh, "remove journal_head");
> 
> Really thanks,
>                                                 - Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
