Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaKNFYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:24:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30326 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752171AbaKNFYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:24:42 -0500
Date: Fri, 14 Nov 2014 00:24:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Elder <elder@linaro.org>
Cc: Pranith Kumar <bobby.prani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Jan Kara <jack@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile
 type
Message-ID: <20141114002436.535a16a9@gandalf.local.home>
In-Reply-To: <20141113235722.7457f9c7@gandalf.local.home>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
	<546589A1.9040100@linaro.org>
	<20141113235722.7457f9c7@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 23:57:22 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> That assignment is what it is initialized to at boot up. I can't see
> any optimization that would cause gcc to modify that. Especially since
> we are hiding its accesses within the ACCESS_ONCE(). That alone should
> confuse gcc enough to leave it a hell alone J.


I'm actually wondering if the ACCESS_ONCE or volatile is even needed.

static variables are used to maintain state, and that goes for
recursive functions. gcc should not touch it.

Now perhaps it can see that there is no recursion for logbuf_cpu to be
set to the current cpu (which would be interesting since the
smp_processor_id() call is also hidden from gcc), and it might optimize
it out. But that would not protect us from NMIs doing a printk().
Although this code doesn't protect us from that anyway if an NMI were
to come in right after taking the logbuf_lock and before setting
logbuf_cpu. In that case, logbuf_cpu will not be set to this_cpu and a
deadlock can still occur. This code only makes the race window smaller.

I'm thinking the correct change is to nuke all of it. Perhaps the only
reason using volatile here was not a bug is because volatile wasn't
needed in the first place!

-- Steve
