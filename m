Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162540AbaDCIB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:01:26 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:62500 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162421AbaDCIBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140402181354.GB13479@quack.suse.cz>
References: <1396451946-13924-1-git-send-email-nasa4836@gmail.com> <20140402181354.GB13479@quack.suse.cz>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Thu, 3 Apr 2014 16:00:44 +0800
Message-ID: <CAHz2CGWd70k+eSzcdMdAkjwpYZB1BQ8mKT3f2EfpMM2NsFtn-A@mail.gmail.com>
Subject: Re: [PATCH] blkdev: use an efficient way to check merge flags
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, hch@lst.de, viro@zeniv.linux.org.uk, kmo@daterainc.com,
        namjae.jeon@samsung.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 2:13 AM, Jan Kara <jack@suse.cz> wrote:
>   OK, but have you checked the generated code is actually any better? This
> is something I'd expect a compiler might be able to optimize anyway. And the
> original code looks more readable to me.

Hi, Jan,

I've disassemble the code on my x86_64 box
(it's inline though, I just look at its call site),
and found that this patch DOES make it more efficient.

Orig asm snippt                                               with
patch asm snippt
============                                              ================

mov    %edx,%ecx                                          mov    %rdx,%r9
xor    %r8d,%ecx                                             xor    %r8d,%r8d
test   $0x80,%cl                                              and    $0x380,%r9d
jne    14c5 <blk_rq_merge_ok+0x15>                test   $0x380,%ecx
and    $0x3,%ch                                              sete   %r8b
jne    14c5 <blk_rq_merge_ok+0x15>                cmp    %r8,%r9

je     14b5 <blk_rq_merge_ok+0x15>

This saves a branch.

Furthermore,  I found that gcc is smart enough to try to optimize the
code, so if we do
like this, it will generate the most optimal and smallest code :


static inline bool blk_check_merge_flags(unsigned int flags1,
                                        ¦unsigned int flags2)
{
        return ((flags1 ^ flags2) &
                (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME))
                == 0;
}

this gives out  :

mov    %edx,%r8d
xor    %ecx,%r8d
and    $0x380,%r8d
jne    14a5 <blk_rq_merge_ok+0x15>

But yes, it compromises readibility.



Regards,
Jianyu Zhan
