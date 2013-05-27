Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3E0PUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3E0PUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:20:42 -0400
Date: Mon, 27 May 2013 17:16:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] coredump: kill call_count, add core_name_size
Message-ID: <20130527151630.GA30933@redhat.com>
References: <20130515201158.GA14606@redhat.com> <20130515201232.GA14648@redhat.com> <20130524125323.861541a12992c3da0145f0d9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524125323.861541a12992c3da0145f0d9@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24, Andrew Morton wrote:
>
> On Wed, 15 May 2013 22:12:32 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Imho, "atomic_t call_count" is ugly and should die. It buys
> > nothing and in fact it can grow more than necessary, expand
> > doesn't check if it was already incremented by another task.
> >
> > Kill it, and introduce "static int core_name_size" updated by
> > expand_corename(). This is obviously racy too but harmless,
> > and core_name_size never grows for no reason.
> >
> > We do not bother to to calculate the "right" new size, we
> > simply do kmalloc(size_we_need) and use ksize() to rely on
> > kmalloc_index's decision.
> >
> > Finally change format_corename() to use expand_corename(),
> > krealloc(NULL) is fine.
>
> The code still looks like a bunch of fluff.  I look at it and think
> "wtf, why doesn't it just use kasprintf()".

But how?

kasprintf() can't replace cn_printf(), and it can't make it simpler.

If it was possible to create va_list dinamically then format_corename()
could construct "char *fmt" and call kvasprintf() once.

Or we can change this code to avoid *printk* altogether, we only need
a very limited subset of "enum format_type". Not sure this makes sense.

> If there were any comments in there at all which explained the reason
> for the code's existence, perhaps I wouldn't think that.  But there
> aren't, so I do.

If you meant "why do we need expand_corename" I can't answer because
I do not know ;) I mean, if CORENAME_MAX_SIZE == 128 is not enough we
can probably just increase it and simplify the code.

Please see 1b0d300b "core_pattern: fix truncation by core_pattern handler
with long parameters" which introduced this.

And yes, we can keep "expand" but simply kill "atomic_t call_count"
(replaced by core_name_size in this patch), I do not think it buys
too much. But at least with this patch this logic becomes really
trivial.


Andrew, it seems that you missed the last patch in this series,
attached below. I sent it a bit later as 7/6 because I didn't notice
this problem when I started these changes.

Oleg.

-------------------------------------------------------------------------------
[PATCH 7/6] coredump: avoid the uninitialized cn->corename if core_pattern is empty

If core_pattern is "" or "|", cn->corename is used uninitialized
by filp_open() or call_usermodehelper_exec().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 5968064..72f816d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -165,6 +165,7 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 	cn->corename = NULL;
 	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
+	cn->corename[0] = '\0';
 
 	if (ispipe)
 		++pat_ptr;
-- 
1.5.5.1


