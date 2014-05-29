Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbaE2Vin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:38:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377AbaE2Vim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:38:42 -0400
Date: Thu, 29 May 2014 14:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: ocfs2: move_extents.c:  Fix to remove null pointer
 checks that could never happen
Message-Id: <20140529143840.d6fd12bc4e3cfc8d24730b6d@linux-foundation.org>
In-Reply-To: <20140529212308.GA16353@redhat.com>
References: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140529140337.f999bfaaf9ffabce071962ea@linux-foundation.org>
	<20140529212308.GA16353@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014 17:23:08 -0400 Dave Jones <davej@redhat.com> wrote:

> On Thu, May 29, 2014 at 02:03:37PM -0700, Andrew Morton wrote:
>  > On Tue, 27 May 2014 22:23:51 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>  > 
>  > > Removal of null pointer checks that could never happen
>  > 
>  > How do you know it never happens?
>  > 
>  > > --- a/fs/ocfs2/move_extents.c
>  > > +++ b/fs/ocfs2/move_extents.c
>  > > @@ -904,9 +904,6 @@ static int ocfs2_move_extents(struct ocfs2_move_extents_context *context)
>  > >  	struct buffer_head *di_bh = NULL;
>  > >  	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
>  > >  
>  > > -	if (!inode)
>  > > -		return -ENOENT;
>  > > -
>  > 
>  > If it's due to assuming that the previous statement would have oopsed
>  > then that is mistaken.  Is is sometimes the case that gcc will move the
>  > evaluation of inode->i_sb to after the test, so this function can be
>  > passed NULL and it will not oops.
> 
> 'sometimes' ?
> 
> You have a lot more faith in gcc than I do. What happens if we decide to
> switch to llvm one day ? Can we guarantee every compiler will implement
> the same magic ?  This seems fragile as hell to me.
> 

Well yes.  There are two ways to go here:

a) work out if `inode' can legitimately be NULL.  If so, do

	struct ocfs2_super *osb;

	if (!inode)
		return -ENOENT;
	osb = OCFS2_SB(inode->i_sb);

   or

b) if `inode' cannot legitimately be NULL then Rickard's patch is OK.


My point is that we *cannot* assume that `inode' cannot be NULL from
observed runtime results.  Because of the compiler's behaviour.

