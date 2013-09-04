Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952Ab3IDQYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:24:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab3IDQYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:24:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com>
References: <306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com> <cover.1375999914.git.milosz@adfin.com>
To: Hongyi Jia <jiayisuse@gmail.com>, milosz@adfin.com
Cc: dhowells@redhat.com, ceph-devel@vger.kernel.org, sage@inktank.com,
        zheng.z.yan@intel.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] new fscache interface to check cache consistency
Date: Wed, 04 Sep 2013 17:24:03 +0100
Message-ID: <18832.1378311843@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hongyi Jia <jiayisuse@gmail.com> wrote:

> +bool __fscache_check_consistency(struct fscache_cookie *cookie)
> +{
> +	struct fscache_object *object;
> +
> +	if (cookie->def->type != FSCACHE_COOKIE_TYPE_DATAFILE)
> +		return false;
> +
> +	if (hlist_empty(&cookie->backing_objects))
> +		return false;
> +
> +	object = hlist_entry(cookie->backing_objects.first,
> +			struct fscache_object, cookie_link);
> +
> +	return object->cache->ops->check_consistency(object);
> +}

Hmmm...  This isn't actually safe.  You have to either:

 (1) hold cookie->lock whilst touching the object pointer when coming from the
     netfs side, or:

 (2) set up an operation to do this (as, say, __fscache_alloc_page() does).

The problem is that you have nothing to defend against the object being
withdrawn by the cache under you.

David
