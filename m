Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaAOXV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 18:21:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaAOXVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 18:21:49 -0500
Message-ID: <1389828103.681.34.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
From: Eric Paris <eparis@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jkaluza@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rgb@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Date: Wed, 15 Jan 2014 18:21:43 -0500
In-Reply-To: <20140115.121730.1984913330507219167.davem@davemloft.net>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	 <1389600109-30739-1-git-send-email-jkaluza@redhat.com>
	 <20140115.121730.1984913330507219167.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 12:17 -0800, David Miller wrote:
> From: Jan Kaluza <jkaluza@redhat.com>
> Date: Mon, 13 Jan 2014 09:01:46 +0100
> 
> > Changes introduced in this patchset can also increase performance
> > of such server-like processes, because current way of opening and
> > parsing /proc/$PID/* files is much more expensive than receiving these
> > metadata using SCM.
> 
> The problem with this line of reasoning is that these changes will
> hurt everyone else, because these new control messages are sent
> unconditionally, whether the application is interested in them or not.
> 
> I really don't like this cost tradeoff, it's terrible, and therefore
> I'm really not inclined to apply these patches, sorry.

Agreed.  Although you seem to be ignoring the part of the logic where is
solves a problem that can not be solved today.

> The current practice to retrieve such process metadata is to look that
> information up in procfs with the $PID received over SCM_CREDENTIALS.
> This is sufficient for long-running tasks, but introduces a race which
> cannot be worked around for short-living processes; the calling
> process and all the information in /proc/$PID/ is gone before the
> receiver of the socket message can look it up.

Reliably being able to audit what process requested an action is
extremely useful.  And I like the audit patch, as it is a couple of ints
we are storing.

procinfo and cgroup can both be up to 4k of data.

Is there an alternative he should consider?  Some way to grab a
reference on task_struct and just attach that to the message?

