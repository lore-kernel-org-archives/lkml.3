Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab3IDSM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:12:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56881 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab3IDSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:12:22 -0400
Date: Wed, 4 Sep 2013 19:12:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, bfoster@redhat.com,
        dhowells@redhat.com, eparis@redhat.com, raven@themaw.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: Re: [PATCH 01/10] vfs: add d_walk()
Message-ID: <20130904181219.GJ13318@ZenIV.linux.org.uk>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
 <1378303556-7220-2-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378303556-7220-2-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:05:47PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This one replaces three instances open coded tree walking (have_submounts,
> select_parent, d_genocide) with a common helper.
> 
> In addition to slightly reducing the kernel size, this simplifies the
> callers and makes them less bug prone.

Two notes:

1) I'd probably kill select_parent() - it made sense when it was a huge
function called in a loop, but when it's a simple call of d_walk()...
Might as well do it directly in shrink_dcache_parent().  Moreover, in
that case we'd be free to embed list_head into your struct select_data,
rather than passing pointers.

2) I'm not sure we need the "leave" callback at all; the only user is
d_genocide() and AFAICS it can bloody well be done as part of
d_genocide_check() - we care about having it done to all nodes in
the tree, but we don't really care about the order in which it's
done...
