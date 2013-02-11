Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab3BKWNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:13:39 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54368 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3BKWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:13:37 -0500
Date: Mon, 11 Feb 2013 14:13:48 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/11] ksm: stop hotremove lockdep warning
In-Reply-To: <20130208194510.65fadd37@thinkpad.boeblingen.de.com>
Message-ID: <alpine.LNX.2.00.1302111410290.1174@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251808120.29196@eggly.anvils> <20130208194510.65fadd37@thinkpad.boeblingen.de.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Gerald Schaefer wrote:
> On Fri, 25 Jan 2013 18:10:18 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > Complaints are rare, but lockdep still does not understand the way
> > ksm_memory_callback(MEM_GOING_OFFLINE) takes ksm_thread_mutex, and
> > holds it until the ksm_memory_callback(MEM_OFFLINE): that appears
> > to be a problem because notifier callbacks are made under down_read
> > of blocking_notifier_head->rwsem (so first the mutex is taken while
> > holding the rwsem, then later the rwsem is taken while still holding
> > the mutex); but is not in fact a problem because mem_hotplug_mutex
> > is held throughout the dance.
> > 
> > There was an attempt to fix this with mutex_lock_nested(); but if that
> > happened to fool lockdep two years ago, apparently it does so no
> > longer.
> > 
> > I had hoped to eradicate this issue in extending KSM page migration
> > not to need the ksm_thread_mutex.  But then realized that although
> > the page migration itself is safe, we do still need to lock out ksmd
> > and other users of get_ksm_page() while offlining memory - at some
> > point between MEM_GOING_OFFLINE and MEM_OFFLINE, the struct pages
> > themselves may vanish, and get_ksm_page()'s accesses to them become a
> > violation.
> > 
> > So, give up on holding ksm_thread_mutex itself from MEM_GOING_OFFLINE
> > to MEM_OFFLINE, and add a KSM_RUN_OFFLINE flag, and
> > wait_while_offlining() checks, to achieve the same lockout without
> > being caught by lockdep. This is less elegant for KSM, but it's more
> > important to keep lockdep useful to other users - and I apologize for
> > how long it took to fix.
> 
> Thanks a lot for the patch! I verified that it fixes the lockdep warning
> that we got on memory hotremove.
> 
> > 
> > Reported-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > Signed-off-by: Hugh Dickins <hughd@google.com>

Thank you for reporting and testing and reporting back:
sorry again for taking so long to fix it.

Hugh
