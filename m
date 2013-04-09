Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041Ab3DIGqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:46:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40863 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3DIGqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:46:03 -0400
MIME-Version: 1.0
In-Reply-To: <51636BFC.6040607@gmail.com>
References: <51636BFC.6040607@gmail.com>
Date: Tue, 9 Apr 2013 15:46:02 +0900
Message-ID: <CAKYAXd_TUmZ4TM_v3bYyD7gyAnZ9hAoZ5sMmV3kGJe0BLqu84Q@mail.gmail.com>
Subject: Re: [PATCH] f2fs: move f2fs_balance_fs from truncate to punch_hole
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jason Hrycay <jhrycay@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, C.Fries@motorola.com,
        jason.hrycay@motorola.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/9, Jason Hrycay <jhrycay@gmail.com>:
> From: Jason Hrycay <jason.hrycay@motorola.com>
>
> Move the f2fs_balance_fs out of the truncate_hole function and only
> perform that in punch_hole use case.  The commit:
>
>   ed60b1644e7f7e5dd67d21caf7e4425dff05dad0
>
> intended to do this but moved it into truncate_hole to cover more
> cases.  However, a deadlock scenario is possible when deleting an inode
> entry under specific conditions:
>
>  f2fs_delete_entry()
>      mutex_lock_op(sbi, DENTRY_OPS);
>      truncate_hole()
>          f2fs_balance_fs()
>              mutex_lock(&sbi->gc_mutex);
>              f2fs_gc()
>                  write_checkpoint()
>                      block_operations()
>                          mutex_lock_op(sbi, DENTRY_OPS);
>
> Lets move it into the punch_hole case to cover the original intent of
> avoiding it during fallocate's expand_inode_data case.
>
> Change-Id: I29f8ea1056b0b88b70ba8652d901b6e8431bb27e
> Signed-off-by: Jason Hrycay <jason.hrycay@motorola.com>
Hi,
With the latest commit 9995bf953a83749abd9fa22f72ab2b0be341025a
About introducing the global locking method in ‘f2fs’,
I think we no longer will have a case of deadlock happening in this path.

Thanks.
