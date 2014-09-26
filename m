Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaIZED2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:03:28 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:53318 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaIZED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <1411562649-28231-9-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com> <1411562649-28231-9-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 25 Sep 2014 21:03:06 -0700
Message-ID: <CACT4Y+Y7thfa91kqkU-Wkna=1ZeXxQCHHXjz9QyPC-nKm6dJwQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/13] mm: slub: introduce metadata_access_enable()/metadata_access_disable()
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

On Wed, Sep 24, 2014 at 5:44 AM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
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
> index 82282f5..9b1f75c 100644
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
> 2.1.1
>
