Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab3JJW33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:29:29 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:42635 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3JJW3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
References: <20131009232642.GA12776@jtriplet-mobl1>
	<1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
	<CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com>
	<1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 10 Oct 2013 15:29:14 -0700
X-Google-Sender-Auth: AzMgplcXVVss5HUeC5WkEV_uKrs
Message-ID: <CAD=FV=U4eBWQ6y0Pc3gHa+9JMAKMAghJL6eQ2VWNLTkwF+036Q@mail.gmail.com>
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

On Thu, Oct 10, 2013 at 2:26 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> On Thu, 2013-10-10 at 13:15 -0700, Doug Anderson wrote:
>> Hi,
>>
>> Just ran into this same problem and tracked it down to the same
>> commit.  Luckily Sean found this thread.  :)
>>
>> On Wed, Oct 9, 2013 at 5:37 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>> > Hi Josh,
>> >
>> > On Wed, 2013-10-09 at 16:26 -0700, Josh Triplett wrote:
>> >> When testing ChromeOS with a 3.12 kernel from git, I encountered a
>> >> regression introduced between 3.11 to 3.12: at boot time, the kernel
>> >> failed to find any partitions on the USB disk I booted from, which uses
>> >> a GPT partition table with 12 partitions.  This prevented the system
>> >> from booting.
>> >>
>> >> Reverting all the patches to block/partitions/efi.c between 3.11 and
>> >> 3.12 allowed the system to detect partitions again.  The patches I
>> >> reverted:
>> >>
>> >> 6b02fa5 partitions/efi: loosen check fot pmbr size in lba
>> >> b4bc4a1 block/partitions/efi.c: consistently use pr_foo()
>> >> 70f637e partitions/efi: some style cleanups
>> >> aa054bc partitions/efi: compare first and last usable LBAs
>> >> 27a7c64 partitions/efi: account for pmbr size in lba
>> >> b05ebbb partitions/efi: detect hybrid MBRs
>> >> 3e69ac3 partitions/efi: do not require gpt partition to begin at sector 1
>> >> 33afd7a partitions/efi: check pmbr record's starting lba
>> >> c2ebdc2 partitions/efi: use lba-aware partition records
>> >
>> > It would be good to bisect this :)
>> > I suspect it might be caused by 33afd7a otherwise there's something
>> > wrong with the mbr size in lba (6b02fa5+27a7c64).
>>
>> So I found that (c2ebdc2 partitions/efi: use lba-aware partition
>> records) broke things but that breakage is short-lived.  Specifically
>> in c2ebdc2 we changed from looking at "part->start_sect" to
>> "part->start_sector", but "part->start_sect" is equivalent to
>> "part->starting_lba" in the new scheme.
>
> Right, because we're not using CHS addressing anymore for GPT. What do
> you mean by "breakage is short-lived"? I didn't quite get that.

Sorry, it's "short-lived" because the CLs right after this effectively
change it back to looking at "starting_lba" again.


>> ...moving forward, I then found the next breakage was 27a7c64 and that
>> appears to be the culprit.  Adjusting to further changes on ToT, you
>> get a fix that looks roughly like:
>>
>> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
>> index 1eb09ee..9df329d 100644
>> --- a/block/partitions/efi.c
>> +++ b/block/partitions/efi.c
>> @@ -226,7 +226,8 @@ check_hybrid:
>>         if (ret == GPT_MBR_PROTECTIVE) {
>>                 sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>>                 if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
>> -                       ret = 0;
>> +                       pr_warn("%s sz=%u, total_sectors - 1=%u\n", __func__,
>> +                               sz, (uint32_t)((uint32_t) total_sectors - 1));
>>         }
>>  done:
>>         return ret;
>>
>> Now, when I boot up I see messages like:
>>
>> [    4.038359] is_pmbr_valid sz=4956095, total_sectors - 1=15523839
>
> Hmmm, this confuses me: sz represents the size of the disk and should be
> equal to total_sectors - 1 (aka lastlba) in this case, and since you're
> not using the whole 2Tb disk limit, so it'll never be 0xFFFFFFFF....
>
>> [    4.043963] GPT:Primary header thinks Alt. header is not at the end
>> of the disk.
>> [    4.043967] GPT:4956095 != 15523839
>
> but in reality, sz is equal to where the primary GPT header thinks the
> alternate header is (pgpt->alternate_lba):
>
>         if (le64_to_cpu(pgpt->alternate_lba) != lastlba) {
>                 pr_warn("GPT:Primary header thinks Alt. header is not at the end of the disk.\n");
>                 pr_warn("GPT:%lld != %lld\n",
>                         (unsigned long long)le64_to_cpu(pgpt->alternate_lba),
>                         (unsigned long long)lastlba);
>                 error_found++;
>         }
>
>> [    4.043969] GPT:Alternate GPT header not at the end of the disk.
>> [    4.043972] GPT:4956095 != 15523839
>> [    4.043975] GPT: Use GNU Parted to correct GPT errors.
>
> At least the backup/alternate GPT header is consistent with the above:
> 4956095 == pgpt->alternate_lba == agpt->my_lba
>
> But sz shouldn't be 4956095... strange.
>
> Do you happen to know what tool was used to create the GPT partition(s)?
> I ask because it is up to the partitioning program to set sz correctly,
> and most if not all set it to either the disk size - 1 or 0xFFFFFFFF.

See Bill's email.  It was created using "cgpt" to create a binary
file, which was then "dd"ed onto removable media.


FWIW, I can "fix" my problems also by tweaking my image:

setword.py /.../chromiumos_test_image.bin 0x1ca 0xffffffff
0x000001ca: 0x004b9fbf => 0xffffffff

Now things boot up nicely.  :)  Similarly I can get things to boot by running:

cgpt boot -p /dev/mmcblk1

...which appears to put the right size into this field.


>> ...so basically it looks like we're now considering something an error
>> that used to be considered a warning.
>
> It simply wasn't checked before.
>
> It's worthwhile finding out if this scenario also occurs without the
> recent GPT changes. If so, then we could go ahead and just use a warning
> and not consider it an error for the sake of booting. Otherwise there's
> something wrong with c2ebdc2 and replacing 'struct partition' with
> 'struct _gpt_mbr_record' caused some sort of structure offset problem
> and some fields are holding the wrong data.
>
> To check this, you can revert all patches, starting from c2ebdc2, then
> add the following (untested) to pmbr_part_valid():
>
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index c85fc89..7144d8a 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -152,6 +152,8 @@ static u64 last_lba(struct block_device *bdev)
>  static inline int
>  pmbr_part_valid(struct partition *part)
>  {
> +       printk("part->nr_sects = %d\n", le32_to_cpu(part->nr_sects));
> +
>          if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
>              le32_to_cpu(part->start_sect) == 1UL)
>                  return 1;
>
> Thanks,
> Davidlohr

I can run this test if you need, but it sounds like we're tracked it
down pretty well.


My dumb summary of this without digging and understanding everything is:

* It used to be "OK" if the sz was wrong.

* If you're "dd"ing an image from a smaller device to a bigger device,
the "sz" will likely be wrong.  It would be nice if this were a
warning not an error since this can be a useful thing to do.

* We could fix our tool to not specify "sz" (aka use "-1") when
creating our images and it would work.

* This is not exactly the same as the GPT/alternate GPT error, since
it's a different header field.


Does that sound reasonable?

-Doug
