Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaFZVlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:41:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaFZVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:41:19 -0400
Date: Thu, 26 Jun 2014 14:41:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v8 4/4] printk: allow increasing the ring buffer
 depending on the number of CPUs
Message-Id: <20140626144117.3412feee6234786be098259d@linux-foundation.org>
In-Reply-To: <20140624010554.GF27687@wotan.suse.de>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com>
	<1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com>
	<20140623154134.43ac7ab63896cd9ebcba84b6@linux-foundation.org>
	<20140624002050.GC27687@wotan.suse.de>
	<20140623174533.88663e64.akpm@linux-foundation.org>
	<20140624010554.GF27687@wotan.suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 03:05:54 +0200 "Luis R. Rodriguez" <mcgrof@suse.com> wrote:

> > > Ah, because its cpu_extra, not total_cpu_space that is being
> > > computed, the goal was to see how much extra junk on the
> > > worst case a CPU might contribute. The __LOG_BUF_LEN is the
> > > default size, so we combine both.
> > 
> > Well...  why?  Isn't it simpler and more direct to say "I want at least
> > 32k per CPU"?
> 
> That's certainly another way to go about this, but the original motivation
> was trying to figure out the additional *extra* junk a CPU might spewed out,
> it set out with an assumption of a base start from the first CPU booting the
> system and that first CPU using the default kernel ring buffer size. The
> language in the patch describes the worst case extra CPU junk contributed,
> rather than a specific full split of the kernel ring buffer as that's typically
> how extra junk is spewered out to the ring bufer and the concern. In general
> on idle each CPU only contributes about only 1 to max 2 lines. The focus then
> is the worst case on contribution.

I don't think I understood all that ;)

> Another note --  since this option depends on SMP and !BASE_SMALL technically 
> num_possible_cpus() won't ever return something smaller than or equal to 1
> but because of the default values chosen the -1 on the compuation does affect
> whether or not this will trigger on > 64 CPUs or >= 64 CPUs, keeping the
> -1 means we require > 64 CPUs.

hm, that sounds like more complexity.

> This all can be changed however we like but the language and explained logic
> would just need to be changed.

Let's start out simple.  What's wrong with doing

	log buf len = max(__LOG_BUF_LEN, nr_possible_cpus * per-cpu log buf len)

?
