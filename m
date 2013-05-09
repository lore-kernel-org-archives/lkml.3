Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3EIIvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:51:44 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:32997 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3EIIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:51:41 -0400
Date: Thu, 9 May 2013 10:51:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 10/13] perf kvm: add live mode
Message-ID: <20130509085137.GA8813@gmail.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
 <1368073909-8825-11-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368073909-8825-11-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> perf kvm stat currently requires back to back record and report
> commands to see stats. e.g,.
> 
>   perf kvm stat record -p $pid -- sleep 1
>   perf kvm stat report
> 
> This is inconvenvient for on box monitoring of a VM. This patch
> introduces a 'live' mode that in effect combines the record plus
> report into one command. e.g., to monitor a single VM:
> 
>   perf kvm stat live -p $pid
> 
> or all VMs:
> 
>   perf kvm stat live
> 
> Same stats options for the record+report path work with the live mode.
> Display rate defaults to 1 second and can be changed using the -d option.

Nice!

1)

Regarding the basic syntax - is the 'perf stat kvm' command already used 
up? If not then it might make sense to alias 'perf kvm stat live' to 'perf 
kvm stat', making it really easy to use:

  perf kvm stat
  perf kvm stat -p <pid>

etc. I'd expect most 'perf kvm stat' users to utilize this syntax - so it 
makes sense to make 'live' the default and main command.

2)

Another suggestion: it would be nice to allow a "--repeat <n>" option as 
well, for a limited number of iterations - similar to what the 'top' tool 
allows:

  top -b -d <delay> -n <iterations>

--repeat 0 means infinite repeats, --repeat 1 means a single step.

3)

It might make sense to create 'perf kvm stat top' which is a small 
variation to 'perf kvm stat live': it outputs a perf stat output per 
second, but also outputs a clear-screen sequence before the output.

To keep it simple you could do this with plain console text output, not 
libslang, the C code to generate a clear screen sequence can be generated 
via this shell oneliner:

  echo 'prinf("'$(clear)'");' > clearscreen.c

This way people could see constantly updating top-alike KVM statistics.

Thanks,

	Ingo
