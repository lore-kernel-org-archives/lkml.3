Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaKYVSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:18:03 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34796 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaKYVSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:18:01 -0500
MIME-Version: 1.0
In-Reply-To: <6F1FC669-B4AE-4593-A1EE-6F72C38D117B@me.com>
References: <6F1FC669-B4AE-4593-A1EE-6F72C38D117B@me.com>
Date: Tue, 25 Nov 2014 13:18:00 -0800
X-Google-Sender-Auth: E411t5ok0-sAgpSeWBsFrhACItg
Message-ID: <CAE9FiQXe2YMN6bL8jdk7fB1ksKCSEFCbL3PF9386vG+NET_0sQ@mail.gmail.com>
Subject: Re: PATCH: avoid possible integer overflow with cmp_range() in kernel/range.c
From: Yinghai Lu <yinghai@kernel.org>
To: Louis Langholtz <lou_langholtz@me.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tile should be:

[PATCH] x86: ....

On Tue, Nov 25, 2014 at 11:14 AM, Louis Langholtz <lou_langholtz@me.com> wrote:
> The cmp_range function (in kernel/range.c) is returning the difference between two s64 values (actually coming from u64 typed variables) in an int which can overflow (depending on the size of int). This function is used as a compare function for linux's sort function (in lib/sort.c). Linux's sort function however only cares if the compare function returns a value less than, equal to, or greater than zero.
>
> As sort doesn't need the actual difference, this overflow potential is avoided with the following patch (against linux kernel 3.18 code from Linus's git repo and commit 0541881502a1276149889fe468662ff6a8fc8f6d):
>
> commit 641362d32fef0cfd7b12e1821c1139d75dd23330
> Author: Lou Langholtz <lou_langholtz@me.com>
> Date:   Mon Nov 24 09:31:01 2014 -0700

do not need 6 lines.

>
>     Avoid overflow possibility

You need
Signed-off-by: ....

Please check Documentation/SubmittingPatches for more info.

>
> diff --git a/kernel/range.c b/kernel/range.c
> index 322ea8e..86337e2 100644
> --- a/kernel/range.c
> +++ b/kernel/range.c
> @@ -113,12 +113,17 @@ static int cmp_range(const void *x1, const void *x2)
>  {
>         const struct range *r1 = x1;
>         const struct range *r2 = x2;
> -       s64 start1, start2;
> +       u64 start1, start2;
>
>         start1 = r1->start;
>         start2 = r2->start;
>
> -       return start1 - start2;
> +       /* avoid any overflow possibilities and don't just return start1 - start2 */
> +       if (start1 > start2)
> +               return 1;
> +       if (start2 > start1)
> +               return -1;
> +       return 0;
>  }
>
>  int clean_sort_range(struct range *range, int az)
>
