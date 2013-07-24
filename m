Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab3GXRoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:44:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36059 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3GXRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <CE156A09.575CF%andreas.dilger@intel.com>
References: <1374654692-13237-9-git-send-email-mail-agent-noreply@emc.com> <CE156A09.575CF%andreas.dilger@intel.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 25 Jul 2013 01:43:46 +0800
Message-ID: <CA+a=Yy7G41W=j8=czozVORdbCXned+qQ2KknGzzHm3HvSu_uMA@mail.gmail.com>
Subject: Re: [PATCH 8/8] staging/lustre: fix errno translate code on non-x86
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 1:27 AM, Dilger, Andreas
<andreas.dilger@intel.com> wrote:
> On 2013/07/24 2:31 AM, "mail-agent-noreply@emc.com"
> <mail-agent-noreply@emc.com> wrote:
>
>>From: Peng Tao <bergwolf@gmail.com>
>>
>>On non-x86 we will build with Lustre's errno translate code but
>>it has a few issues that break build on non-x86 platforms.
>
> Tao
> if the build is broken, wouldn't it make sense either to merge this patch
> into
> the original or land it earlier in the series to minimize/eliminate the
> window
> of un-bisectability?
>
The original one introduced the bug is already merged. See commit
2d58de78b2f6c53688a154b02bae3ada19ed15a9 in Greg's staging-next
(staging/lustre/ptlrpc: Translate between host and network errnos). So
we need to fix it in a separate patch.

And I agree with you that we need to put this one just before the
Kconfig fixup so that we don't break bisectability.

> Cheers, Andreas
>
> PS - this is a bug introduced during porting to the upstream kernel, it
> does
>      not exist in Lustre master branch.
>
Lustre master also need fixing. EIOCBRETRY is removed in recent
kernels. We'll need to backport that part of the patch to Intel tree.

Thanks,
Tao


>>Cc: Andreas Dilger <andreas.dilger@intel.com>
>>Signed-off-by: Peng Tao <tao.peng@emc.com>
>>---
>> drivers/staging/lustre/lustre/ptlrpc/Makefile |    2 +-
>> drivers/staging/lustre/lustre/ptlrpc/errno.c  |    4 +---
>> 2 files changed, 2 insertions(+), 4 deletions(-)
>>
>>diff --git a/drivers/staging/lustre/lustre/ptlrpc/Makefile
>>b/drivers/staging/lustre/lustre/ptlrpc/Makefile
>>index a379558..6d78b80 100644
>>--- a/drivers/staging/lustre/lustre/ptlrpc/Makefile
>>+++ b/drivers/staging/lustre/lustre/ptlrpc/Makefile
>>@@ -16,7 +16,7 @@ ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o
>>sec_lproc.o
>> ptlrpc_objs += sec_null.o sec_plain.o nrs.o nrs_fifo.o
>>
>> ptlrpc-y := $(ldlm_objs) $(ptlrpc_objs)
>>-ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.c
>>+ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.o
>>
>> obj-$(CONFIG_PTLRPC_GSS) += gss/
>>
>>diff --git a/drivers/staging/lustre/lustre/ptlrpc/errno.c
>>b/drivers/staging/lustre/lustre/ptlrpc/errno.c
>>index 46e259e..1c10063 100644
>>--- a/drivers/staging/lustre/lustre/ptlrpc/errno.c
>>+++ b/drivers/staging/lustre/lustre/ptlrpc/errno.c
>>@@ -25,7 +25,7 @@
>>  * Copyright (c) 2013, Intel Corporation.
>>  */
>>
>>-#include <libcfs/libcfs.h>
>>+#include <linux/libcfs/libcfs.h>
>> #include <lustre/lustre_errno.h>
>>
>> /*
>>@@ -184,7 +184,6 @@ static int lustre_errno_hton_mapping[] = {
>>       [EBADTYPE]              = LUSTRE_EBADTYPE,
>>       [EJUKEBOX]              = LUSTRE_EJUKEBOX,
>>       [EIOCBQUEUED]           = LUSTRE_EIOCBQUEUED,
>>-      [EIOCBRETRY]            = LUSTRE_EIOCBRETRY
>> };
>>
>> static int lustre_errno_ntoh_mapping[] = {
>>@@ -331,7 +330,6 @@ static int lustre_errno_ntoh_mapping[] = {
>>       [LUSTRE_EBADTYPE]               = EBADTYPE,
>>       [LUSTRE_EJUKEBOX]               = EJUKEBOX,
>>       [LUSTRE_EIOCBQUEUED]            = EIOCBQUEUED,
>>-      [LUSTRE_EIOCBRETRY]             = EIOCBRETRY
>> };
>>
>> unsigned int lustre_errno_hton(unsigned int h)
>>--
>>1.7.1
>>
>>
>
>
> Cheers, Andreas
> --
> Andreas Dilger
>
> Lustre Software Architect
> Intel High Performance Data Division
>
>
