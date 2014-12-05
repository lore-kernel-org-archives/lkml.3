Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaLEIYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:24:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:58802 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaLEIYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:24:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,521,1413270000"; 
   d="scan'208";a="633105508"
Date: Fri, 5 Dec 2014 10:24:29 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-spi@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx: Clear cur_chip pointer before starting next
 message
Message-ID: <20141205082429.GF1306@lahna.fi.intel.com>
References: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
 <87egsfyvsd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87egsfyvsd.fsf@free.fr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:01:06PM +0100, Robert Jarzmik wrote:
> Mika Westerberg <mika.westerberg@linux.intel.com> writes:
> 
> > Once the current message is finished, the driver notifies SPI core about
> > this by calling spi_finalize_current_message(). This function queues next
> > message to be transferred. If there are more messages in the queue, it is
> > possible that the driver is asked to transfer the next message at this
> > point.
> >
> > When spi_finalize_current_message() returns the driver clears the
> > drv_data->cur_chip pointer to NULL. The problem is that if the driver
> > already started the next message clearing drv_data->cur_chip will cause
> > NULL pointer dereference which crashes the kernel like:
> ..zip..
> > Fix this by clearing drv_data->cur_chip before we call
> > spi_finalize_current_message().
> 
> So with your change, we have :
>   	drv_data->cur_chip = NULL;
> 	spi_finalize_current_message(drv_data->master);
> 
> In that case, if spi_finalize_current_message() queues another message, upon
> this next message completion, won't giveback() be called, and dereference
> cur_chip as well ?

When the next message is started pxa2xx_spi_transfer_one_message() gets
called and that will set cur_chip again.
