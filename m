Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143AbaGXDyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:54:07 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:43265 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934118AbaGXDyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:54:04 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2692:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6119:7652:7903:8660:9108:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12663:12740:13069:13148:13161:13229:1323
X-HE-Tag: love14_5fd0d760e942
X-Filterd-Recvd-Size: 3201
Message-ID: <1406174039.2755.71.camel@joe-AO725>
Subject: Re: [PATCH 9/9] fs: dlm: lockd: Convert int result to unsigned char
 type
From: Joe Perches <joe@perches.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        David Teigland <teigland@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Wed, 23 Jul 2014 20:53:59 -0700
In-Reply-To: <20140723141139.2cf90cb0@tlielax.poochiereds.net>
References: <cover.1405879494.git.joe@perches.com>
	 <65b9ba0dba9c79a938267d5bed7ed0a8211e89ed.1405879494.git.joe@perches.com>
	 <20140723141139.2cf90cb0@tlielax.poochiereds.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 14:11 -0400, Jeff Layton wrote:
> On Sun, 20 Jul 2014 11:23:43 -0700 Joe Perches <joe@perches.com> wrote:
> > op->info.rv is an s32, but it's only used as a u8.
> I don't understand this patch. info.rv is s32 (and I assume that "rv"
> stands for "return value").

In this case it's not a return value but an input.

> What I don't get is why you think it's just
> used as a u8.

Because it's tested only in nlmsvc_grant_deferred
and nlmsvc_update_deferred_block against 0.

As far as I can tell, it's not possible to set it
to a negative value.

> It seems to be used more like a bool than anything else,
> and I'm not sure that "type" is really a good description for it. Maybe
> it should be a "bool" and named "conflict",

Maybe.  But it seemed likely and possible to expand
it from a single bool to a value.

> given the comments in dlm_posix_get ?

Maybe, though I don't see how the comments relate to
this change.  The rv value returned from that call
is either -ENOMEM or 0 and is unchanged by this patch.

> > diff --git a/include/linux/fs.h b/include/linux/fs.h
[]
> > @@ -842,7 +842,7 @@ struct lock_manager_operations {
> >  	int (*lm_compare_owner)(struct file_lock *fl1, struct file_lock *fl2);
> >  	unsigned long (*lm_owner_key)(struct file_lock *fl);
> >  	void (*lm_notify)(struct file_lock *fl);	/* unblock callback */
> > -	int (*lm_grant)(struct file_lock *fl, int result);
> > +	int (*lm_grant)(struct file_lock *fl, unsigned char type);
> >  	void (*lm_break)(struct file_lock *fl);
> >  	int (*lm_change)(struct file_lock **fl, int type);
> >  };

I used variable name "type" because that's what
lm_change uses.  No worries if you think a name
like conflict is better.

The only in-kernel setter of lm_grant is:

fs/lockd/svclock.c:     .lm_grant = nlmsvc_grant_deferred,

and for that, I think using a variable name of
"result" is misleading at best.

