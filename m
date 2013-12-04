Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab3LDIaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:30:08 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:60090 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3LDIaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:30:06 -0500
Date: Wed, 4 Dec 2013 08:30:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] mfd: Stop setting refcounting pointers in original
 mfd_cell arrays
Message-ID: <20131204083001.GD7469@lee--X1>
References: <1383037384-30079-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383037384-30079-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Geert Uytterhoeven wrote:

> Commit 1e29af62f2b285bd18685da93c3ce8c33ca2d1db ("mfd: Add refcounting
> support to mfd_cells") had to drop the "const" keyword on the "cell"
> parameter of mfd_add_devices(), as it added the refcounting pointers
> to the objects of the passed mfd_cell array itself.
> 
> However, the mfd core code operates on copies of the mfd_cell objects,
> so there's no need to modify the originally passed objects.
> 
> Hence, move the setting of the refcounting pointers from mfd_add_devices()
> to mfd_platform_add_cell(), where the copy of the mfd_cell objects is made.
> mfd_clone_cell() can just pass (a copy of) the original usage_count
> pointer.
> 
> This allows to make the "cell" parameter of mfd_add_devices() "const"
> again, and avoids future race conditions when registering multiple
> instances of the same device in parallel.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Ever since this "const" keyword was removed, I was wondering what was
> really going on with these reference counts. My main use case involved
> multiple instances of the same device, where the registration of each
> successive instance would overwrite the refcounting pointer of the
> previous one.
> Finally I found some time to dive into it, and create this patch.
> If it is accepted, I'll create a follow-up patch to add
> "const" keywords to the various mfd_cell arrays.
> 
> Note that there's another issue in mfd_add_devices(): if the first call to
> mfd_add_device() fails, the array of atomic_t objects will never be freed,
> as no child devices have been registered to the parent yet, and thus
> mfd_remove_devices() won't find anything to remove nor free.
> 
>  drivers/mfd/mfd-core.c   |   17 +++++++++--------
>  include/linux/mfd/core.h |    2 +-
>  2 files changed, 10 insertions(+), 9 deletions(-)

Hmm... I didn't see my reply to this, but it has been applied for a
while.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
