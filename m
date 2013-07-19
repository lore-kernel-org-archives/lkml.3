Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab3GSINS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:13:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54008 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433Ab3GSIND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:13:03 -0400
Date: Fri, 19 Jul 2013 09:12:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Nathan Rutman <nathan_rutman@xyratex.com>, Peng Tao <bergwolf@gmail.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [lustre mess] is mgc_fs_setup() reachable at all?
Message-ID: <20130719081258.GE4165@ZenIV.linux.org.uk>
References: <20130718090835.GZ4165@ZenIV.linux.org.uk>
 <CA+a=Yy49WfQVJAYybUzVvigi9b--kuagqKxBEH+yy0RZSKVnQA@mail.gmail.com>
 <5DD1CAAA-2008-47F9-B3B6-8D342B28D08C@xyratex.com>
 <20130718190703.GB4165@ZenIV.linux.org.uk>
 <3F4C226D-9D3B-46FA-9C8C-55268B2F904F@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3F4C226D-9D3B-46FA-9C8C-55268B2F904F@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 02:57:11PM -0600, Andreas Dilger wrote:

> > _THAT_ was going to be a remotely supplied data?  I really hope I've
> > misparsed what you said above...
> > 
> > And that still leaves the question about the code path that could
> > lead to execution of mgc_fs_setup().
> 
> The KEY_SET_FS is only used in the server code, not on the client.
> The MGC code is shared between client and server to mount the
> filesystem and fetch the cluster configuration from the management
> server.  In the case of a server mount, it also has to mount the
> underlying block device, which isn't true on the client, so this
> code is indeed unused.

Wait a minute...  So we have client side of things in staging, with
parts shared with the server, which is *not* in tree at all?  That
sounds painful - any changes done to the client code either risk
to break the server, or have the copies of the shared stuff diverge...

I honestly have no idea about your plans wrt merging; are you going
to put the server side of things there as well?

Another thing: is your ll_statfs_internal() safe to call right up to
the moment when client_common_put_super calls lprocfs_unregister_mountpoint?
Because procfs IO *can* come right until the procfs entry removal;
said removal will act as a barrier, so it won't leak past the return from
remove_proc_entry(), but that's it.

While we are at procfs side of thing, looks like you need exclusion between
ll_..._seq_write() that clear/set bits in ->ll_flags; at least I haven't
found anything that would prevent the races among those.
