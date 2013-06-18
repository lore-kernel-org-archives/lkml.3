Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3FRFrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:47:12 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52884 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FRFrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd95yVtbEmwiaDaxgDsJYbqWDV23rY0GuPKLVf0msSGJ2g@mail.gmail.com>
References: <1367107703-2665-1-git-send-email-linkinjeon@gmail.com>
	<87ppxd4ddm.fsf@devron.myhome.or.jp>
	<CAKYAXd8v-eF0E2FzLfm1KaZaRu-adQcDVQQeWAiH6-8Pr+BxmA@mail.gmail.com>
	<87bo8v42wx.fsf@devron.myhome.or.jp>
	<CAKYAXd_-Z8Avm-FmLF=MVqHSkzfE1_jczBroyFXv5xgQmr5=XA@mail.gmail.com>
	<87vc722cdu.fsf@devron.myhome.or.jp>
	<CAKYAXd8nTUrW04ADyDkhnJWyjUKiniU+r65J5SMhXT-jHTG+UA@mail.gmail.com>
	<87r4hp3kax.fsf@devron.myhome.or.jp>
	<87k3nh3jzi.fsf@devron.myhome.or.jp>
	<CAKYAXd_DRLG3KzjXEQ_8vD5mFWE95gR+jj3-MYhC3QKgQOLTEA@mail.gmail.com>
	<87fvy53eun.fsf@devron.myhome.or.jp>
	<CAKYAXd95yVtbEmwiaDaxgDsJYbqWDV23rY0GuPKLVf0msSGJ2g@mail.gmail.com>
Date: Tue, 18 Jun 2013 14:47:10 +0900
Message-ID: <CAKYAXd8kyN1w5GJ8zCoKL+XS67125dUf0ivqCQWKjGCSxnXYpg@mail.gmail.com>
Subject: Re: [PATCH RESEND v5] fat: editions to support fat_fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, OGAWA.

We checked several cases with respect to your questions. But we cannot
find any issue.
Also, We compare the results with Ext4. It is same.
>cluster size == 512b

>1) create new file
>2) fallocate 100MB
>3) write(2) data for each 512b

>With this, write_begin() will be called for each 512b data. When we
>allocates new page for this file, write_begin() writes data 0-512. Then,
>we have to initialize 512-4096 by zero. Because mmap read maps 0-4096,
>even if i_size == 512.

>Who is initializing area for 512-4096?
When we checked, we found that page which is allocated to mmap is
already filled with zeros. And 512byte is filled in this page. If we
try to read mmap beyond the file size of 512 bytes , nulls are
returned . Hence , mmap works correctly in such cases .

>From other view, I guess fat_zero_falloc_area() is for filling zero for
>0-10000, in the following case?

> 1) create new file
> 2) lseek(10000)
> 3) write data by write(2)

>This job is for cont_write_begin(). If example is correct, why
>cont_write_begin() doesn't work? I guess, because get_block() doesn't
>set buffer_new() for those area.
If we will not call fallocate with keep size flags, cont_write_begin
will work and zero out on lseek area (this works like expanding
truncate).

>If above is correct, right implement to change get_block().
Now when we try to write in the fallocated region ( with keep size) in
the fat_write_begin when it is called first time it checks that the
mismatch is present between the mmu_private and mmu_actual , and hence
zero out the region ; since buffer_new is not set for fallocated
region by fat_get_block , we explicitly zero out the lseeked region
using “fat_zero_falloc_area” and normal write occurs beyond that , and
i_size is updated accordingly , and as such there is no need to move
the code to fat_get_block .
>I'm ok as start if it works.
>
>But from this discussion, discard at last close(2) doesn't look like
>working for your requirement. Since you want to discard at last close of
>inode, so, rather, I guess you actually want to discard at last
>dereference of inode.
We also moved the release of fallocated clusters from the
“fat_file_release” to “fat_evict_inode” and on the basis of i_count so
that the fallocated clusters are released at the last reference of the
inode.

Thanks.
