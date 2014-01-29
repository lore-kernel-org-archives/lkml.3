Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaA2PbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:31:10 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44406 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaA2PbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:31:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140129151710.GO25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
	<20140128225229.GH25989@kernel.dk>
	<CAMuHMdUseSC+Roa5sTYfXtBxGn2OOCQpLAtdRgeoVAVdBrotWw@mail.gmail.com>
	<20140129151710.GO25989@kernel.dk>
Date: Wed, 29 Jan 2014 16:31:04 +0100
X-Google-Sender-Auth: 1Y2pdXYO9zZ84BHKeI77QolKZyg
Message-ID: <CAMuHMdWdvSUV6-nWQ5w5TAYhSQBm20ruhaDj9y08jd5EMo=yGA@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Wed, Jan 29, 2014 at 4:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On Wed, Jan 29 2014, Geert Uytterhoeven wrote:
>> On Tue, Jan 28, 2014 at 11:52 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> >> - Finally the immutable biovec changes from Kent Overstreet. This
>> >>   enables some nice future work on making arbitrarily sized bios
>> >>   possible, and splitting more efficient. Related fixes to immutable
>> >>   bio_vecs:
>> >>
>> >>         - dm-cache immutable fixup from Mike Snitzer.
>> >>         - btrfs immutable fixup from Muthu Kumar.
>> >>
>> >> - bio-integrity fix from Nic Bellinger, which is also going to stable.
>> >>
>> >>
>> >> Please pull! There will be a bit of merge work for you, but it should be
>> >> fairly straight forward. It's mostly related to changin:
>> >>
>> >> bio->bi_sector  -> bio->bi_iter.bi_sector
>> >> bio->bi_size    -> bio->bi_iter.bi_size
>> >>
>> >>
>> >> git://git.kernel.dk/linux-block.git for-3.14/core
>> >
>> > BTW, let me know if you want me to merge this. The above has been in
>> > for-next since forever, and Stephen has carried a fix or two for new
>> > merges.
>>
>> arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
>> member named 'bi_sector'
>>
>> http://kisskb.ellerman.id.au/kisskb/buildresult/10542666/
>
> Does the below fix it for you? There's an existing bug in there where it
> kunmaps the wrong part (page instead of the address). Not sure that
> matters on xtensa or whether the kmaps are a no-op, but cleaned up none
> the less.

Yes, it does. Thanks!

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
> index 8c6e819cd8ed..48eebacdf5fe 100644
> --- a/arch/xtensa/platforms/iss/simdisk.c
> +++ b/arch/xtensa/platforms/iss/simdisk.c
> @@ -103,18 +103,18 @@ static void simdisk_transfer(struct simdisk *dev, unsigned long sector,
>
>  static int simdisk_xfer_bio(struct simdisk *dev, struct bio *bio)
>  {
> -       int i;
> -       struct bio_vec *bvec;
> -       sector_t sector = bio->bi_sector;
> +       struct bio_vec bvec;
> +       struct bvec_iter iter;
> +       sector_t sector = bio->bi_iter.bi_sector;
>
> -       bio_for_each_segment(bvec, bio, i) {
> -               char *buffer = __bio_kmap_atomic(bio, i);
> -               unsigned len = bvec->bv_len >> SECTOR_SHIFT;
> +       bio_for_each_segment(bvec, bio, iter) {
> +               char *buffer = __bio_kmap_atomic(bio, iter);
> +               unsigned len = bvec.bv_len >> SECTOR_SHIFT;
>
>                 simdisk_transfer(dev, sector, len, buffer,
>                                 bio_data_dir(bio) == WRITE);
>                 sector += len;
> -               __bio_kunmap_atomic(bio);
> +               __bio_kunmap_atomic(buffer);
>         }
>         return 0;
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
