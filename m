Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156Ab3GLRMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:12:19 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44373 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3GLRMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:12:18 -0400
Message-ID: <51E038ED.7050600@gmail.com>
Date: Fri, 12 Jul 2013 11:12:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com>
In-Reply-To: <20130712154521.GD1020@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/13 9:45 AM, Dave Jones wrote:
> Here's a fun trick:
>
> trinity -c perf_event_open -C4 -q -l off
>
> Within about a minute, that brings any of my boxes to its knees.
> The softlockup detector starts going nuts, and then the box wedges solid.

I tried that in a VM running latest Linus tree. I see trinity children 
getting nuked regularly from oom.

I was dumping Vm elements using:

while [ 1 ]; do echo $(date) $(egrep Vm /proc/$pid/status); sleep 1; done

And right before the process is killed was the line:

Fri Jul 12 11:00:19 MDT 2013 VmPeak: 2867472 kB VmSize: 2867472 kB 
VmLck: 0 kB VmPin: 0 kB VmHWM: 1493092 kB VmRSS: 1493092 kB VmData: 
2857944 kB VmStk: 136 kB VmExe: 100 kB VmLib: 1844 kB VmPTE: 5628 kB 
VmSwap: 0 kB

The VmData is growing fairly steadily and strace shows a lot of brk 
calls. Is that normal for trinity - or this command line?

Looking at the perf_event_open calls I see a lot of E2BIG errors in 
addition to EINVAL. e.g,

...
perf_event_open(0xba9000, 0, 0x4c, 0xcc, 0) = -1 EINVAL (Invalid argument)
alarm(0)                                = 1
getppid()                               = 9031
alarm(1)                                = 0
perf_event_open(0xba9000, 0x2a6e, 0xe, 0xfd, 0) = -1 E2BIG (Argument 
list too long)
alarm(0)                                = 1
getppid()                               = 9031
alarm(1)                                = 0
...

David
