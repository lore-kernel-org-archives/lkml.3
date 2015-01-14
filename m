Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbbANOru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:47:50 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:42621 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbbANOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:47:48 -0500
Date: Wed, 14 Jan 2015 09:47:44 -0500
From: Tejun Heo <tj@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_eh_report() unable to handle kernel NULL pointer dereference
Message-ID: <20150114144744.GF3565@htj.dyndns.org>
References: <20150113142509.GA985@swordfish>
 <20150113152738.GC2976@htj.dyndns.org>
 <20150114143033.GA23906@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114143033.GA23906@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:30:33PM +0900, Sergey Senozhatsky wrote:
> On (01/13/15 10:27), Tejun Heo wrote:
> > On Tue, Jan 13, 2015 at 11:25:09PM +0900, Sergey Senozhatsky wrote:
> > > Hi,
> > > 
> > > linux-next 20150112
> > > 
> > > [  934.572323] ata2: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
> > > [  934.572329] ata2: irq_stat 0x00400040, connection status changed
> > > [  934.572332] ata2: SError: { HostInt PHYRdyChg 10B8B DevExch }
> > > [  934.572341] BUG: unable to handle kernel NULL pointer dereference at 0000000000000460
> > > [  934.572346] IP: [<ffffffff812c722c>] ata_eh_report+0x3ad/0x74d
> > 
> > Any chance you can run addr2line on it and map it to the source line?
> >
> 
> Hello,
> 
> sorry for the delay, emails from my android gmail app are blocked as "outlook
> spam".
> 
> here it is in reverse order, RIP is the last one.
> 
> ~/_next$ addr2line -e vmlinux -i ffffffff812c97a3
>    _next/drivers/ata/libata-eh.c:4020
> ~/_next$ addr2line -e vmlinux -i ffffffff812cfb7e
>    _next/drivers/ata/libahci.c:1438
> ~/_next$ addr2line -e vmlinux -i ffffffff812cf943
>    _next/drivers/ata/libahci.c:1470
> ~/_next$ addr2line -e vmlinux -i ffffffff812cfb7e
>    _next/drivers/ata/libahci.c:1438
> ~/_next$ addr2line -e vmlinux -i ffffffff812d0bab
>    _next/drivers/ata/libahci.c:1383
> ~/_next$ addr2line -e vmlinux -i ffffffff812c05c0
>    _next/include/linux/libata.h:1085
>    _next/drivers/ata/libata-core.c:3715
> ~/_next$ addr2line -e vmlinux -i ffffffff812c96e5
>    _next/drivers/ata/libata-eh.c:3991
> ~/_next$ addr2line -e vmlinux -i ffffffff812c722c
>    _next/drivers/ata/libata-eh.c:2485
>    _next/drivers/ata/libata-eh.c:2583

Ah, the culprit is cbba5b0ee4c6 ("libata: use
__scsi_format_command()") which moved qc->dev->cdb_len deref to before
the loop verifies the qc is valid.

Hannes, I think the right thing to do is moving that variable
declaration inside the if (ata_is_atapi()) block.  Can you please take
care of it?

Thanks a lot.

-- 
tejun
