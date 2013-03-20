Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3CTMcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:32:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611Ab3CTMcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:32:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130320023308.GM21522@ZenIV.linux.org.uk>
References: <20130320023308.GM21522@ZenIV.linux.org.uk> <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk> <20130318153936.GB28508@quack.suse.cz> <20130318215333.GE21522@ZenIV.linux.org.uk> <20130319202543.GF5222@quack.suse.cz> <20130319213831.GK21522@ZenIV.linux.org.uk> <20130319221032.GL21522@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
Date: Wed, 20 Mar 2013 12:30:49 +0000
Message-ID: <29635.1363782649@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> fs/cachefiles/rdwr.c:967:                       ret = file->f_op->write(
> 
> cachefiles_write_page(); no fucking idea what locks might be held by caller
> and potentially that's a rather nasty source of PITA

The caller of cachefiles_write_page() (ie. fscache_write_op()) holds no locks
over the call.

__fscache_write_page() queues the pages for writing to the cache from the
netfs's read-side routines and returns immediately.

fscache_write_op() then picks them up in the background and passes them over
to the backend (eg. cachefiles_write_page()) which writes them out to the
cache.

So I think it should be safe to call file_start/end_write() or whatever around
the file->f_op->write() calls.

David
