Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3EUXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:16:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3EUXQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:16:58 -0400
Date: Tue, 21 May 2013 16:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Minkyung Kim <minkyung88@lge.com>
Subject: Re: [PATCH v5 0/7] Per process reclaim
Message-Id: <20130521161656.d6d24d1ce226b0034e02abdf@linux-foundation.org>
In-Reply-To: <1368084089-24576-1-git-send-email-minchan@kernel.org>
References: <1368084089-24576-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:21:22 +0900 Minchan Kim <minchan@kernel.org> wrote:

> These day, there are many platforms avaiable in the embedded market
> and they are smarter than kernel which has very limited information
> about working set so they want to involve memory management more heavily
> like android's lowmemory killer and ashmem or recent many lowmemory
> notifier(there was several trial for various company NOKIA, SAMSUNG,
> Linaro, Google ChromeOS, Redhat).
> 
> One of the simple imagine scenario about userspace's intelligence is that
> platform can manage tasks as forground and backgroud so it would be
> better to reclaim background's task pages for end-user's *responsibility*
> although it has frequent referenced pages.
> 
> The patch[1] prepares that force_reclaim in shrink_page_list can
> handle anonymous pages as well as file-backed pages.
> 
> The patch[2] adds new knob "reclaim under proc/<pid>/" so task manager
> can reclaim any target process anytime, anywhere. It could give another
> method to platform for using memory efficiently.
> 
> It can avoid process killing for getting free memory, which was really
> terrible experience because I lost my best score of game I had ever
> after I switch the phone call while I enjoyed the game.
> 
> Reclaim file-backed pages only.
> 	echo file > /proc/PID/reclaim
> Reclaim anonymous pages only.
> 	echo anon > /proc/PID/reclaim
> Reclaim all pages
> 	echo all > /proc/PID/reclaim

Oh boy.  I think I do agree with the overall intent, but there are so
many ways of doing this.

- Do we reclaim the pages altogether, or should we just give them one
  round of aging?  If the latter then you'd need to run "echo anon >
  /proc/PID/reclaim" four times to firmly whack the pages, but that's
  more flexible.

- Why do it via the pid at all?  Would it be better to instead do
  this to a memcg and require that the admin put these processes into
  memcgs?  In fact existing memcg controls could get us at least
  partway to this feature.

- I don't understand the need for "Enhance per process reclaim to
  consider shared pages".  If "echo file > /proc/PID/reclaim" causes
  PID's mm's file-backed pte's to be unmapped (which seems to be the
  correct effect) then we get this automatically: unshared file pages
  will be freed and shared file pages will remain in core until the
  other sharing process's also unmap them.


Overall, I'm unsure whether/how to proceed with this.  I'd like to hear
from a lot of the potential users, and hear them say "yes, we can use
this".

