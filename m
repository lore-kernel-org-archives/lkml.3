Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3J0VWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:22:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab3J0VWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:22:18 -0400
Date: Sun, 27 Oct 2013 14:24:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131027212407.GA17439@kroah.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
 <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
 <CA+55aFyb72qoZ1Tjpb+=q-6+GmwoOXjfntY_zZnf300gg3d1Hg@mail.gmail.com>
 <CA+55aFxuVpDo3LvmG9j-Hu7sENLTcsB6_CY2TA4mE-k+CuTeGg@mail.gmail.com>
 <CA+55aFz9ewd7VhCKDxJUzY4PGH7E3N-xMr=pDGQxf1PyNd1W1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9ewd7VhCKDxJUzY4PGH7E3N-xMr=pDGQxf1PyNd1W1w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 09:13:29PM +0000, Linus Torvalds wrote:
> .. and one more case of freeing a delayed work object (likely a kobject again):
> 
> This time it looks like it's in the PCI layer, freeing the msi irq information.
> 
> It looks like that code simply does
> 
>     kobject_del(&entry->kobj);
>     kobject_put(&entry->kobj);
>     list_del(&entry->list);
>     kfree(entry);
> 
> and the problem is that the "entry->kobj" may have *other* references
> to it, thanks to people accessing it through /sys, so despite doing a
> kojbect_del/kobject_put(), it's not at all ok to then do a "kfree()"
> on it. The embedded kobj might still be in use.
> 
> Afaik, that code should do the kfree() on the kobject in the _release_
> method, not synchronously like that.
> 
> We already have a msi_kobj_release(), I'm wondering why that doesn't
> do the kfree().
> 
> Bjorn? Yinghai? Greg, comments about that msi kobj usage?

Ick, it really should be doing a kfree() in the release only.  Bjorn has
had a bunch of changes in this area recently, perhaps they are in
linux-next waiting for 3.13, and I've talked to him about getting rid of
all of the kobjects for msi files, as I don't think it's needed at all.

Bjorn, don't you have a fix for this problem already done somewhere?

thanks,

greg k-h
