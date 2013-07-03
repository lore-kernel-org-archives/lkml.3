Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab3GCW32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:29:28 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44940 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3GCW30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <1371661956-10894-5-git-send-email-serban.constantinescu@arm.com>
References: <1371661956-10894-1-git-send-email-serban.constantinescu@arm.com>
	<1371661956-10894-5-git-send-email-serban.constantinescu@arm.com>
Date: Wed, 3 Jul 2013 15:29:26 -0700
Message-ID: <CAMP5Xge2cCLng3VaqyCmQKf=CAz1jQhnAxn5jZNH0Mp5yaaNqA@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] staging: android: binder: fix alignment issues
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 10:12 AM, Serban Constantinescu
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
> The change does not affect existing 32bit ABI.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index ce70909..7450d56 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -1247,7 +1247,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
>                 struct flat_binder_object *fp;
>                 if (*offp > buffer->data_size - sizeof(*fp) ||
>                     buffer->data_size < sizeof(*fp) ||
> -                   !IS_ALIGNED(*offp, sizeof(void *))) {
> +                   !IS_ALIGNED(*offp, sizeof(u32))) {
>                         pr_err("transaction release %d bad offset %zd, size %zd\n",
>                          debug_id, *offp, buffer->data_size);
>                         continue;
> @@ -1496,7 +1496,7 @@ static void binder_transaction(struct binder_proc *proc,
>                 struct flat_binder_object *fp;
>                 if (*offp > t->buffer->data_size - sizeof(*fp) ||
>                     t->buffer->data_size < sizeof(*fp) ||
> -                   !IS_ALIGNED(*offp, sizeof(void *))) {
> +                   !IS_ALIGNED(*offp, sizeof(u32))) {
>                         binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
>                                         proc->pid, thread->pid, *offp);
>                         return_error = BR_FAILED_REPLY;
> --
> 1.7.9.5
>

Acked-by: Arve Hjønnevåg <arve@android.com>

--
Arve Hjønnevåg
