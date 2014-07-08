Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaGHEtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:49:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:49:33 -0400
Date: Mon, 7 Jul 2014 21:48:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonsoo Kim <js1304@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=EC=9D=B4=EA=B1=B4=ED=98=B8?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>
Subject: Re: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
Message-Id: <20140707214846.0224d697.akpm@linux-foundation.org>
In-Reply-To: <53BB7714.2020102@lge.com>
References: <53B664E5.5060102@lge.com>
	<20140707155252.15e81dff6683393ba3590478@linux-foundation.org>
	<53BB7714.2020102@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 13:44:04 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> 2014-07-08 ______ 7:52, Andrew Morton ___ ___:
> > On Fri, 04 Jul 2014 17:25:09 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
> >
> >> From: Gioh Kim <gioh.kim@lge.com>
> >> Date: Fri, 4 Jul 2014 16:53:22 +0900
> >> Subject: [PATCH] [RFC] CMA: clear buffer-head lru before page migration
> >>
> >> When CMA try to migrate page, some buffer-heads can exist on lru.
> >> The bh on lru has non-zero count value so that it cannot be dropped
> >> even-if it is not used. We can drop only buffers related to the
> >> migrated page, but it can take long time more than dropping all
> >> because of searching list. There all buffers in lru are dropped.
> >>
> >> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> >> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> >> ---
> >>   fs/buffer.c |   13 +++++++++++++
> >>   1 file changed, 13 insertions(+)
> >>
> >> diff --git a/fs/buffer.c b/fs/buffer.c
> >> index eba6e4f..4f11b7a 100644
> >> --- a/fs/buffer.c
> >> +++ b/fs/buffer.c
> >> @@ -3233,6 +3233,19 @@ int try_to_free_buffers(struct page *page)
> >>          if (PageWriteback(page))
> >>                  return 0;
> >>
> >> +#ifdef CONFIG_CMA
> >> +       /*
> >> +        * When CMA try to migrate page, some buffer-heads can exist on lru.
> >> +        * The bh on lru has non-zero count value so that it cannot
> >> +        * be dropped even-if it is not used.
> >> +        * We can drop only buffers related to the migrated page,
> >> +        * but it can take long time more than dropping all
> >> +        * because of searching list.
> >> +        * There all buffers in lru are dropped first.
> >> +        */
> >> +       invalidate_bh_lrus();
> >> +#endif
> >
> > No, this will be tremendously expensive.
> >
> > What I proposed is that CMA call invalidate_bh_lrus() right at the
> > outset.  Something along the lines of

Please do not top-post your email replies - it makes it very hard to
conduct a coherent discussion.

> It's my fault.
> I'm going to send another patch ASAP.

No, not "ASAP".  Such a patch will require careful testing on numerous
system configurations and workloads.  Take however much time it needs
to get it right.

