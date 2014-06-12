Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaFLPIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:08:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaFLPIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:08:49 -0400
Date: Thu, 12 Jun 2014 15:08:43 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] [RFC] Per-user namespace process accounting
Message-ID: <20140612150842.GC4228@ubuntumail>
References: <5386D58D.2080809@1h.com>
 <5399BB42.60304@elastichosts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5399BB42.60304@elastichosts.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alin Dobre (alin.dobre@elastichosts.com):
> On 29/05/14 07:37, Marian Marinov wrote:
> > Hello,
> > 
> > I have the following proposition.
> > 
> > Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that multiple
> > containers in different user namespaces share the process counters.

Most ppl here probably are aware of this, but the previous, never-completed
user namespace implementation provided this and only this.  We (mostly Eric
and I) spent years looking for clean ways to make that implementation, which
had some advantages (including this one), complete.  We did have a few POCs
which worked but were unsatisfying.  The two things which were never convincing
were (a) conversion of all uid checks to be namespace-safe, and (b) storing
namespace identifiers on disk.  (As I say we did have solutions to these, but
not satisfying ones).  These are the two things which the new implementation
address *beautifully*.

> > So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any
> > processes with ist own UID 99.
> > 
> > I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps, but
> > this brings another problem.
> 
> If this matters, we also suffer from the same problem here. So we
> support any implementation that would address it.

ISTM the only reasonable answer here (at least for now) is to make it more
convenient to isolate uid ranges, by providing a way to shift uids at mount
time as has been discussed a bit.

If we go down the route of talking about uid 99 in ns 1 vs uid 99 in ns 2,
then people will also expect isolation at file access time, and we're back
to all the disadvantages of the first userns implementation.

(If someone proves me wrong by suggesting a clean solution, then awesome)

-serge
