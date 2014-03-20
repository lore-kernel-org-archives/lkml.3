Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642AbaCTQaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:30:07 -0400
Received: from kanga.kvack.org ([205.233.56.17]:39831 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbaCTQaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:30:05 -0400
Date: Thu, 20 Mar 2014 12:30:04 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Dave Jones <davej@redhat.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] aio: fix the confliction of read events and migrating ring page
Message-ID: <20140320163004.GE28970@kvack.org>
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320143207.GA3760@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 10:32:07AM -0400, Dave Jones wrote:
> On Thu, Mar 20, 2014 at 01:46:25PM +0800, Gu Zheng wrote:
> 
>  > diff --git a/fs/aio.c b/fs/aio.c
>  > index 88ad40c..e353085 100644
>  > --- a/fs/aio.c
>  > +++ b/fs/aio.c
>  > @@ -319,6 +319,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>  >  	ctx->ring_pages[old->index] = new;
>  >  	spin_unlock_irqrestore(&ctx->completion_lock, flags);
>  >  
>  > +	/* Ensure read event is completed before putting old page */
>  > +	mutex_lock(&ctx->ring_lock);
>  > +	mutex_unlock(&ctx->ring_lock);
>  >  	put_page(old);
>  >  
>  >  	return rc;
> 
> This looks a bit weird. Would using a completion work here ?

Nope.  This is actually the most elegant fix I've seen for this approach, 
as everything else has relied on adding additional spin locks (which only 
end up being needed in the migration case) around access to the ring_pages 
on the reader side.  That said, this patch is not a complete solution to 
the problem, as the update of the ring's head pointer could still get lost 
with this patch.  I think the right thing is just taking the ring_lock 
mutex over the entire page migration operation.  That should be safe, as 
nowhere else is the ring_lock mutex nested with any other locks.

		-ben

> 	Dave

-- 
"Thought is the essence of where you are now."
