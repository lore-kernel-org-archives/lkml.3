Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaKYMXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:23:15 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37950 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaKYMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:23:13 -0500
MIME-Version: 1.0
In-Reply-To: <1416852146-9781-8-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com> <1416852146-9781-8-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Chernenkov <dmitryc@google.com>
Date: Tue, 25 Nov 2014 16:22:53 +0400
Message-ID: <CAA6XgkFPvHQE7LpZ=Q19e8sGAwOtWiVBXzjZA+7HXmNWL_genA@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] mm: slub: introduce metadata_access_enable()/metadata_access_disable()
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LGTM

Does this mean we're going to sanitize the slub code itself?)

On Mon, Nov 24, 2014 at 9:02 PM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> Wrap access to object's metadata in external functions with
> metadata_access_enable()/metadata_access_disable() function calls.
>
> This hooks separates payload accesses from metadata accesses
> which might be useful for different checkers (e.g. KASan).
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  mm/slub.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 0c01584..88ad8b8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -467,13 +467,23 @@ static int slub_debug;
>  static char *slub_debug_slabs;
>  static int disable_higher_order_debug;
>
> +static inline void metadata_access_enable(void)
> +{
> +}
> +
> +static inline void metadata_access_disable(void)
> +{
> +}
> +
>  /*
>   * Object debugging
>   */
>  static void print_section(char *text, u8 *addr, unsigned int length)
>  {
> +       metadata_access_enable();
>         print_hex_dump(KERN_ERR, text, DUMP_PREFIX_ADDRESS, 16, 1, addr,
>                         length, 1);
> +       metadata_access_disable();
>  }
>
>  static struct track *get_track(struct kmem_cache *s, void *object,
> @@ -503,7 +513,9 @@ static void set_track(struct kmem_cache *s, void *object,
>                 trace.max_entries = TRACK_ADDRS_COUNT;
>                 trace.entries = p->addrs;
>                 trace.skip = 3;
> +               metadata_access_enable();
>                 save_stack_trace(&trace);
> +               metadata_access_disable();
>
>                 /* See rant in lockdep.c */
>                 if (trace.nr_entries != 0 &&
> @@ -677,7 +689,9 @@ static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
>         u8 *fault;
>         u8 *end;
>
> +       metadata_access_enable();
>         fault = memchr_inv(start, value, bytes);
> +       metadata_access_disable();
>         if (!fault)
>                 return 1;
>
> @@ -770,7 +784,9 @@ static int slab_pad_check(struct kmem_cache *s, struct page *page)
>         if (!remainder)
>                 return 1;
>
> +       metadata_access_enable();
>         fault = memchr_inv(end - remainder, POISON_INUSE, remainder);
> +       metadata_access_disable();
>         if (!fault)
>                 return 1;
>         while (end > fault && end[-1] == POISON_INUSE)
> --
> 2.1.3
>
