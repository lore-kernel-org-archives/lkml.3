Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaFRUDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:03:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbaFRUDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:03:36 -0400
Date: Wed, 18 Jun 2014 22:03:33 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Michal Hocko <mhocko@suse.cz>,
        Petr Mladek <pmladek@suse.cz>, Joe Perches <joe@perches.com>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT 1/2] printk: make dynamic kernel ring buffer alignemnt
	explicit
Message-ID: <20140618200333.GP4841@wotan.suse.de>
References: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com> <53A1B693.2000609@wwwdotorg.org> <20140618193329.GO4841@wotan.suse.de> <53A1EC8A.3070209@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1EC8A.3070209@wwwdotorg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:46:18PM -0600, Stephen Warren wrote:
> On 06/18/2014 01:33 PM, Luis R. Rodriguez wrote:
> > On Wed, Jun 18, 2014 at 09:56:03AM -0600, Stephen Warren wrote:
> >> On 06/18/2014 05:14 AM, Luis R. Rodriguez wrote:
> >>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >>>
> >>> We have to consider alignment for the ring buffer both for the
> >>> default static size, and then also for when an dynamic allocation
> >>> is made when the log_buf_len=n kernel parameter is passed to set
> >>> the size specifically to a size larger than the default size set
> >>> by the architecture through CONFIG_LOG_BUF_SHIFT.
> >>>
> >>> The default static kernel ring buffer can be aligned properly if
> >>> architectures set CONFIG_LOG_BUF_SHIFT properly, we provide ranges
> >>> for the size though so even if CONFIG_LOG_BUF_SHIFT has a sensible
> >>> aligned value it can be reduced to a non aligned value. Commit
> >>> 6ebb017de9 by Andrew ensures the static buffer is always aligned
> >>> and the decision of alignment is done by the compiler by using
> >>> __alignof__(struct log) (curious what value caused the crash?).
> >>
> >> IIRC the issue was that __log_buf's type is char[] so without the
> >> __aligned it could have any alignment at all, e.g. 1 or 2. However,
> >> struct printk_log is stored in the buffer rather than just char*, and so
> >> if __log_buf isn't aligned to the required alignment for that structure,
> >> that can caused unaligned accesses to fields in the structure, which
> >> isn't supported on ARM in at least some cases.
> >>
> >> As such, I think the change to setup_log_buf() in this patch makes sense
> >> (although I suppose in practice memblock_virt_alloc() probably has some
> >> minimum internal alignment that dwards LOG_ALIGN, but that's an
> >> implementation detail we shouldn't rely on).
> > 
> > Thanks for the feedback.
> > 
> > memblock_virt_alloc() will by default align to L1 cache, so if that satisfies
> > the architecture alignment it should be safe, but perhaps not optimal for
> > saving a few bytes. Still curious if without this patch a crash can be
> > triggered somehow with some log_buf_len=n, if so this can go to stable.
> 
> If memblock_virt_alloc() aligns to L1 cache, then I believe that the
> crash would never trigger.

By default it does, that is, if no alignment requirement is passed.

  Luis
