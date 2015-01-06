Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbbAFWsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:48:18 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49542 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbAFWsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:48:16 -0500
MIME-Version: 1.0
Date: Wed, 7 Jan 2015 00:48:15 +0200
Message-ID: <CANZNk80SoQZU994psVKuuGRGGHnGgO7bcFpPBQoGyg=CjW77xw@mail.gmail.com>
Subject: lustre/lnet/lnet/lib-move.c: memcpy with (struct iovec*)->iov_base,
 which is __user
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com, HPDD-discuss@ml01.01.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear maintainers of LustreFS and other experienced kernel developers!

I am working on fixing some sparse warnings as a task of Eudyptula Challenge.
There's a thing that look suspiciously to me (or I just don't
understand it). This looks same both in upstream kernel code in
drivers/staging/ and in https://github.com/Xyratex/lustre-stable.git
(it doesn't fetch from http://git.whamcloud.com/fs/lustre-release.git,
but I guess it is similar with Xyratex repo).

In lnet/lnet/lib-move.c, in lnet_copy_iov2iov(), at line 209, there is

                memcpy((char *)diov->iov_base + doffset,
                        (char *)siov->iov_base + soffset, this_nob);

diov and siov are struct iovec *, and iov_base in it is void __user *.
Are diov and siov really used semantically correctly here, holding
userspace addresses in iov_base?
Is it semantically correct to use memcpy to copy bytes from one
userspace address to another?

How to treat the comment "/* NB diov, siov are READ-ONLY */" at line
177 in the same procedure? Is it adequate?

This above-mentioned memcpy operation causes sparse warnings "warning:
cast removes address space of expression" for both first and second
line. When i change it to

                memcpy((void __user *)((char __user *)diov->iov_base + doffset),
                        (void __user *)((char __user *)siov->iov_base
+ soffset), this_nob);

It gives other sparse warnings:
drivers/staging/lustre/lnet/lnet/lib-move.c:208:25: warning: incorrect
type in argument 1 (different address spaces)
drivers/staging/lustre/lnet/lnet/lib-move.c:208:25:    expected void *to
drivers/staging/lustre/lnet/lnet/lib-move.c:208:25:    got void
[noderef] <asn:1>*<noident>
drivers/staging/lustre/lnet/lnet/lib-move.c:209:26: warning: incorrect
type in argument 2 (different address spaces)
drivers/staging/lustre/lnet/lnet/lib-move.c:209:26:    expected void const *from
drivers/staging/lustre/lnet/lnet/lib-move.c:209:26:    got void
[noderef] <asn:1>*<noident>

What is supposed way to avoid warnings in this case?

Thanks.

-- 
Andrey Utkin
