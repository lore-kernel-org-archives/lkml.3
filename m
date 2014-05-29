Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaE2Wj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:39:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51999 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaE2WjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140529143840.d6fd12bc4e3cfc8d24730b6d@linux-foundation.org>
References: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140529140337.f999bfaaf9ffabce071962ea@linux-foundation.org>
	<20140529212308.GA16353@redhat.com>
	<20140529143840.d6fd12bc4e3cfc8d24730b6d@linux-foundation.org>
Date: Fri, 30 May 2014 00:39:24 +0200
Message-ID: <CAFo99gZm0b8QodT56r+wegY7LM=oWFqLmpE5cnN_MaiBrx1Fqg@mail.gmail.com>
Subject: Re: [PATCH] fs: ocfs2: move_extents.c: Fix to remove null pointer
 checks that could never happen
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Liu <jeff.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

First, I'm no expert on this code, but after a patch which I thought
was most accurate for the current code was written before, which was
rather something like the code below.
Then Jeff Liu that this was not something that could happen. So I send
a patch where the check was removed instead.
And that's where we are now. :-)


@@ -902,11 +902,13 @@ static int ocfs2_move_extents(struct
ocfs2_move_extents_context *context)
        struct inode *inode = context->inode;
        struct ocfs2_dinode *di;
        struct buffer_head *di_bh = NULL;
-       struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+       struct ocfs2_super *osb;

        if (!inode)
                return -ENOENT;

+       osb = OCFS2_SB(inode->i_sb);
+
        if (ocfs2_is_hard_readonly(osb) || ocfs2_is_soft_readonly(osb))



Best regards
Rickard Strandqvist


2014-05-29 23:38 GMT+02:00 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 29 May 2014 17:23:08 -0400 Dave Jones <davej@redhat.com> wrote:
>
>> On Thu, May 29, 2014 at 02:03:37PM -0700, Andrew Morton wrote:
>>  > On Tue, 27 May 2014 22:23:51 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>>  >
>>  > > Removal of null pointer checks that could never happen
>>  >
>>  > How do you know it never happens?
>>  >
>>  > > --- a/fs/ocfs2/move_extents.c
>>  > > +++ b/fs/ocfs2/move_extents.c
>>  > > @@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>>  > >          struct buffer_head *di_bh = NULL;
>>  > >          struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>>  > >
>>  > > -        if (!inode)
>>  > > -                return -ENOENT;
>>  > > -
>>  >
>>  > If it's due to assuming that the previous statement would have oopsed
>>  > then that is mistaken.  Is is sometimes the case that gcc will move the
>>  > evaluation of inode->i_sb to after the test, so this function can be
>>  > passed NULL and it will not oops.
>>
>> 'sometimes' ?
>>
>> You have a lot more faith in gcc than I do. What happens if we decide to
>> switch to llvm one day ? Can we guarantee every compiler will implement
>> the same magic ?  This seems fragile as hell to me.
>>
>
> Well yes.  There are two ways to go here:
>
> a) work out if `inode' can legitimately be NULL.  If so, do
>
>         struct ocfs2_super *osb;
>
>         if (!inode)
>                 return -ENOENT;
>         osb = OCFS2_SB(inode->i_sb);
>
>    or
>
> b) if `inode' cannot legitimately be NULL then Rickard's patch is OK.
>
>
> My point is that we *cannot* assume that `inode' cannot be NULL from
> observed runtime results.  Because of the compiler's behaviour.
>
