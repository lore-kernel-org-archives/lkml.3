Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbaD3VT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:19:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaD3VTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:19:25 -0400
Date: Wed, 30 Apr 2014 14:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmapool: remove redundant NULL check for dev in
 dma_pool_create()
Message-Id: <20140430141924.8d84f7fdcac3ac3996802aa9@linux-foundation.org>
In-Reply-To: <20140429025310.GA5913@devel>
References: <20140429025310.GA5913@devel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 11:53:10 +0900 Daeseok Youn <daeseok.youn@gmail.com> wrote:

> "dev" cannot be NULL because it is already checked before
> calling dma_pool_create().
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
> If dev can be NULL, it has NULL deferencing when kmalloc_node()
> is called after enabling CONFIG_NUMA.

hm, this is unclear.

The code which handles the dev==NULL case was obviously put there
deliberately, presumably with the intention of permitting drivers to
call dma_pool_create() without a device*.  This code is very old.

A lot of drivers call dma_pool_create() (I doubt if you audited all of
them!) and perhaps there are some which use this feature and have never
been run on NUMA hardware.

I think I'll apply the patch anyway because such drivers (if they
exist) probably need some attending to.

I rewrote the changelog thusly:


: "dev" cannot be NULL because it is already checked before calling
: dma_pool_create().
: 
: If dev ever was NULL, the code would oops in dev_to_node() after enabling
: CONFIG_NUMA.
: 
: It is possible that some driver is using dev==NULL and has never been run
: on a NUMA machine.  Such a driver is probably outdated, possibly buggy and
: will need some attention if it starts triggering NULL derefs.

