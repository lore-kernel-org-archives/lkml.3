Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009Ab3BNWWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:22:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab3BNWWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:22:01 -0500
Date: Thu, 14 Feb 2013 14:21:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, davem@davemloft.net,
        Simon Horman <horms@verge.net.au>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: fix functions and variables related to
 netns_ipvs->sysctl_sync_qlen_max
Message-Id: <20130214142159.d0516a5f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1302070944480.1810@ja.ssi.bg>
References: <51131B88.6040809@cn.fujitsu.com>
	<51132A56.60906@cn.fujitsu.com>
	<alpine.LFD.2.00.1302070944480.1810@ja.ssi.bg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 10:40:26 +0200 (EET)
Julian Anastasov <ja@ssi.bg> wrote:

> > Another question about the sysctl_sync_qlen_max:
> > This variable is assigned as:
> > 
> > ipvs->sysctl_sync_qlen_max = nr_free_buffer_pages() / 32;
> > 
> > The function nr_free_buffer_pages actually means: counts of pages
> > which are beyond high watermark within ZONE_DMA and ZONE_NORMAL.
> > 
> > is it ok to be called here? Some people misused this function because
> > the function name was misleading them. I am sorry I am totally not
> > familiar with the ipvs code, so I am just asking you about
> > this.
> 
> 	Using nr_free_buffer_pages should be fine here.
> We are using it as rough estimation for the number of sync
> buffers we can use in NORMAL zones. We are using dev->mtu
> for such buffers, so it can take a PAGE_SIZE for a buffer.
> We are not interested in HIGHMEM size. high watermarks
> should have negliable effect. I'm even not sure whether
> we need to clamp it for systems with TBs of memory.

Using nr_free_buffer_pages() is good-enough-for-now.  There are
questions around the name of this thing and its exact functionality and
whether callers are using it appropriately.  But if anything is changed
there, it will be as part of kernel-wide sweep.

One thing to bear in mind is memory hot[un]plug.  Anything which was
sized using nr_free_buffer_pages() (or similar) may become
inappropriately sized if memory is added or removed.  So any site which
uses nr_free_buffer_pages() really should be associated with a hotplug
handler and a great pile of code to resize the structure at runtime. 
It's pretty ugly stuff :(  I suspect it usually Just Doesn't Matter.

Redarding this patch:
net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch and
net-fix-functions-and-variables-related-to-netns_ipvs-sysctl_sync_qlen_max.patch
are joined at the hip and should be redone as a single patch with a
suitable changelog, please.  And with a cc:netdev@vger.kernel.org.

