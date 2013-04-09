Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022Ab3DIXsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:48:42 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58687 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762266Ab3DIXsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <1365501657-4213-4-git-send-email-serban.constantinescu@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-4-git-send-email-serban.constantinescu@arm.com>
Date: Tue, 9 Apr 2013 16:48:40 -0700
Message-ID: <CAMP5XgdNi4BV-aWDGhmFgNGceGoT2msdU_rA4U=wqs6xtYRc_A@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] staging: android: binder: fix binder interface for
 64bit compat layer
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

On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
<serban.constantinescu@arm.com> wrote:
> The changes in this patch will fix the binder interface for use on 64bit
> machines and stand as the base of the 64bit compat support. The changes
> apply to the structures that are passed between the kernel and
> userspace.
>
> Most of the changes applied mirror the change to struct binder_version
> where there is no need for a 64bit wide protocol_version(on 64bit
> machines). The change inlines with the existing 32bit userspace(the
> structure has the same size) and simplifies the compat layer such that
> the same handler can service the BINDER_VERSION ioctl.
>
> Other changes fix the function prototypes for binder_thread_read/write,
> make use of kernel types as well as user-exportable ones and fix
> format specifier issues.
>
> The changes do not affect existing 32bit ABI.
>
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
> drivers/staging/android/binder.c | 28 ++++++++++++++--------------
> drivers/staging/android/binder.h | 16 ++++++++--------
> 2 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 5794cf6..a2cdd9e 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
...
> @@ -1700,7 +1700,7 @@ err_no_context_mgr_node:
> }
>
> int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
> - void __user *buffer, int size, signed long *consumed)
> + void __user *buffer, size_t size, size_t *consumed)

What is this change for? You changed from a signed type to an unsigned
type which seems unrelated to adding 64 bit support.

...
> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> index dbe81ce..8012921 100644
> --- a/drivers/staging/android/binder.h
> +++ b/drivers/staging/android/binder.h
> @@ -48,13 +48,13 @@ enum {
> */
> struct flat_binder_object {
> /* 8 bytes for large_flat_header. */
> - unsigned long type;
> - unsigned long flags;
> + __u32 type;
> + __u32 flags;
>
> /* 8 bytes of data. */
> union {
> void __user *binder; /* local object */
> - signed long handle; /* remote object */
> + __s32 handle; /* remote object */

Why limit the handle to 32 bits when the pointer that it shares
storage with need to be 64 bit on 64 bit systems?

> };
>
> /* extra data associated with local object */
> @@ -67,18 +67,18 @@ struct flat_binder_object {
> */
>
> struct binder_write_read {
> - signed long write_size; /* bytes to write */
> - signed long write_consumed; /* bytes consumed by driver */
> + size_t write_size; /* bytes to write */
> + size_t write_consumed; /* bytes consumed by driver */
> unsigned long write_buffer;
> - signed long read_size; /* bytes to read */
> - signed long read_consumed; /* bytes consumed by driver */
> + size_t read_size; /* bytes to read */
> + size_t read_consumed; /* bytes consumed by driver */

What is this change for? You changed from a signed type to an unsigned
type which seems unrelated to adding 64 bit support.

> unsigned long read_buffer;
> };
>
> /* Use with BINDER_VERSION, driver fills in fields. */
> struct binder_version {
> /* driver protocol version -- increment with incompatible change */
> - signed long protocol_version;
> + __s32 protocol_version;

How does user-space know if it should use 32 bit or 64 bit pointers.
Without this change, the BINDER_VERSION ioctl would only match when
the size of long matches.

> };
>
> /* This is the current protocol version. */
> --
> 1.7.9.5
>


--
Arve Hjønnevåg
