Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab3GBVn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:43:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3GBVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:43:28 -0400
Date: Tue, 2 Jul 2013 14:43:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ecashin@noserose.net
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Subject: Re: [PATCH 1/3] aoe: perform I/O completions in parallel
Message-Id: <20130702144326.f891debce89e6b8f82efa39c@linux-foundation.org>
In-Reply-To: <419af57660dd6fbb436e76291c1e532eede0cea3.1372710099.git.ecashin@coraid.com>
References: <cover.1372710099.git.ecashin@coraid.com>
	<419af57660dd6fbb436e76291c1e532eede0cea3.1372710099.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013 14:23:51 -0700 ecashin@noserose.net wrote:

> Some users have a large AoE target while others like to use
> many AoE targets at the same time.  In the latter case, there
> is an opportunity to greatly improve aggregate throughput by
> allowing different threads to complete the I/O associated
> with each target.  For 36 targets, 4 KiB read throughput
> roughly doubles, for example, with these changes in place.
> 
> ...
>
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -35,14 +35,24 @@ module_param(aoe_maxout, int, 0644);
>  MODULE_PARM_DESC(aoe_maxout,
>  	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
>  
> -static wait_queue_head_t ktiowq;
> -static struct ktstate kts;
> +/* The number of online cpus in the system,
> + * this dictates the number of ktio threads
> + * which will be spawned.
> + */
> +static int ncpus;

I can see that doing it this way simplifies the code rather a lot, but
of course CPU hotplug can and will make ncpus grossly different from
the current num_online_cpus.

I suggest it's worth adding a comment here mentioning this, and
explaining why and how that's OK.  If it indeed is OK ;)

Also, these patches were sent as being from ecashin@noserose.net.  I
rewrote that to ecashin@coraid.com which is what I suspect you
intended.  You can do this override yourself by putting a From: line
right at the top of the changelog.
