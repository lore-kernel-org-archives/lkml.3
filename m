Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbaCNSxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:53:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52239 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaCNSxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:53:21 -0400
Date: Fri, 14 Mar 2014 18:53:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 1/5][RFC][CFT] percpu fixes, part 1
Message-ID: <20140314185320.GO18016@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
 <20140305034919.GA26528@ZenIV.linux.org.uk>
 <20140306192026.GA14033@htj.dyndns.org>
 <20140306203030.GA18016@ZenIV.linux.org.uk>
 <20140306204726.GE14033@htj.dyndns.org>
 <20140307025206.GB18016@ZenIV.linux.org.uk>
 <20140314184545.GA29750@ZenIV.linux.org.uk>
 <20140314184745.GC6889@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314184745.GC6889@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:47:45PM -0400, Tejun Heo wrote:
> On Fri, Mar 14, 2014 at 06:45:45PM +0000, Al Viro wrote:
> > There's a missing piece in 2/3 (percpu: store offsets instead of lengths in
> > ->map[]) - we need to round size up to multiple of 2 in pcpu_alloc().
> > Updated patch follows; if you want an incremental instead of replacement -
> > please, yell.
> 
> Yeah, I'd prefer an incremental patch.  Also, can you please update
> the comment above alignment / size updates with a bit more detail?
> 
> Thanks!

Done; incremental follows:

diff --git a/mm/percpu.c b/mm/percpu.c
index 5bb658a..65cab3b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -713,11 +713,14 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved)
 
 	/*
 	 * We want the lowest bit of offset available for in-use/free
-	 * indicator.
+	 * indicator, so force >= 16bit alignment and make size even.
 	 */
 	if (unlikely(align < 2))
 		align = 2;
 
+	if (unlikely(size & 1))
+		size++;
+
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
