Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaBFJAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:00:39 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52295 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaBFJAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:00:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
Date: Thu, 6 Feb 2014 10:00:35 +0100
X-Google-Sender-Auth: istFI2UxRY1_RTXN4RC6B3RqfDM
Message-ID: <CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:47 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Wed, Jan 15, 2014 at 12:06 PM, Joe Perches <joe@perches.com> wrote:
>> On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
>>> drivers/md/bcache/btree.c: In function ‘insert_u64s_remaining’:
>>> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
>> []
>>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> []
>>> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
>>>       if (b->keys.ops->is_extents)
>>>               ret -= KEY_MAX_U64S;
>>>
>>> -     return max(ret, 0L);
>>> +     return max_t(ssize_t, ret, 0L);
>>
>> why not
>>         return max(ret, 0);
>
> Indeed, that also works, on both 32-bit and 64-bit.
> Will resend, now all the issues moved from -next to Linus' tree.

However, sparse doesn't like it, so we'll have to go for v1?

>From kbuild test robot fengguang.wu@intel.com:

>> drivers/md/bcache/btree.c:1816:16: sparse: incompatible types in comparison expression (different type sizes)
   In file included from arch/x86/include/asm/percpu.h:44:0,
                    from arch/x86/include/asm/preempt.h:5,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/wait.h:8,
                    from include/linux/fs.h:6,
                    from include/linux/highmem.h:4,
                    from include/linux/bio.h:23,
                    from drivers/md/bcache/bcache.h:181,
                    from drivers/md/bcache/btree.c:23:
   drivers/md/bcache/btree.c: In function 'insert_u64s_remaining':
   include/linux/kernel.h:718:17: warning: comparison of distinct
pointer types lacks a cast [enabled by default]
     (void) (&_max1 == &_max2);  \
                    ^
   drivers/md/bcache/btree.c:1816:9: note: in expansion of macro 'max'
     return max(ret, 0);
            ^

vim +1816 drivers/md/bcache/btree.c

  1800                                                status);
  1801                  return true;
  1802          } else
  1803                  return false;
  1804  }
  1805
  1806  static size_t insert_u64s_remaining(struct btree *b)
  1807  {
  1808          ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
  1809
  1810          /*
  1811           * Might land in the middle of an existing extent and
have to split it
  1812           */
  1813          if (b->keys.ops->is_extents)
  1814                  ret -= KEY_MAX_U64S;
  1815
> 1816          return max(ret, 0);
  1817  }
  1818
  1819  static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op,
  1820                                    struct keylist *insert_keys,
  1821                                    struct bkey *replace_key)
  1822  {
  1823          bool ret = false;
  1824          int oldsize = bch_count_data(&b->keys);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
