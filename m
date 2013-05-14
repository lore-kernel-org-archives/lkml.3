Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3ENPWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:22:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab3ENPWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:22:51 -0400
Date: Tue, 14 May 2013 16:22:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tim.c.chen@linux.intel.com
Subject: Re: [RFC][PATCH 3/7] break up __remove_mapping()
Message-ID: <20130514152247.GU11497@suse.de>
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
 <20130507211958.756AC1A6@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130507211958.756AC1A6@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 02:19:58PM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Our goal here is to eventually reduce the number of repetitive
> acquire/release operations on mapping->tree_lock.
> 
> To start out, we make a version of __remove_mapping() called
> __remove_mapping_nolock().  This actually makes the locking
> _much_ more straighforward.
> 
> One non-obvious part of this patch: the
> 
> 	freepage = mapping->a_ops->freepage;
> 
> used to happen under the mapping->tree_lock, but this patch
> moves it to outside of the lock.  All of the other
> a_ops->freepage users do it outside the lock, and we only
> assign it when we create inodes, so that makes it safe.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

It's a stupid nit, but more often than not, foo and __foo refer to the
locked and unlocked versions of a function. Other times it refers to
functions with internal helpers. In this patch, it looks like there are
two helpers "locked" and "really, I mean it, it's locked this time".
The term "nolock" is ambiguous because it could mean either "no lock is
acquired" or "no lock needs to be acquired". It's all in one file so
it's hardly a major problem but I would suggest different names. Maybe

remove_mapping
lock_remove_mapping
__remove_mapping

instead of

remove_mapping
__remove_mapping
__remove_mapping_nolock

Whether you do that or not

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
