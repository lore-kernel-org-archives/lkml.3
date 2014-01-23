Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaAWBja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:39:30 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:41550 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaAWBj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:39:29 -0500
Date: Wed, 22 Jan 2014 17:39:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: khlebnikov@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad rss-counter state
In-Reply-To: <52E06B6F.90808@oracle.com>
Message-ID: <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
References: <52E06B6F.90808@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014, Sasha Levin wrote:

> Hi all,
> 
> While fuzzing with trinity running inside a KVM tools guest using latest -next
> kernel,
> I've stumbled on a "mm: BUG: Bad rss-counter state" error which was pretty
> non-obvious
> in the mix of the kernel spew (why?).
> 

It's not a fatal condition and there's only a few possible stack traces 
that could be emitted during the exit() path.  I don't see how we could 
make it more visible other than its log-level which is already KERN_ALERT.

> I've added a small BUG() after the printk() in check_mm(), and here's the full
> output:
> 

Worst place to add it :)  At line 562 of kernel/fork.c in linux-next 
you're going to hit BUG() when there may be other counters that are also 
bad and they don't get printed.  

> [  318.334905] BUG: Bad rss-counter state mm:ffff8801e6dec000 idx:0 val:1

So our mm has a non-zero MM_FILEPAGES count, but there's nothing that was 
cited that would tell us what that is so there's not much to go on, unless 
someone already recognizes this as another issue.  Is this reproducible on 
3.13 or only on linux-next?
