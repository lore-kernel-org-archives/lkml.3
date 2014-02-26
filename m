Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaBZWZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:25:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaBZWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:25:36 -0500
Date: Wed, 26 Feb 2014 14:25:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Regression with wait_event_timeout in next-20140226
Message-Id: <20140226142534.3b8c6eb1652d000206948ae0@linux-foundation.org>
In-Reply-To: <20140226165043.GA22802@laptop.programming.kicks-ass.net>
References: <530E17C7.1030504@free-electrons.com>
	<20140226165043.GA22802@laptop.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 17:50:43 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Feb 26, 2014 at 05:35:19PM +0100, Gregory CLEMENT wrote:
> > Hi,
> > 
> > while testing next-20140226 I got an issue with the function
> > wait_event_timeout. When this function timed out instead of returning
> > 0, it returned the value of the timeout passed in parameter. I found
> > that reverting "sched/wait: Suppress Sparse 'variable shadowing'
> > warning" fixed this regression.
> > 
> > I got this issue in the driver drivers/i2c/busses/i2c-mv64xxx.c.
> 
> Ah indeed. We actually rely on the shadowing for ___wait_cond_timeout().
> 
> We further used the __ret variable in __wait_event_timeout()'s cmd
> argument: __ret = schedule_timeout(__ret). That now explicitly uses the
> wrong __ret.
> 
> Yeah, we need to pull that patch.


Is there anything we can do to make all this clearer?  Simply using a
distinctive variable name ("__wait_var__"?) in place of __ret (and
documenting it) would help a lot.

Some __ret's are long and some are int.  Maybe that's a glitch, maybe
it's because some __ret's are used for inter-macro communications and
some are not, which just makes things worse.

I started to do a patch, got all confused and gave up.  We've made
quite a tangly mess in there, alas.
