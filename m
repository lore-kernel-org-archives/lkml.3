Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaCXLGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:06:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaCXLGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:06:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389715200"; 
   d="scan'208";a="9756477"
Message-ID: <53300F76.2060509@cn.fujitsu.com>
Date: Mon, 24 Mar 2014 18:56:54 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        miaox@cn.fujitsu.com, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: ensure access to ctx->ring_pages is correctly serialised
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com> <20140321183509.GC23173@kvack.org>
In-Reply-To: <20140321183509.GC23173@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:02:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:02:58,
	Serialize complete at 2014/03/24 19:02:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,
On 03/22/2014 02:35 AM, Benjamin LaHaise wrote:

> Hi all,
> 
> Based on the issues reported by Tang and Gu, I've come up with the an 
> alternative fix that avoids adding additional locking in the event read 
> code path.  The fix is to take the ring_lock mutex during page migration, 
> which is already used to syncronize event readers and thus does not add 
> any new locking requirements in aio_read_events_ring().  I've dropped 
> the patches from Tang and Gu as a result.  This patch is now in my 
> git://git.kvack.org/~bcrl/aio-next.git tree and will be sent to Linus 
> once a few other people chime in with their reviews of this change.  
> Please review Tang, Gu.  Thanks!

As I mentioned before:
https://lkml.org/lkml/2014/3/20/34
We can put put_aio_ring_file() at the first of the
context teardown flow (aio_free_ring). Then, page migration and ctx freeing
will have mutual execution guarded by lock_page() v.s. truncate().
So that, the additional spinlock(address_space's private_lock) used to
protect use and updates of the mapping's private_data, and the sane check
of context is needless, so does the additional percpu_ref_get/put(&ctx->users).
But the enlarge ring_lock protection region to remove the additional spin_lock
is an elegant method if we ignore the effect to reading events while migrating
page is going.

Thanks,
Gu

> 
> 		-ben


