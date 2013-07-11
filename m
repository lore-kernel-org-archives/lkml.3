Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab3GKWyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:54:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61260 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3GKWyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:54:19 -0400
Date: Thu, 11 Jul 2013 15:54:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] mm: mempolicy: turn vma_set_policy() into
 vma_dup_policy()
In-Reply-To: <20130711153313.7e37a9095eacb1153ade516c@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1307111538320.2458@chino.kir.corp.google.com>
References: <20130710170205.GA26425@redhat.com> <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com> <20130711152006.de0900cfcd784f2833285ee4@linux-foundation.org> <alpine.DEB.2.02.1307111524400.2458@chino.kir.corp.google.com>
 <20130711153313.7e37a9095eacb1153ade516c@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Andrew Morton wrote:

> > PTR_ERR() may not imply IS_ERR(),
> 
> Well why not.  Are we saying that code can legitimately convert the
> PTR_ERR() return value back into a pointer?  If so that sounds nuts.
> 

ERR_PTR() is just delivering a payload that can be interpreted by 
PTR_ERR(), Rusty has spotted places in the kernel that do this without 
actual errno.  The most obvious case for me is the ERR_PTR(-1UL) in 
mm/oom_kill.c.

People delivering a non-errno payload shouldn't be using ERR_PTR(), but 
nothing enforces that.  You could add a WARN_ON_ONCE(error >= MAX_ERRNO).  
But PTR_ERR() will still need to rely on IS_ERR().

I agree that these longs should be converted to ints, since errno is 
defined to be int by the C standard.
