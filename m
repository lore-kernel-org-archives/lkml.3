Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3JJUPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:15:07 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41679 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JJUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
References: <20131009232642.GA12776@jtriplet-mobl1>
	<1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 10 Oct 2013 13:15:03 -0700
X-Google-Sender-Auth: XB5uqtVCOuc0E05YA6Dstm7cYP8
Message-ID: <CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com>
Subject: Re: Regression parsing GPT (EFI) partition tables
From: Doug Anderson <dianders@chromium.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just ran into this same problem and tracked it down to the same
commit.  Luckily Sean found this thread.  :)

On Wed, Oct 9, 2013 at 5:37 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> Hi Josh,
>
> On Wed, 2013-10-09 at 16:26 -0700, Josh Triplett wrote:
>> When testing ChromeOS with a 3.12 kernel from git, I encountered a
>> regression introduced between 3.11 to 3.12: at boot time, the kernel
>> failed to find any partitions on the USB disk I booted from, which uses
>> a GPT partition table with 12 partitions.  This prevented the system
>> from booting.
>>
>> Reverting all the patches to block/partitions/efi.c between 3.11 and
>> 3.12 allowed the system to detect partitions again.  The patches I
>> reverted:
>>
>> 6b02fa5 partitions/efi: loosen check fot pmbr size in lba
>> b4bc4a1 block/partitions/efi.c: consistently use pr_foo()
>> 70f637e partitions/efi: some style cleanups
>> aa054bc partitions/efi: compare first and last usable LBAs
>> 27a7c64 partitions/efi: account for pmbr size in lba
>> b05ebbb partitions/efi: detect hybrid MBRs
>> 3e69ac3 partitions/efi: do not require gpt partition to begin at sector 1
>> 33afd7a partitions/efi: check pmbr record's starting lba
>> c2ebdc2 partitions/efi: use lba-aware partition records
>
> It would be good to bisect this :)
> I suspect it might be caused by 33afd7a otherwise there's something
> wrong with the mbr size in lba (6b02fa5+27a7c64).

So I found that (c2ebdc2 partitions/efi: use lba-aware partition
records) broke things but that breakage is short-lived.  Specifically
in c2ebdc2 we changed from looking at "part->start_sect" to
"part->start_sector", but "part->start_sect" is equivalent to
"part->starting_lba" in the new scheme.

...moving forward, I then found the next breakage was 27a7c64 and that
appears to be the culprit.  Adjusting to further changes on ToT, you
get a fix that looks roughly like:

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 1eb09ee..9df329d 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -226,7 +226,8 @@ check_hybrid:
        if (ret == GPT_MBR_PROTECTIVE) {
                sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
                if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
-                       ret = 0;
+                       pr_warn("%s sz=%u, total_sectors - 1=%u\n", __func__,
+                               sz, (uint32_t)((uint32_t) total_sectors - 1));
        }
 done:
        return ret;

Now, when I boot up I see messages like:

[    4.038359] is_pmbr_valid sz=4956095, total_sectors - 1=15523839
[    4.043963] GPT:Primary header thinks Alt. header is not at the end
of the disk.
[    4.043967] GPT:4956095 != 15523839
[    4.043969] GPT:Alternate GPT header not at the end of the disk.
[    4.043972] GPT:4956095 != 15523839
[    4.043975] GPT: Use GNU Parted to correct GPT errors.

...so basically it looks like we're now considering something an error
that used to be considered a warning.

I don't know __anything__ about how GPT is supposed to work and I'll
leave it to the experts to debate.  It always is possible that the
Chrome OS GPT is somehow wrong, but Bill Richardson (CCed) says he
thinks that what we're doing is OK and that the alternate header is
supposed to be a backup copy (and thus it should only be a warning if
it's missing).


> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 1eb09ee..d589937 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -157,10 +157,6 @@ static inline int pmbr_part_valid(gpt_mbr_record *part)
>         if (part->os_type != EFI_PMBR_OSTYPE_EFI_GPT)
>                 goto invalid;
>
> -       /* set to 0x00000001 (i.e., the LBA of the GPT Partition Header) */
> -       if (le32_to_cpu(part->starting_lba) != GPT_PRIMARY_PARTITION_TABLE_LBA)
> -               goto invalid;
> -
>         return GPT_MBR_PROTECTIVE;
>  invalid:
>         return 0;
>
>
> If this doesn't work, could you bypass mbr checks with force_gpt option
> and add some printk to the partition_record.size_in_lba, like:
>
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 1eb09ee..77cfed2 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -225,6 +225,7 @@ check_hybrid:
>          */
>         if (ret == GPT_MBR_PROTECTIVE) {
>                 sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
> +               printk("gpt sz check: %d, %ld\n", sz, total_sectors);
>                 if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
>                         ret = 0;
>         }

Just for thoroughness, I did try this patch (without my patch) and it
didn't work for me.



-Doug
