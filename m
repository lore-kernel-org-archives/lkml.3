Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaHMOCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:02:25 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37512 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaHMOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:02:22 -0400
Date: Wed, 13 Aug 2014 15:02:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140813140219.GP15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug, at 09:43:32PM, Mantas Mikulėnas wrote:
> On Sun, Aug 10, 2014 at 8:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
> >> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt@console-pimps.org> wrote:
> >> [However... Whether it's five chunks, four (after making the initrd
> >> smaller), or just one (with your efi=nochunk), I noticed that it
> >> *always* hangs during the *last* read, and the allocated memory always
> >> ends at roughly the same address (0x137fffXXX). I wonder if it's
> >> selecting a memory location already in use, or something like that...]
> >>
> >> (The laptop is Asus K52JT, AMI firmware v206, no updates available.)
> >
> > wonder if  efi_file_read return with wrong chunksize.
> >
> > Can you try attached patch ?
> 
> Thanks, but it didn't change anything.
> 
> (I tried adding some efi_printk's, and as far as I can see,
> efi_file_read *doesn't* return at all.)

Could you send you revert Yinghai's commit locally and send the dmesg
from a successful boot? I'm wondering what other regions are around the
0x137fffxxx area.

One other thing to attempt would be to progressively try higher and
higher max memory addresses to read into to see if we can correlate your
hang with a particular region, i.e. this code,


	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
		initrd_addr_max = -1UL;
	else
		initrd_addr_max = hdr->initrd_addr_max;

	status = efi_parse_options(cmdline_ptr);
	if (status != EFI_SUCCESS)
		goto fail2;

	status = handle_cmdline_files(sys_table, image,
				      (char *)(unsigned long)hdr->cmd_line_ptr,
				      "initrd=", initrd_addr_max,
				      &ramdisk_addr, &ramdisk_size);


-- 
Matt Fleming, Intel Open Source Technology Center
