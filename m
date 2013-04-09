Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936456Ab3DIVEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:04:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57125 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936020Ab3DIVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:04:33 -0400
Date: Tue, 9 Apr 2013 16:04:22 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter@redhat.com,
        workman-devel@redhat.com, dhaval.giani@gmail.com,
        cgroups@vger.kernel.org
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130409210422.GA31120@sergelap>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130409095024.GI25576@redhat.com>
 <20130409193851.GJ6186@mtj.dyndns.org>
 <20130409194640.GK6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409194640.GK6186@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> A bit of addition.
> 
> On Tue, Apr 09, 2013 at 12:38:51PM -0700, Tejun Heo wrote:
> > > We need to make the distribute approach work in order to support
> > > containers, which requiring them to have a back-channel open to
> > > the host userspace. If we can do that, then we've solved the problem
> 
> Why is back-channel such a bad thing?  Even fully virtualized
> environments do special things to communicate with the host (the whole
> stack of virt drivers).  It is sub-optimal and pointless to make
> everything completely transparent.  There's nothing wrong with the
> basesystem knowing that they're inside a container or a virtualized
> environment, so I don't understand why a back-channel is such a big
> problem.

Agreed, that's fine so long as it will be a consistent interface.
Ideally, we could do it in a way that the container monitor can
transparently proxy between userspace inside the container and the
library on the host - so that userspace can 'use cgroups' the same
way no matter where it is.

So for instance if there is a dbus call saying "please create cgroup
/x with (some constraints) and put $$ into it", "something" in the
container can convert that into "please create cgroup /lxc/c1/x
and put (host_uid($$)) into it" and pass that to the host's (or
parent container's) "something".

So perhaps it is best if the container monitor, living in the parent
namespaces, opens a socket '@cgroup_monitor' in the container
namespace (through setns), listens for container-userpsace requests
there, and passes them on to the host's monitor (which hopefully
also listens on '@cgroup_monitor', @ being '\0').  Note that my
mentino of converting pids requires a new kernel feature which we
don't currently have (but have wanted for a long time).

-serge
