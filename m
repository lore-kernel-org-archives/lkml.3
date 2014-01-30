Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaA3VuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:50:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaA3VuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:50:04 -0500
Date: Thu, 30 Jan 2014 13:50:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, mhocko@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mutex not unlocked on
 memcg_create_kmem_cache fail path
Message-Id: <20140130135002.22ce1c12b7136f75e5985df6@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com>
References: <1391097693-31401-1-git-send-email-vdavydov@parallels.com>
	<20140130130129.6f8bd7fd9da55d17a9338443@linux-foundation.org>
	<alpine.DEB.2.02.1401301310270.15271@chino.kir.corp.google.com>
	<20140130132939.96a25a37016a12f9a0093a90@linux-foundation.org>
	<alpine.DEB.2.02.1401301336530.15271@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 13:38:56 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> > > What's funnier is that tmp_name isn't required at all since 
> > > kmem_cache_create_memcg() is just going to do a kstrdup() on it anyway, so 
> > > you could easily just pass in the pointer to memory that has been 
> > > allocated for s->name rather than allocating memory twice.
> > 
> > We need a buffer to sprintf() into.
> > 
> 
> Yeah, it shouldn't be temporary it should be the one and only allocation.  
> We should construct the name in memcg_create_kmem_cache() and be done with 
> it.

Could.  That would require converting memcg_create_kmem_cache() to take 
a va_list and call kasprintf() on it.

The problem is that pesky rcu_read_lock() which is required around
cgroup_name() - we'd have to call memcg_create_kmem_cache() under
rcu_read_lock() so the usual GFP_foo limitations apply.



