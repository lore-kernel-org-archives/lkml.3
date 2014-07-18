Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbaGRVvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:51:06 -0400
Received: from imap.thunk.org ([74.207.234.97]:44356 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaGRVvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:51:04 -0400
Date: Fri, 18 Jul 2014 17:50:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Price <price@mit.edu>
Subject: Re: [PATCH] random: check for increase of entropy_count because of
 signed conversion
Message-ID: <20140718215054.GD18775@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Price <price@MIT.EDU>
References: <20140716083308.GF1491@thunk.org>
 <442eeebeb78f9f2d4066ad923f4144fc2110c6f7.1405538086.git.hannes@stressinduktion.org>
 <20140718212504.GC18775@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718212504.GC18775@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:25:04PM -0400, Theodore Ts'o wrote:
> > As indicated by credit_entropy_bits entropy_count cannot get negative,
> > so I don't see any reason to include a check for entropy_count < 0
> > here. Do you agree?
> 
> No, the check is important; after we subtract ibytes << (ENTROPY_SHIFT
> + 3) we could drive entropy_count negative, and we don't want to
> trigger the WARN_ON().
> 
> I'll modify the patch to keep the check.

Never mind, I took a closer look at the your patch, and I now
understand what you were asking.  Since entropy_count should never
_start_ negative, simply checking to see if entropy_count > nfrac is
sufficient.

However, there's something a bit larger hiding here, which is we
shouldn't allow urandom_read to be passed a which is greater than
INT_MAX >> ENTROPY_SHIFT.  Otherwise, the nfrac calcuation will
overflow, which can also result in too little entropy getting removed.

The other problem is that comparing since entropy_count is an int, and
nfrac is a size_t, this is a signed vs. unsigned comparison, which
will raise compiler warnings.  

Let me know what you think of my revised patch, which should hopefully
add enough checks to be sufficiently paranoid.  :-)

							- Ted
