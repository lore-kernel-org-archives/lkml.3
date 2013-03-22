Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab3CVJbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:31:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3CVJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:31:19 -0400
MIME-Version: 1.0
In-Reply-To: <514BF0BE.1070907@huawei.com>
References: <1363793126-11510-1-git-send-email-ming.lei@canonical.com>
	<1363793126-11510-2-git-send-email-ming.lei@canonical.com>
	<514A7340.5040409@huawei.com>
	<CACVXFVN7urpLM+Q-3o9=hYQLM=544WTXh+BnSo9fBM+d07oapQ@mail.gmail.com>
	<514A7E72.2090200@huawei.com>
	<CACVXFVMS644BpX7voMHS-xXoRs9-G4y96=ubk_NAj6KDTy1ENQ@mail.gmail.com>
	<514BF0BE.1070907@huawei.com>
Date: Fri, 22 Mar 2013 17:31:16 +0800
Message-ID: <CACVXFVOAFqVoNP-igJ-WeaJ+rKF-gREcHqspHWOkz4EJ9Gn94w@mail.gmail.com>
Subject: Re: [PATCH 1/2] sysfs: fix race between readdir and lseek
From: Ming Lei <ming.lei@canonical.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 1:48 PM, Li Zefan <lizefan@huawei.com> wrote:
> On 2013/3/21 12:48, Ming Lei wrote:
>
> Yes, it can...As I said, it's irrelevant, because it's vfs that changes
> file->f_pos.
>
> SYSCALL_DEFINE3(read, unsigned int, fd, char __user *, buf, size_t, count)
> {
>         struct fd f = fdget(fd);
>         ssize_t ret = -EBADF;
>
>         if (f.file) {
>                 loff_t pos = file_pos_read(f.file);             <--- read f_pos
>                 ret = vfs_read(f.file, buf, count, &pos);       <--- return -EISDIR
>                 file_pos_write(f.file, pos);                    <--- write f_pos

Considered that f_pos of sysfs directory is always less than INT_MAX,
we need't worry about atomic writing it in file_pos_write().

The only probable problem on sysfs is below scenario in read()/write():

-  pos is read as less than 2 in file_pos_read(f.file)
-  ret = vfs_read(f.file, buf, count, &pos)
          ---> readdir() in another path
-  file_pos_write(pos)
         ---> readdir() found f_pos becomes 0 or 1, and may cause
use-after-free problem

Considered that vfs_read()/vfs_write on sysfs dir is almost doing nothing, the
above problem may only exist in theory. The patch[1] can't avoid it too.
I am wondering if it need to be fixed, but I will try to figure out how to
avoid it in sysfs_readdir() if possible.

[1], https://patchwork.kernel.org/patch/2160771/

Thanks,
--
Ming Lei
