Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3LKRsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:48:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:11034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab3LKRsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:48:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,872,1378882800"; 
   d="scan'208";a="423056397"
Message-ID: <1386784112.6066.61.camel@tursulin-linux.isw.intel.com>
Subject: Re: Potentially unbounded allocations in seq_read?
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Dec 2013 17:48:32 +0000
In-Reply-To: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
Organization: Intel Corporation UK Plc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 17:04 +0000, Tvrtko Ursulin wrote:
> Hi all,
> 
> It seems that the buffer allocation in seq_read can double in size
> indefinitely, at least I've seen that in practice with /proc/<pid>/smaps
> (attempting to double m->size to 4M on a read of 1000 bytes). This
> produces an ugly WARN_ON_ONCE, which should perhaps be avoided? (given
> that it can be triggered by userspace at will)
> 
> From the top comment in seq_file.c one would think that it is a
> fundamental limitation of the current code that everything which will be
> read (even if in chunks) needs to be in the kernel side buffer at the
> same time?

Oh-oh, seems that m->size is doubled on every read. So if app is reading
with a buffer smaller than data available, it can do nine reads before
it hits a >MAX_ORDER allocation. Not good. :)

Regards,

Tvrtko


