Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3JUVap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:30:45 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:47525 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3JUVan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <20131018195036.259873162@linuxfoundation.org>
References: <20131018195036.020644622@linuxfoundation.org> <20131018195036.259873162@linuxfoundation.org>
From: Felipe Pena <felipensp@gmail.com>
Date: Mon, 21 Oct 2013 19:30:22 -0200
Message-ID: <CA+5g0SLgfgAaTBTL11hG-vYKtgZ75_KOz-Y40o3m6FwNohUg9A@mail.gmail.com>
Subject: Re: [ 3/7] ext4: fix memory leak in xattr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Jones <davej@fedoraproject.org>, Theodore Tso <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 18, 2013 at 4:52 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Dave Jones <davej@redhat.com>
>
> commit 6e4ea8e33b2057b85d75175dd89b93f5e26de3bc upstream.
>
> If we take the 2nd retry path in ext4_expand_extra_isize_ea, we
> potentionally return from the function without having freed these
> allocations.  If we don't do the return, we over-write the previous
> allocation pointers, so we leak either way.
>
> Spotted with Coverity.
>
> [ Fixed by tytso to set is and bs to NULL after freeing these
>   pointers, in case in the retry loop we later end up triggering an
>   error causing a jump to cleanup, at which point we could have a double
>   free bug. -- Ted ]
>
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  fs/ext4/xattr.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1271,6 +1271,8 @@ retry:
>                                     s_min_extra_isize) {
>                                         tried_min_extra_isize++;
>                                         new_extra_isize = s_min_extra_isize;
> +                                       kfree(is); is = NULL;
> +                                       kfree(bs); bs = NULL;

Looks like such lines are not conforming to coding style, or?

>                                         goto retry;
>                                 }
>                                 error = -1;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,
Felipe Pena
