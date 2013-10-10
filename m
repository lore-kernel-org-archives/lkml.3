Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab3JJWbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:31:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6736 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab3JJWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:31:18 -0400
Message-ID: <1381444274.2367.44.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Regression parsing GPT (EFI) partition tables
From: Davidlohr Bueso <davidlohr@hp.com>
To: Bill Richardson <wfrichar@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>
Date: Thu, 10 Oct 2013 15:31:14 -0700
In-Reply-To: <CAEgFheKsx+gKZa76333m4C-gPbEy2AFSVA3mCNR8HjaLFNb1Ww@mail.gmail.com>
References: <20131009232642.GA12776@jtriplet-mobl1>
	 <1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
	 <CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com>
	 <1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
	 <CAEgFheKsx+gKZa76333m4C-gPbEy2AFSVA3mCNR8HjaLFNb1Ww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 14:53 -0700, Bill Richardson wrote:
> I'm about to go offline for a week, but here are some thoughts.
> 
> The GPT spec is over-constrained. It says that the secondary GPT
> header must be in the last LBA of the disk, yet it also says that both
> primary and secondary headers must point to each other using their
> AlternateLBA fields. We don't need both of those rules - and the spec
> is unclear what it means if the headers *don't* point to each other,
> or if they do but from the wrong place.
> 

I completely agree. But I'm concerned about the size of lba, and not the
primary/backup header differences.

> Chrome OS install images are created in a binary file, so the ending
> LBAs are just the last LBA in the binary image, and that's where the
> primary GPT header's AlternateLBA field points. When we dd that image
> onto a USB or SD card and boot it, the secondary GPT header is not at
> the end of the disk. The primary GPT header is otherwise valid, so we
> boot it anyway and the chromeos-install process creates valid primary
> and secondary headers (with cross-pointing AlternateLBA fields) on the
> fixed drive.
> 
> That bootable binary image does have a protective MBR (partition type
> 0xEE), but again the extent of it is only that of the original binary,
> not the USB drive it was copied onto.

Ahh, now that makes a whole lot of sense for this problem. That's why
your size in lba is the same as the backup gpt lba. All in all you're
using the binary file as your "whole disk", instead of the actual disk
itself, so while this is a very out of the ordinary configuration, it is
constant for GPT: this way size in lba == last lba for the _file_.

> 
> Chrome OS BIOS pays no attention *at all* to the legacy MBR, or to the
> AlternateLBA fields of either GPT header. It only looks for the GPT
> headers in LBA 1 and LBA <last>.

Then you should *really* use the force_gpt option, which is there to
bypass any MBR checks, and you can avoid issues like this :) 

Anyway, this is still a regression and I believe we can go ahead and
just warn the user about the case instead of not recognizing the disk.

Bill/Doug, care to send a formal patch (with corresponding comments)?

Thanks,
Davidlohr

