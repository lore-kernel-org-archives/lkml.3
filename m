Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaA3Km5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:42:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaA3Km4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:42:56 -0500
Date: Thu, 30 Jan 2014 11:42:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Denis Kirjanov <kda@linux-powerpc.org>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH driver-core-linus] kernfs: make kernfs_deactivate() honor
 KERNFS_LOCKDEP flag
In-Reply-To: <20140129170403.GJ30842@htj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1401301142060.31013@pobox.suse.cz>
References: <CAOJe8K20xx3o7HXH3E4pE3=G4pQ-nUf4LYF6sEwy5wYQE23+AA@mail.gmail.com> <Pine.LNX.4.44L0.1401291134070.11997-100000@netrider.rowland.org> <20140129170403.GJ30842@htj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Tejun Heo wrote:

> kernfs_deactivate() forgot to check whether KERNFS_LOCKDEP is set
> before performing lockdep annotations and ends up feeding
> uninitialized lockdep_map to lockdep triggering warning like the
> following on USB stick hotunplug.
> 
>  usb 1-2: USB disconnect, device number 2
>  INFO: trying to register non-static key.
>  the code is fine but needs lockdep annotation.
>  turning off the locking correctness validator.
>  CPU: 1 PID: 62 Comm: khubd Not tainted 3.13.0-work+ #82
>  Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
>   ffff880065ca7f60 ffff88013a4ffa08 ffffffff81cfb6bd 0000000000000002
>   ffff88013a4ffac8 ffffffff810f8530 ffff88013a4fc710 0000000000000002
>   ffff880100000000 ffffffff82a3db50 0000000000000001 ffff88013a4fc710
>  Call Trace:
>   [<ffffffff81cfb6bd>] dump_stack+0x4e/0x7a
>   [<ffffffff810f8530>] __lock_acquire+0x1910/0x1e70
>   [<ffffffff810f931a>] lock_acquire+0x9a/0x1d0
>   [<ffffffff8127c75e>] kernfs_deactivate+0xee/0x130
>   [<ffffffff8127d4c8>] kernfs_addrm_finish+0x38/0x60
>   [<ffffffff8127d701>] kernfs_remove_by_name_ns+0x51/0xa0
>   [<ffffffff8127b4f1>] remove_files.isra.1+0x41/0x80
>   [<ffffffff8127b7e7>] sysfs_remove_group+0x47/0xa0
>   [<ffffffff8127b873>] sysfs_remove_groups+0x33/0x50
>   [<ffffffff8177d66d>] device_remove_attrs+0x4d/0x80
>   [<ffffffff8177e25e>] device_del+0x12e/0x1d0
>   [<ffffffff819722c2>] usb_disconnect+0x122/0x1a0
>   [<ffffffff819749b5>] hub_thread+0x3c5/0x1290
>   [<ffffffff810c6a6d>] kthread+0xed/0x110
>   [<ffffffff81d0a56c>] ret_from_fork+0x7c/0xb0
> 
> Fix it by making kernfs_deactivate() perform lockdep annotations only
> if KERNFS_LOCKDEP is set.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Fabio Estevam <festevam@gmail.com>
> Reported-by: Alan Stern <stern@rowland.harvard.edu>

I reported it here:

	https://lkml.org/lkml/2014/1/22/217

The patch fixes it for me as well.

Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
