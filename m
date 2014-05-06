Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaEFNdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:33:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34278 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaEFNdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:33:49 -0400
Date: Tue, 6 May 2014 16:33:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgnc: fix compile warning frame size is larger
 than 1024 bytes
Message-ID: <20140506133326.GU26890@mwanda>
References: <1399380097-11908-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399380097-11908-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:41:37PM +0200, Martin Kepplinger wrote:
> fix following warning by dynamically allocating memory:
> dgnc_tty.c:583:1: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is more of a question. Is this a desired solution to fixing such a
> frame size warning?

This warning is because the kernel uses an 8k stack so you add up all
the stack memory used by each function from the syscall to here.  If
it adds up to more than 8k then it's a bug.  The 1k limit per function
is just a hack to spot where people are maybe being reckless.

There are no kfree()s and this function is called with a spin_lock held
so this patch introduces a couple bugs.

There may be a better way to allocate this.  Like maybe at probe() and
then use spinlocks to serialize access to the buffer.  But sometimes
that's a very bad idea.

It's better if you know the driver a bit and can test things.

regards,
dan carpenter

