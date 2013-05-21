Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3EUHRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:17:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58875 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3EUHRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <1369120410-18180-1-git-send-email-oskar.andero@sonymobile.com>
References: <1369120410-18180-1-git-send-email-oskar.andero@sonymobile.com>
Date: Tue, 21 May 2013 10:17:15 +0300
X-Google-Sender-Auth: oqPDS2nDfE-hoBGgxdUXUU5xiZE
Message-ID: <CAOJsxLGivq0p1j4Axykdz-O8FtYfn=M1BfLEnc=q-fjxA2Yonw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: vmscan: add VM_BUG_ON on illegal return values
 from scan_objects
From: Pekka Enberg <penberg@kernel.org>
To: Oskar Andero <oskar.andero@sonymobile.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:13 AM, Oskar Andero
<oskar.andero@sonymobile.com> wrote:
> Add a VM_BUG_ON to catch any illegal value from the shrinkers. It's a
> potential bug if scan_objects returns a negative other than -1 and
> would lead to undefined behaviour.
>
> Cc: Glauber Costa <glommer@openvz.org>
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  mm/vmscan.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6bac41e..63fec86 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -293,6 +293,7 @@ shrink_slab_one(struct shrinker *shrinker, struct shrink_control *shrinkctl,
>                 ret = shrinker->scan_objects(shrinker, shrinkctl);
>                 if (ret == -1)
>                         break;
> +               VM_BUG_ON(ret < -1);

It seems to me relaxing the shrinker API restrictions and changing the
"ret == -1" to "ret < 0" would be a much more robust approach...

>                 freed += ret;
>
>                 count_vm_events(SLABS_SCANNED, nr_to_scan);
> --
> 1.8.1.5
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
