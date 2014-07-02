Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaGBQU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:20:29 -0400
Received: from moi001.1and1.com ([212.227.126.208]:56294 "EHLO moi.1and1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbaGBQU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:20:28 -0400
Message-ID: <53B43144.6010306@1und1.de>
Date: Wed, 02 Jul 2014 18:20:20 +0200
From: =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theuer?= <tst@1und1.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de> <20140701223644.GA30330@kroah.com> <53B3B283.7050800@schoebel-theuer.de> <20140702082400.GB10971@kroah.com> <20140702132708.GA26732@infradead.org> <53B418FA.80600@1und1.de> <20140702145024.GA19425@infradead.org>
In-Reply-To: <20140702145024.GA19425@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Most likely you shouldn't do either. A block driver really should not
> be removing directories from the filesystem namespace. 

Please take into account that MARS Light is not just a "device driver",
but a long-distance distributed system dealing with huge masses of state
information.

The /mars/ filesystem (which is a reserved directory) is a means for
storage of transaction logfiles. This has one big advantage: it is a
_shared_ storage space for _multiple_ resources.

The current setup at 1&1 datacenters is dealing with at least 7
resources in parallel; the number is likely to grow in future.

IMHO, replacing the /mars/ filesystem by block device storage would
likely mean to have a rather static ring-buffer like structure for
_each_ of multiple resources.

When taking your argument (which I can understand) to the extreme, I
would not even be allowed to use files as a dynamic storage for
transaction logfiles at all.

In essence, I fear that such a requirement  would mean to re-implement
the core functionality of a classical filesystem, namely (a) creating
multiple instances of _dynamic_ storage (aka files) out of a single
static storage (aka block device), and (b) synchronizing parallel access
to that. My idea was to re-use that functionality already implemented by
filesystems, where fundamental problems such as fragmentation are
already solved.

There is a second reason for using a filesystem:

As explained in slide 10 of the LinuxTag presentation, the symlink tree
residing in /mars/ is also used for storage and propagation of metadata
information.

Unfortunately, the slides don't contain my oral explanations (both at
LCA2014 and LinuxTag2014) about the symlink tree. It is used for three
purposes at the same time:

1) as a _persistent_ key->value store.

2) as the _only_ means of high-level metadata communication in the
long-distance cluster.

3) as interface between userspace and kernelspace (no longer any binary
interfaces).

IMHO, if I had to avoid filesystem operations at least regarding
symlinks, the complete MARS Light design would have to be redesigend /
re-implemented in a very different way, essentially a completely
different implementation, essentially forcing me to throw away the
effort of years.

Notice that MARS Full is planned to abstract away from concrete storage
formats such as filesystems, so your objective could probably be met in
future (if it will have some advantages).

Please permit me to use /mars/ for MARS Light as a reserved space where
not only transaction logfiles for multiple resources are residing, but
also the symlink tree is allowed to reside.

Cheers,

Thomas

