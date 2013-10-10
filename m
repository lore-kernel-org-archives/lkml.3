Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab3JJWtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:49:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17065 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3JJWtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:49:17 -0400
Message-ID: <1381445356.2367.52.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Regression parsing GPT (EFI) partition tables
From: Davidlohr Bueso <davidlohr@hp.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>
Date: Thu, 10 Oct 2013 15:49:16 -0700
In-Reply-To: <CAD=FV=U4eBWQ6y0Pc3gHa+9JMAKMAghJL6eQ2VWNLTkwF+036Q@mail.gmail.com>
References: <20131009232642.GA12776@jtriplet-mobl1>
	 <1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
	 <CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com>
	 <1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
	 <CAD=FV=U4eBWQ6y0Pc3gHa+9JMAKMAghJL6eQ2VWNLTkwF+036Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 15:29 -0700, Doug Anderson wrote:
> Hi,
[...]
> > Do you happen to know what tool was used to create the GPT partition(s)?
> > I ask because it is up to the partitioning program to set sz correctly,
> > and most if not all set it to either the disk size - 1 or 0xFFFFFFFF.
> 
> See Bill's email.  It was created using "cgpt" to create a binary
> file, which was then "dd"ed onto removable media.
> 
> 
> FWIW, I can "fix" my problems also by tweaking my image:
> 
> setword.py /.../chromiumos_test_image.bin 0x1ca 0xffffffff
> 0x000001ca: 0x004b9fbf => 0xffffffff
> 
> Now things boot up nicely.  :)  Similarly I can get things to boot by running:

Right, now sz == 0xffffffff so you're "using" the whole disk, but you
probably want 0xecdfff since the disk is smaller than that.

> 
> cgpt boot -p /dev/mmcblk1
> 
> ...which appears to put the right size into this field.
> 
> 
> >> ...so basically it looks like we're now considering something an error
> >> that used to be considered a warning.
> >
> > It simply wasn't checked before.
> >
> > It's worthwhile finding out if this scenario also occurs without the
> > recent GPT changes. If so, then we could go ahead and just use a warning
> > and not consider it an error for the sake of booting. Otherwise there's
> > something wrong with c2ebdc2 and replacing 'struct partition' with
> > 'struct _gpt_mbr_record' caused some sort of structure offset problem
> > and some fields are holding the wrong data.
> >
> > To check this, you can revert all patches, starting from c2ebdc2, then
> > add the following (untested) to pmbr_part_valid():
> >
> > diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> > index c85fc89..7144d8a 100644
> > --- a/block/partitions/efi.c
> > +++ b/block/partitions/efi.c
> > @@ -152,6 +152,8 @@ static u64 last_lba(struct block_device *bdev)
> >  static inline int
> >  pmbr_part_valid(struct partition *part)
> >  {
> > +       printk("part->nr_sects = %d\n", le32_to_cpu(part->nr_sects));
> > +
> >          if (part->sys_ind == EFI_PMBR_OSTYPE_EFI_GPT &&
> >              le32_to_cpu(part->start_sect) == 1UL)
> >                  return 1;
> >
> > Thanks,
> > Davidlohr
> 
> I can run this test if you need, but it sounds like we're tracked it
> down pretty well.
> 
> 
> My dumb summary of this without digging and understanding everything is:
> 
> * It used to be "OK" if the sz was wrong.

Yes, because it was never checked.

> 
> * If you're "dd"ing an image from a smaller device to a bigger device,
> the "sz" will likely be wrong.  It would be nice if this were a
> warning not an error since this can be a useful thing to do.
> 
> * We could fix our tool to not specify "sz" (aka use "-1") when
> creating our images and it would work.

You should use force_gpt and forget about MBR all together.

> 
> * This is not exactly the same as the GPT/alternate GPT error, since
> it's a different header field.
> 
> 
> Does that sound reasonable?
> 

Since it used to work before, I blame my change and it's a regression,
I'll happily ack the "warn instead of not recognizing approach".

Thanks,
Davidlohr


