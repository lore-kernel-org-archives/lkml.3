Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaHaX3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:29:14 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62989 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHaX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:29:13 -0400
Date: Sun, 31 Aug 2014 19:29:09 -0400
From: Tejun Heo <tj@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org, oleg@redhat.com,
        akpm@linux-foundation.org, penguin-kernel@i-love.sakura.ne.jp,
        joseph.salisbury@canonical.com, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831232909.GA30592@mtj.dyndns.org>
References: <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
 <20140831201407.GB19881@core.coreip.homeip.net>
 <20140831204035.GA4793@kroah.com>
 <20140831215313.GA28690@mtj.dyndns.org>
 <20140831221534.GA18064@kroah.com>
 <20140831225312.GA29948@mtj.dyndns.org>
 <5403ADA8.1090903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5403ADA8.1090903@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 31, 2014 at 04:20:08PM -0700, Arjan van de Ven wrote:
> >Oh, but there already is a reported case which fails.  Hard drives
> >with a lot of platters take > 10secs to spin up and there are
> >configurations which regularly fail the initial reset and it's quite
> >rare but probing time taking over 30s does happen in the wild.  We
> >can't mark libata as requiring async probing on module load
> >unconditionally but at the same time we need them to be asynchronous
> >for use cases which don't depend on synchronous behavior has has
> >timeout.
> 
> libata probing is already async thankfully.

Heh, why is there so much confusion on what the problem is in this
thread?

libata probing is fully parallelized but is still synchronous against
module probing.  module probing performs async_synchronize_full() if
the the module loading thread did any async_schedule() calls and we
need that behavior for backward compatibility; however, the exact same
behavior is causing problem because it can take longer than 30s, so we
need a way to separate out probing from loading so that probing
actually becomes asynchronous against module loading.

Thanks.

-- 
tejun
