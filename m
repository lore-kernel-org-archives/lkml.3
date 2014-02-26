Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbaBZQuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:50:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52459 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:50:50 -0500
Date: Wed, 26 Feb 2014 17:50:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression with wait_event_timeout in next-20140226
Message-ID: <20140226165043.GA22802@laptop.programming.kicks-ass.net>
References: <530E17C7.1030504@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E17C7.1030504@free-electrons.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 05:35:19PM +0100, Gregory CLEMENT wrote:
> Hi,
> 
> while testing next-20140226 I got an issue with the function
> wait_event_timeout. When this function timed out instead of returning
> 0, it returned the value of the timeout passed in parameter. I found
> that reverting "sched/wait: Suppress Sparse 'variable shadowing'
> warning" fixed this regression.
> 
> I got this issue in the driver drivers/i2c/busses/i2c-mv64xxx.c.

Ah indeed. We actually rely on the shadowing for ___wait_cond_timeout().

We further used the __ret variable in __wait_event_timeout()'s cmd
argument: __ret = schedule_timeout(__ret). That now explicitly uses the
wrong __ret.

Yeah, we need to pull that patch.
