Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbaCTQrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:47:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:33130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaCTQrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:47:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,695,1389772800"; 
   d="scan'208";a="502913935"
Message-ID: <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: hci_ldsic nested locking problem
From: Alan Cox <alan@linux.intel.com>
To: balbi@ti.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 20 Mar 2014 16:42:16 +0000
In-Reply-To: <20140320163435.GH32692@saruman.home>
References: <20140320163435.GH32692@saruman.home>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 11:34 -0500, Felipe Balbi wrote:
> Hi,
> 
> when 8250 driver calls uart_write_wakeup(), the tty port lock is already
> taken. hci_ldisc.c's implementation of ->write_wakeup() calls
> tty->ops->write() to actually send the characters, but that call will
> try to acquire the same port lock again.
> 
> Looking at other line disciplines that looks like a bug in hci_ldisc.c.
> Am I correct to assume that ->write_wakeup() is supposed to *just*
> wakeup the bottom half so we handle ->write() in another context ?
> 
> Is it legal to call tty->ops->write() from within ->write_wakeup() ?

It isn't because you might send all the bytes and go

	write
		write_wakeup
			write
				write wakeup
					...

and recurse

Alan


