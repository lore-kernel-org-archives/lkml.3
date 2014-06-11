Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaFKTrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:47:10 -0400
Received: from 1wt.eu ([62.212.114.60]:41816 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbaFKTrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:47:08 -0400
Date: Wed, 11 Jun 2014 21:46:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michal Tesar <mtesar@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
Message-ID: <20140611194657.GU28551@1wt.eu>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local> <20140512003203.088027167@1wt.eu> <20140611184644.GA5442@hercules>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611184644.GA5442@hercules>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On Wed, Jun 11, 2014 at 07:46:44PM +0100, Luis Henriques wrote:
> Hi Willy,
> 
> On Mon, May 12, 2014 at 02:32:59AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> 
> During Ubuntu Lucid kernel regression testing, after the merge of
> 2.6.32.62, we found problems with the following patches
> 
> [ 059/143] sysctl net: Keep tcp_syn_retries inside the boundary
>            (Upstream commit 651e92716aaae60fc41b9652f54cb6803896e0da)
> 
> [ 065/143] net: check net.core.somaxconn sysctl values
>            (Upstream commit 5f671d6b4ec3e6d66c2a868738af2cdea09e7509)
> 
> The following two stack traces were found in kernel logs:

Aie :-/

> [    0.199908] sysctl table check failed: /net/core/somaxconn .3.1.18 Missing strategy
> [    0.201100] Pid: 1, comm: swapper Not tainted 2.6.32-02063262-generic #201405200837
> [    0.202173] Call Trace:
(...)
> and here's a bug link:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1326473

I think that Tyler's suggest is the right approach.

> For the Ubuntu Lucid kernel, we ended up reverting the offending
> commits.  Since I was able to reproduce this problem with a vanilla
> 2.6.32.62, you may want to take a similar action for the next 2.6.32
> release.

The initial bug is hard to debug on live systems. I've been hit myself
and it took me a lot of time to find the root cause. The problem is that
the backlog is stored on an unsigned short while the sysctl is stored
on an int, and the value is naturally truncated, so when you use an
somaxconn of N*65536 + just a few, you end up with just a few and drop
a lot of SYNs even under moderate loads. Worse, the only people who
touch these values are those who run under high loads and who are the
most likely to face the issue.

Thus if there's a quick way to check that Tyler's fix reliably addresses
the issue, I think we should take it instead. Of course I understand that
in the mean time the revert is better for you!

Regards,
Willy

