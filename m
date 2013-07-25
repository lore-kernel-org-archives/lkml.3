Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3GYVuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:50:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50932 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3GYVum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:50:42 -0400
Date: Thu, 25 Jul 2013 17:50:33 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        righi.andrea@gmail.com
Subject: Re: [patch 3/5] x86: finish fault error path with fatal signal
Message-ID: <20130725215033.GP715@cmpxchg.org>
References: <20130714015112.FFCB7AF7@pobox.sk>
 <20130715154119.GA32435@dhcp22.suse.cz>
 <20130715160006.GB32435@dhcp22.suse.cz>
 <20130716153544.GX17812@cmpxchg.org>
 <20130716160905.GA20018@dhcp22.suse.cz>
 <20130716164830.GZ17812@cmpxchg.org>
 <20130719042124.GC17812@cmpxchg.org>
 <20130719042502.GF17812@cmpxchg.org>
 <20130724203205.GL715@cmpxchg.org>
 <51F18A99.7000306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F18A99.7000306@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:29:13PM -0400, KOSAKI Motohiro wrote:
> (7/24/13 4:32 PM), Johannes Weiner wrote:
> >@@ -1189,9 +1174,17 @@ good_area:
> >  	 */
> >  	fault = handle_mm_fault(mm, vma, address, flags);
> >
> >-	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
> >-		if (mm_fault_error(regs, error_code, address, fault))
> >-			return;
> >+	/*
> >+	 * If we need to retry but a fatal signal is pending, handle the
> >+	 * signal first. We do not need to release the mmap_sem because it
> >+	 * would already be released in __lock_page_or_retry in mm/filemap.c.
> >+	 */
> >+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> >+		return;
> >+
> >+	if (unlikely(fault & VM_FAULT_ERROR)) {
> >+		mm_fault_error(regs, error_code, address, fault);
> >+		return;
> >  	}
> 
> When I made the patch you removed code, Ingo suggested we need put all rare case code
> into if(unlikely()) block. Yes, this is purely micro optimization. But it is not costly
> to maintain.

Fair enough, thanks for the heads up!
