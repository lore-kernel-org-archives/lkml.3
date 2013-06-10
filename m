Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab3FJLHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab3FJLHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:07:20 -0400
Subject: Re: [PATCH] GFS2: minor readability improvement in gfs2_mount()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
In-Reply-To: <51B1828E.6060301@ispras.ru>
References: <1370467772-4587-1-git-send-email-khoroshilov@ispras.ru>
	 <1370510682.2744.5.camel@menhir>  <51B1828E.6060301@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 10 Jun 2013 12:04:44 +0100
Message-ID: <1370862284.2715.36.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2013-06-07 at 10:49 +0400, Alexey Khoroshilov wrote:
> Hi Steve,
> 
> On 06/06/2013 01:24 PM, Steven Whitehouse wrote:
> > Hi,
> >
> > On Thu, 2013-06-06 at 01:29 +0400, Alexey Khoroshilov wrote:
> >> The patch makes usage pattern of IS_ERR-PTR_ERR more typical.
> >>
> >> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> >> ---
> >>  fs/gfs2/ops_fstype.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> >> index 0262c19..0d30e8e 100644
> >> --- a/fs/gfs2/ops_fstype.c
> >> +++ b/fs/gfs2/ops_fstype.c
> >> @@ -1313,9 +1313,10 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
> >>  	}
> >>  	s = sget(fs_type, test_gfs2_super, set_gfs2_super, flags, bdev);
> >>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> >> -	error = PTR_ERR(s);
> >> -	if (IS_ERR(s))
> >> +	if (IS_ERR(s)) {
> >> +		error = PTR_ERR(s);
> >>  		goto error_bdev;
> >> +	}
> > I'm not sure what you are getting at here. Why add a jump into the fast
> > path?
> My experiments with gcc 4.7.3 on x86-64 do not show any difference in
> code generated with patch and without it.
>     227a:    e8 00 00 00 00           callq  227f <gfs2_mount+0xb1>
>             227b: R_X86_64_PC32    sget-0x4
>     227f:    4c 89 f7                 mov    %r14,%rdi
>     2282:    49 89 c4                 mov    %rax,%r12
>     2285:    e8 00 00 00 00           callq  228a <gfs2_mount+0xbc>
>             2286: R_X86_64_PC32    mutex_unlock-0x4
>     228a:    49 81 fc 00 f0 ff ff     cmp    $0xfffffffffffff000,%r12
>     2291:    0f 87 2a 01 00 00        ja     23c1 <gfs2_mount+0x1f3>
>     2297:    49 83 7c 24 60 00        cmpq   $0x0,0x60(%r12)
>     229d:    74 0b                    je     22aa <gfs2_mount+0xdc>
>     229f:    44 89 ee                 mov    %r13d,%esi
>     22a2:    48 89 df                 mov    %rbx,%rdi
>     22a5:    e8 00 00 00 00           callq  22aa <gfs2_mount+0xdc>
>             22a6: R_X86_64_PC32    blkdev_put-0x4
> 
> It looks like 'error = PTR_ERR(s);' assignment is just ignored because s and error share the same register %r12.
> 
> So the only point of the patch is to improve readability.
> 
Hmm, ok. I'm still not convinced that it does really improve readability
in this case I'm afraid, so I'm not going to apply this one,

Steve.

> --
> Best regards,
> Alexey


