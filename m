Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3HFWjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:39:42 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2903 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3HFWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:39:41 -0400
Message-ID: <1375828777.2134.28.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/8] partitions/efi: detect hybrid mbrs
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>,
        Jim Hull <jim.hull@hp.com>, Karel Zak <kzak@redhat.com>,
        Peter Jones <pjones@redhat.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>, linux-kernel@vger.kernel.org
Date: Tue, 06 Aug 2013 15:39:37 -0700
In-Reply-To: <20130806141603.948961cecfc9426aeee7c083@linux-foundation.org>
References: <1375766476-4204-1-git-send-email-davidlohr@hp.com>
	 <20130806141603.948961cecfc9426aeee7c083@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 14:16 -0700, Andrew Morton wrote:
> On Mon,  5 Aug 2013 22:21:08 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > This patchset teaches the kernel about hybrid master boot records (MBRs), one of
> > the most common issues with GUID partition tables, as a workaround to layout
> > disk partitions to be compatible with both EFI and legacy MBR based systems.
> > Except for adding more pmbr checks, to better comply with the UEFI/GPT specs, the
> > functionality is left unchanged - we only inform (through debug) the user about
> > the used MBR scheme. While it is true that these restrictions can be bypassed when
> > forcing gpt, this is not the correct or default way of doing things, complicating
> > users furthermore. More details are in the individual patches.
> 
> Patches look nice, although I'll cheerily admit to not having a clue
> what they do.  What is a "hybrid MBR" anyway?

Not having to know about hybrid MBRs is actually a good thing, they can
be quite a pain :)

I tried to explain more carefully what this particular MBR scheme is,
why it exists and why we cannot do anything about it in patch 5, but
perhaps it wasn't left clear and should have been in the cover letter as
well. Here's a brief summary:

EFI's GPT disklabels present a number of benefits to the traditional MBR
such as not having to deal with CHS addressing, better data integrity
(including a backup header) and 64bit LBA addressing (which allows
partitions to go beyond the 2Tb limit all the way up to 9.4 Zb), among
others. These nice features don't come free, however, having to deal
with older legacy systems (normally BIOS-based) that only use MBR, and
do not know about GPT. For example, users (like myself), who have an EFI
system (say a mac), dual booting with an older, non-EFI version of
Windows. While OSX knows GPT and uses the GPT partition(s), Windows
doesn't, so I cannot dual boot without creating a hybrid MBR - the
standard protective MBR (pMBR) won't allow Windows to boot. This hybrid
MBR will extend the regular pMBR (containing a 0xEE GPT partition) so
that it contains up to three primary partitions that point to the same
disk locations that the GPT partitions point to.

Hybrid MBRs are *unofficial* workarounds to the GPT specs, but necessary
for backward compatibility. Furthermore, most bootloaders are now
acknowledging this kind of scheme.

These patches only detect these configurations, and it's important that
the kernel can differentiate between hybrid and protective MBRs to
better detect correctly built pMBRs.

> Someone's editor seems to replace tabs with spaces so the patches
> generate quite a checkpatch storm.  Please use checkpatch.

Sorry, will do so in the future. I guess all patches from me have this
problem.

Thanks,
Davidlohr

