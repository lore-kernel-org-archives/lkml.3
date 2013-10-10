Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3JJVx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:53:56 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:41961 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab3JJVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
References: <20131009232642.GA12776@jtriplet-mobl1> <1381365455.2297.14.camel@buesod1.americas.hpqcorp.net>
 <CAD=FV=UD2TDBVrQeC4862WQwKG32723mG0D4e1qrzVHF9+koFg@mail.gmail.com> <1381440403.2367.32.camel@buesod1.americas.hpqcorp.net>
From: Bill Richardson <wfrichar@chromium.org>
Date: Thu, 10 Oct 2013 14:53:30 -0700
X-Google-Sender-Auth: niWBSmWmK8tw8hSFx_4Psg9psMA
Message-ID: <CAEgFheKsx+gKZa76333m4C-gPbEy2AFSVA3mCNR8HjaLFNb1Ww@mail.gmail.com>
Subject: Re: Regression parsing GPT (EFI) partition tables
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm about to go offline for a week, but here are some thoughts.

The GPT spec is over-constrained. It says that the secondary GPT
header must be in the last LBA of the disk, yet it also says that both
primary and secondary headers must point to each other using their
AlternateLBA fields. We don't need both of those rules - and the spec
is unclear what it means if the headers *don't* point to each other,
or if they do but from the wrong place.

Chrome OS install images are created in a binary file, so the ending
LBAs are just the last LBA in the binary image, and that's where the
primary GPT header's AlternateLBA field points. When we dd that image
onto a USB or SD card and boot it, the secondary GPT header is not at
the end of the disk. The primary GPT header is otherwise valid, so we
boot it anyway and the chromeos-install process creates valid primary
and secondary headers (with cross-pointing AlternateLBA fields) on the
fixed drive.

That bootable binary image does have a protective MBR (partition type
0xEE), but again the extent of it is only that of the original binary,
not the USB drive it was copied onto.

Chrome OS BIOS pays no attention *at all* to the legacy MBR, or to the
AlternateLBA fields of either GPT header. It only looks for the GPT
headers in LBA 1 and LBA <last>.

The tool that we use to create the partition tables is called "cgpt". To build:

git clone https://chromium.googlesource.com/chromiumos/platform/vboot_reference
cd vboot_reference
make
./build/cgpt/cgpt help

We wrote cgpt ourselves because we wanted to use the same small
GPT-aware library in the BIOS that we use to create and test disk
images.


Bill
-- 
Art for Art's Sake
Engineering for Money
