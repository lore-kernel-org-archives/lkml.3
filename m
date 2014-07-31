Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbaGaH0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:26:21 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58346 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaGaH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:26:19 -0400
Date: Thu, 31 Jul 2014 11:26:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, jason.low2@hp.com,
        Sasha Levin <levinsasha928@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: cred_guard_mutex vs seq_file::lock [was: Re: 3.14.0+/x86:
 lockdep and mutexes not getting along]
Message-ID: <20140731072617.GK3212@moon>
References: <20140410142918.GU11096@twins.programming.kicks-ass.net>
 <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <26259.1397227827@warthog.procyon.org.uk>
 <20140411150724.GI18016@ZenIV.linux.org.uk>
 <20140730223130.GA22417@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730223130.GA22417@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 01:31:30AM +0300, Kirill A. Shutemov wrote:
...
> > 
> > *cringe*
> > 
> > I don't like it.  That really should be a responsiblity of specific ->show();
> > "I'm going to take that mutex, bugger off if we are in execve()" makes a lot
> > more sense than having e.g. seq_read() care of that.  IOW, I would very
> > much prefer the patch you've sent last week.
> > 
> > And yes, it might leave lockdep false positives, but that's better dealt with
> > by annotating the sucker ("this guy has a separate lockdep class for its
> > ->lock").  E.g. by splitting proc_single_file_operations in two and having
> > the one used for those files do lockdep_set_class() in its ->open().
> 
> I've got annoyed by the lockdep warning. What about the patch below?
> 
> From 54d8c463e12f23c09d6a2dbf93a4dc9bcb493c67 Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Thu, 31 Jul 2014 00:59:52 +0300
> Subject: [PATCH] procfs: silence lockdep warning about read vs. exec seq_file
> 
> Testcase:
> 
>   cat /proc/self/maps >/dev/null
>   chmod +x /proc/self/net/packet
>   exec /proc/self/net/packet
> 
> It triggers lockdep warning:
...
> 
> It's a false positive: seq files which take cred_guard_mutex are never
> executable. Let's use separate lock class for them.
> 
> I don't know why we allow "chmod +x" on some proc files, notably net-related.
> Is it a bug?
> 
> Also I suspect eb94cd96e05d fixes non-existing bug, like this one.

Yeah, it should. And the patch looks good to me. Still I think maybe indeed
we need to prevent ability to set executable attribute on proc seq files?
