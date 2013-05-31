Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3EaXSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:18:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59493 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951Ab3EaXSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <1369217581-16285-6-git-send-email-serban.constantinescu@arm.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
	<1369217581-16285-6-git-send-email-serban.constantinescu@arm.com>
Date: Fri, 31 May 2013 16:18:08 -0700
Message-ID: <CAMP5Xgf_hQqFdwhjbC_4CeQVR0aHM+LU8-bvuUk8MrVuM+2H5w@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] staging: android: binder: fix alignment issues
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 3:13 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> The Android userspace aligns the data written to the binder buffers to
> 4bytes. Thus for 32bit platforms or 64bit platforms running an 32bit
> Android userspace we can have a buffer looking like this:
>
> platform    buffer(binder_cmd   pointer)      size
> 32/32                 32b         32b          8B
> 64/32                 32b         64b          12B
> 64/64                 32b         64b          12B
>
> Thus the kernel needs to check that the buffer size is aligned to 4bytes
> not to (void *) that will be 8bytes on 64bit machines.
>
> The patch also fixes the alignment issues for the offsets buffer, where
> on 64bit systems, if the data_size is not aligned to 8bytes the offset's
> start address will be incorrectly calculated.

I think this refers to a problem introduced in a previous version of
this patch, not a problem with the existing code. If you want to
include this in the change description you should make that more
clear.

>
> The change does not affect existing 32bit ABI.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index ca79084..72f5bb9 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -658,8 +658,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
>                 return NULL;
>         }
>
> -       size = ALIGN(data_size, sizeof(void *)) +
> -               ALIGN(offsets_size, sizeof(void *));
> +       size = ALIGN(data_size, sizeof(u32)) +
> +               ALIGN(offsets_size, sizeof(u32));

I still disagree with this change. There is no reason to not keep the
kernel allocated buffers aligned to the native pointer size. The
binder_buffer struct contain several pointers that are not longer
aligned with this change.

>
>         if (size < data_size || size < offsets_size) {
>                 binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
> @@ -807,8 +807,8 @@ static void binder_free_buf(struct binder_proc *proc,
>
>         buffer_size = binder_buffer_size(proc, buffer);
>
> -       size = ALIGN(buffer->data_size, sizeof(void *)) +
> -               ALIGN(buffer->offsets_size, sizeof(void *));
> +       size = ALIGN(buffer->data_size, sizeof(u32)) +
> +               ALIGN(buffer->offsets_size, sizeof(u32));

This change should also be removed.

>
>         binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
>                      "%d: binder_free_buf %p size %zd buffer_size %zd\n",
> @@ -1238,7 +1238,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
>         if (buffer->target_node)
>                 binder_dec_node(buffer->target_node, 1, 0);
>
> -       offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
> +       offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(u32)));

This change should also be removed.

>         if (failed_at)
>                 off_end = failed_at;
>         else
> @@ -1247,7 +1247,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
>                 struct flat_binder_object *fp;
>                 if (*offp > buffer->data_size - sizeof(*fp) ||
>                     buffer->data_size < sizeof(*fp) ||
> -                   !IS_ALIGNED(*offp, sizeof(void *))) {
> +                   !IS_ALIGNED(*offp, sizeof(u32))) {
>                         pr_err("transaction release %d bad offset %zd, size %zd\n",
>                          debug_id, *offp, buffer->data_size);
>                         continue;
> @@ -1471,7 +1471,7 @@ static void binder_transaction(struct binder_proc *proc,
>         if (target_node)
>                 binder_inc_node(target_node, 1, 0, NULL);
>
> -       offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
> +       offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(u32)));

This change should also be removed.

>
>         if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
>                 binder_user_error("%d:%d got transaction with invalid data ptr\n",
> @@ -1496,7 +1496,7 @@ static void binder_transaction(struct binder_proc *proc,
>                 struct flat_binder_object *fp;
>                 if (*offp > t->buffer->data_size - sizeof(*fp) ||
>                     t->buffer->data_size < sizeof(*fp) ||
> -                   !IS_ALIGNED(*offp, sizeof(void *))) {
> +                   !IS_ALIGNED(*offp, sizeof(u32))) {
>                         binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
>                                         proc->pid, thread->pid, *offp);
>                         return_error = BR_FAILED_REPLY;
> @@ -2332,7 +2332,7 @@ retry:
>                                         proc->user_buffer_offset;
>                 tr.data.ptr.offsets = tr.data.ptr.buffer +
>                                         ALIGN(t->buffer->data_size,
> -                                           sizeof(void *));
> +                                           sizeof(u32));

This change should also be removed.

>
>                 if (put_user(cmd, (uint32_t __user *)ptr))
>                         return -EFAULT;
> --
> 1.7.9.5
>



--
Arve Hjønnevåg
