Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3FJTbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:31:18 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54461 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3FJTbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>
Date: Mon, 10 Jun 2013 22:31:15 +0300
X-Google-Sender-Auth: mgolzQHV7eTYKvLTG-V2zrQx-MM
Message-ID: <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Christoph Lameter <cl@linux.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sasha,

On Mon, Jun 10, 2013 at 10:18 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> slab would still spew a warning when a big allocation happens with the
> __GFP_NOWARN fleg is set. Prevent that to conform to __GFP_NOWARN.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  mm/slab_common.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index ff3218a..2d41450 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -373,8 +373,10 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
>  {
>         int index;
>
> -       if (WARN_ON_ONCE(size > KMALLOC_MAX_SIZE))
> +       if (size > KMALLOC_MAX_SIZE) {
> +               WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>                 return NULL;
> +       }

Does this fix a real problem you're seeing? __GFP_NOWARN is about not
warning if a memory allocation fails but this particular WARN_ON
suggests a kernel bug.

                         Pekka
