Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbbALNjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:39:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbALNi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:38:59 -0500
Date: Mon, 12 Jan 2015 14:38:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "acme@infradead.org" <acme@infradead.org>
Subject: Re: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20150112133841.GB25256@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
 <A78C989F6D9628469189715575E55B231E676088@IRSMSX104.ger.corp.intel.com>
 <20150109151814.GP3337@twins.programming.kicks-ass.net>
 <87d26knnvp.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d26knnvp.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:12:58PM +0200, Alexander Shishkin wrote:
> > I suppose we could; I'm trying to remember why I did it like this, I'm
> > failing to remember much past yesterday atm :/ 
> 
> Well, right now we can only map things in one order: user page + perf
> buffer, then aux buffer. Ideally, we can reduce it to mapping the user
> page first (always R/W), setting up the desired offsets for data and aux
> buffers and then mapping those in whatever order. And we can also have
> holes between them if we want (not sure if that's useful, though).

Indeed, over the weekend I came up a similar argument. Suppose we want
to extend the thing with yet another area, at that point we simply do
not know which segment is meant to be mapp()ed.

Breaking up the control page from the data buffer is indeed a sane
proposal.

> If we want to stick to the current scheme of things where user page is
> mapped together with data, we should set up aux_{offset,size} in
> kernel's perf_mmap() path, similarly to data_{offset,size}.
> 
> There is another problem with it, though: it makes it impossible to run
> the aux buffer in "full trace mode" (where we move the tail as we read
> the data out), while running the data buffer in overwrite mode, because
> the latter requires the user_page to be mapped RO => no way to update
> aux_tail for the user.

ISTR aux bits relying on their own mmap(PROT_WRITE) bit, but yes-ish.
