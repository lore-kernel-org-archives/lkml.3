Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3FAEko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:40:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:53449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3FAEki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:40:38 -0400
Message-ID: <1370061602.3766.22.camel@pasglop>
Subject: Re: [PATCH v3 0/8] Nvram-to-pstore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Sat, 01 Jun 2013 14:40:02 +1000
In-Reply-To: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-25 at 15:47 +0530, Aruna Balakrishnaiah wrote:
> Currently the kernel provides the contents of p-series NVRAM only as a
> simple stream of bytes via /dev/nvram, which must be interpreted in user
> space by the nvram command in the powerpc-utils package. This patch set
> exploits the pstore subsystem to expose each partition in NVRAM as a
> separate file in /dev/pstore. For instance Oops messages will stored in a
> file named [dmesg-nvram-2].

We will need the same stuff for powernv. This is not a blocker for this
patch series which I'm happy to apply (after I give it another round of
review, hopefully today) but I would very much like you to, on top of
this, start moving some of the basic pseries partition nvram handling
to a generic place, along with your pstore bits, and use it on powernv
as well.

In fact, this applies to at least all the BookS server platforms...

Things that come to mind:

 - nvram_64.c duplicates generic_nvram.c as far as the user accessors
are concerned, it should be possible to get rid of code there. Either
the arch or the generic one (*)

 - The nvram partition management should move to generic. While at it
factor in the powermac variant (same stuff, mostly duplicated code)

 - powernv wants all the goodies that pseries has, as does cell.

(*) I wonder about that generic stuff... userspace might want to start
doing things like resizing the common partition if not big enough etc...
For that we might want to add more specific ioctl's. Is anybody other
than us using generic_nvram ? I don't like adding ioctl's like that
to a generic driver, maybe we could just make it call into something
like arch_nvram_ioctl() and have an empty weak variant instead of the
current ifdef game.

Cheers,
Ben.

> Changes from v2:
> 	- Fix renaming of pstore type ids in nvram.c
> 
> Changes from v1:
> 	- Reduce #ifdefs by and remove forward declarations of pstore callbacks
> 	- Handle return value of nvram_write_os_partition
> 	- Remove empty pstore callbacks and register pstore only when pstore
> 	  is configured
> ---
> 
> Aruna Balakrishnaiah (8):
>       powerpc/pseries: Remove syslog prefix in uncompressed oops text
>       powerpc/pseries: Add version and timestamp to oops header
>       powerpc/pseries: Introduce generic read function to read nvram-partitions
>       powerpc/pseries: Read/Write oops nvram partition via pstore
>       powerpc/pseries: Read rtas partition via pstore
>       powerpc/pseries: Distinguish between a os-partition and non-os partition
>       powerpc/pseries: Read of-config partition via pstore
>       powerpc/pseries: Read common partition via pstore
> 
> 
>  arch/powerpc/platforms/pseries/nvram.c |  353 +++++++++++++++++++++++++++-----
>  fs/pstore/inode.c                      |    9 +
>  include/linux/pstore.h                 |    4 
>  3 files changed, 313 insertions(+), 53 deletions(-)
> 


