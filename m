Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaDXXtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:49:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57284 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaDXXtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:49:45 -0400
Date: Fri, 25 Apr 2014 00:49:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: fs: dcookie: freeing active timer
Message-ID: <20140424234941.GA18016@ZenIV.linux.org.uk>
References: <53594244.6070305@oracle.com>
 <20140424172708.GY18016@ZenIV.linux.org.uk>
 <53594B16.4000901@oracle.com>
 <20140424215558.GZ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424215558.GZ18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 10:55:58PM +0100, Al Viro wrote:
> On Thu, Apr 24, 2014 at 01:34:14PM -0400, Sasha Levin wrote:
> 
> > > Why does that code bother with destroying/creating that sucker dynamically?
> > > Is there any point at all?
> > 
> > I'm not sure about the dynamic allocation part, but I fear that if we just
> > switch to using static allocations it'll hide the underlying issue that
> > triggered this bug instead of fixing it.
> 
> FWIW, slub.c variant of kmem_cache_destroy() is buggered - struct kobject
> embedded into struct kmem_cache, its ktype is slab_ktype, which has
> NULL ->release()...

BTW, if your config has CONFIG_DEBUG_KOBJECT_RELEASE, that's exactly where
that warning comes from.  Got broken by commit b7454a,
Author: Glauber Costa <glommer@parallels.com>
Date:   Fri Oct 19 18:20:25 2012 +0400

    mm/sl[au]b: Move slabinfo processing to slab_common.c

We *do* need ->release().  Greg and guilty parties Cc'd...
