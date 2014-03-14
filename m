Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaCNPOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:14:47 -0400
Received: from kanga.kvack.org ([205.233.56.17]:58362 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNPOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:14:46 -0400
Date: Fri, 14 Mar 2014 11:14:46 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, viro@zeniv.linux.org.uk,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
Message-ID: <20140314151446.GE29206@kvack.org>
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com> <20140311184656.GD16433@kvack.org> <531FEFC6.50709@cn.fujitsu.com> <20140312221735.GF32444@kvack.org> <5322D90C.5050207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5322D90C.5050207@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

On Fri, Mar 14, 2014 at 06:25:16PM +0800, Gu Zheng wrote:
> Hi Ben,
> On 03/13/2014 06:17 AM, Benjamin LaHaise wrote:
> 
> > Hello Tang,
> > 
> > On Wed, Mar 12, 2014 at 01:25:26PM +0800, Tang Chen wrote:
> > ... <snip> ...
> > 
> >>> Another spot is in
> >>> aio_read_events_ring() where head and tail are fetched from the ring 
> >>> without
> >>> any locking.  I also fear we'll be introducing new performance issues with
> >>> all the additonal spinlock bouncing, despite the fact that is only ever
> >>> needed for migration.  I'm going to continue looking into this today and
> >>> will try to send out a followup to this email later.
> >>
> >> In the beginning of aio_read_events_ring(), it reads head and tail, not 
> >> write.
> >> So even if ring pages are migrated, the contents of the pages will not 
> >> be changed.
> >> So reading it is OK, from old page or from the new page, I think.
> > 
> > Your assumption that reading it is okay is incorrect.  Since we do not have 
> > a reference on the page at that point, it is possible that the read of the 
> > page takes place after the page has been freed and allocated to another part 
> > of the kernel.  This would result in the read returning invalid information.
> 
> What about the following patch? It adds additional reference to protect the page
> avoid being freed when we reading it.
> ps.It is applied on linux-next(3-13).

I think that's even worse than the spinlock approach since we'll end up 
bouncing around the struct page's cacheline in addition to spinlock we're 
going to end up taking anyways.

		-ben
-- 
"Thought is the essence of where you are now."
