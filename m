Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaEZKys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 06:54:48 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58588 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaEZKyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 06:54:47 -0400
Date: Mon, 26 May 2014 06:54:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: remove the unneeded cpu_relax() in
 __queue_work()
Message-ID: <20140526105443.GA5555@mtj.dyndns.org>
References: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>
 <20140522134758.GA5065@htj.dyndns.org>
 <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com>
 <20140526042311.GA14432@htj.dyndns.org>
 <5382D0DB.1000907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5382D0DB.1000907@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 01:27:55PM +0800, Lai Jiangshan wrote:
> changing pwq:
> 	install pwq
> 	lock(pool->lock)
> 	put_pwq();
> 	unlock(pool->lock)
> 
> __queue_work():
> 	lock(pool->lock)
> 	test ref and find it zero;
> 	see the installation here;
> 	it is guaranteed to get the installed pwq on the immediate next try.
> 	unlock()
> 	retry.

The fact that pool->lock locking happens to provide enough barrier for
the above to work is an accidental implementation detail.  We
theoretically can move refcnting out of pool->lock.  Nothing
semantically guarantees that barrier to be there to interlock pwq
qinstallation and the last put.  Removing that cpu_relax() doesn't buy
us *ANYTHING* and removing that with rationale of making it go faster
would easily win pointless micro optimization award of the year.  Just
let it go.

-- 
tejun
