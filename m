Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3ANCIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:08:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3ANCId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:08:33 -0500
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] x86 e820: only void usable memory areas in memmap=exactmap case
Date: Mon, 14 Jan 2013 03:08:17 +0100
Message-ID: <2741365.qqWvlU8HGl@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQWNRS6rBzx+fbX+O9_L+Z-4T-oBWZUdzR0sS=P22ctZ0w@mail.gmail.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <4068140.Uym9gOXymC@hammer82.arch.suse.de> <CAE9FiQWNRS6rBzx+fbX+O9_L+Z-4T-oBWZUdzR0sS=P22ctZ0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 12, 2013 09:07:12 AM Yinghai Lu wrote:
> On Sat, Jan 12, 2013 at 3:31 AM, Thomas Renninger <trenn@suse.de> wrote:
> >         memmap=exactmap [KNL,X86] Enable setting of an exact
> > 
> > -                       E820 memory map, as specified by the user.
> > -                       Such memmap=exactmap lines can be constructed
> > based on -                       BIOS output or other requirements. See
> > the memmap=nn@ss -                       option description.
> > +                       E820 usable memory map, as specified by the user.
> > +                       All unusable (reserved, ACPI, NVS,...) ranges from
> > the +                       original e820 table are preserved.
> > +                       But the usable memory regions from the original
> > e820 +                       table are removed.
> > +                       This parameter is explicitly for kdump usage:
> > +                       The memory the kdump kernel is allowed to use must
> > +                       be passed via below memmap=nn[KMG]@ss[KMG] param.
> > +                       All reserved regions the kernel may use for
> > ioremapping +                       and similar are still considered.
> > +
> > +       memmap=voidmap  [KNL,X86] Do not use any e820 ranges from BIOS or
> > +                       bootloader. Instead you have to pass regions via
> > +                       below memmap= options.
> 
> I would suggest to keep memmap=exactmap meaning not changed, and add
> memmap=exactusablemap
> instead.
I disagree.
I would like to change memmap=exactmap behavior.

Why:
1)
This is a sever bug (for kdump/kexec). I could imagine quite a lot
kdump related bugs get silently solved by this fix.
I expect we agree that the change, however it looks like in the end, should
still get in in this kernel round?
With my approach, I would also suggest to spread this to stable kernels.
-> No need to update/patch kexec-tools, things will just work as they should.

2)
I would introduce 2 new memmap= options. However they look like, for example:
=void_usable_map
=void_orig_map
and deprecated exactmap= via
printk(KERN_INFO "exactmap usage changed and is deprecated\n");
but still fix it.
Latest kexec-tools will just use memmap=void_usable_map, old ones
are still fixed via stable kernel updates.


> kexec-tools could be updated to support exactusablemap with
> kernelversion checking for kdump.
No, please not. It will be a maintenance/compatibility issue that will remain
for years or ever in kdump and/or the kernel and it's not necessary.

> also we need to double check to make sure:
> 1. exactmap should override exactusablemap, even the out of order sequence.
So that one can override the whole map in kdump case (which was broken until
today)?
I agree. But in my case it would be:
=void_orig_map overrides =void_usable_map

> 2. when exactusablemap is used, not just remove old usable type range,
> also need to remove overlapped range
> with new usable range.
Why should this be necessary?
The e820 map passed by BIOS/bootloader should already be sanity checked
-> no overlaps.

Then usable ranges are removed and the memmap= defined are added and
sanity check is called again.
-> no overlaps.

Sanity checking prefers reserved/unusable memory ranges (in this case always 
using the original ones from BIOS) over usable ones and this is a good idea to 
do...

I guess it's up to further votes/comments/ideas and a final maintainer 
(kexec/x86?) decision?


    Thomas
