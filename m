Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaDCMps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:45:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaDCMpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:45:46 -0400
Date: Thu, 3 Apr 2014 14:45:42 +0200
From: Jan Kara <jack@suse.cz>
To: Zhan Jianyu <nasa4836@gmail.com>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, hch@lst.de,
        viro@zeniv.linux.org.uk, kmo@daterainc.com, namjae.jeon@samsung.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blkdev: use an efficient way to check merge flags
Message-ID: <20140403124542.GA14107@quack.suse.cz>
References: <1396451946-13924-1-git-send-email-nasa4836@gmail.com>
 <20140402181354.GB13479@quack.suse.cz>
 <CAHz2CGWd70k+eSzcdMdAkjwpYZB1BQ8mKT3f2EfpMM2NsFtn-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHz2CGWd70k+eSzcdMdAkjwpYZB1BQ8mKT3f2EfpMM2NsFtn-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 03-04-14 16:00:44, Zhan Jianyu wrote:
> On Thu, Apr 3, 2014 at 2:13 AM, Jan Kara <jack@suse.cz> wrote:
> >   OK, but have you checked the generated code is actually any better? This
> > is something I'd expect a compiler might be able to optimize anyway. And the
> > original code looks more readable to me.
> 
> Hi, Jan,
> 
> I've disassemble the code on my x86_64 box
> (it's inline though, I just look at its call site),
> and found that this patch DOES make it more efficient.
> 
> Orig asm snippt                                               with
> patch asm snippt
> ============                                              ================
> 
> mov    %edx,%ecx                                          mov    %rdx,%r9
> xor    %r8d,%ecx                                             xor    %r8d,%r8d
> test   $0x80,%cl                                              and    $0x380,%r9d
> jne    14c5 <blk_rq_merge_ok+0x15>                test   $0x380,%ecx
> and    $0x3,%ch                                              sete   %r8b
> jne    14c5 <blk_rq_merge_ok+0x15>                cmp    %r8,%r9
> 
> je     14b5 <blk_rq_merge_ok+0x15>
> 
> This saves a branch.
> 
> Furthermore,  I found that gcc is smart enough to try to optimize the
> code, so if we do
> like this, it will generate the most optimal and smallest code :
> 
> 
> static inline bool blk_check_merge_flags(unsigned int flags1,
>                                         ¦unsigned int flags2)
> {
>         return ((flags1 ^ flags2) &
>                 (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME))
>                 == 0;
> }
> 
> this gives out  :
> 
> mov    %edx,%r8d
> xor    %ecx,%r8d
> and    $0x380,%r8d
> jne    14a5 <blk_rq_merge_ok+0x15>
> 
> But yes, it compromises readibility.
  OK, I'd expect gcc is more clever ;). Thanks for the comparison. Anyway
if that function is performance sensitive, we can use your optimization.
Just add a comment there that we want to check whether the three flags are
the same in both flags and that checking your way generates better code.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
