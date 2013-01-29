Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3A2AVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:21:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29799 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3A2AVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:21:10 -0500
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130129002011.GA4757@blackbox.djwong.org>
Date: Mon, 28 Jan 2013 16:20:11 -0800 (PST)
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: David Lang <david@lang.hm>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-kernel@vger.kernel.org, tux3@tux3.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Tux3 Report: Initial fsck has landed
References: <CAEsagEgeaHC_2ULhr_yAtOuNUxk+PZC=aPXU4PQyY9NnUC=TyQ@mail.gmail.com>
 <alpine.DEB.2.02.1301272158450.13067@nftneq.ynat.uz>
 <CAEsagEjAoVNUUSotBXd0am5zZb5VMLWT2Dz9k5fj+C9-LKABnQ@mail.gmail.com>
 <20130128141209.GA22711@thunk.org>
 <alpine.DEB.2.02.1301281526410.21503@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1301281526410.21503@nftneq.ynat.uz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 03:27:38PM -0800, David Lang wrote:
> On Mon, 28 Jan 2013, Theodore Ts'o wrote:
> 
> >On Sun, Jan 27, 2013 at 10:13:37PM -0800, Daniel Phillips wrote:
> >>>The thing that jumps out at me with this is the question of how you will
> >>>avoid the 'filesystem image in a file' disaster that reiserfs had (where
> >>>it's fsck could mix up metadata chunks from the main filesystem with
> >>>metadata chunks from any filesystem images that it happened to stumble
> >>>across when scanning the disk)

Did that ever get fixed in reiserfs?

> >>>
> >>Only superficially. Deep thoughts are in order. First, there needs to be a
> >>hole in the filesystem structure, before we would even consider trying to
> >>plug something in there. Once we know there is a hole, we want to
> >>narrow down the list of candidates to fill it. If a candidate already lies
> >>within a perfectly viable file, obviously we would not want to interpret
> >>that as lost metadata. Unless the filesystem is really mess up...
> >>
> >>That is about as far as I have got with the analysis. Clearly, much more
> >>is required. Suggestions welcome.
> >
> >The obvious answer is what resierfs4 ultimately ended up using.  Drop
> >a file system UUID in the superblock; mix the UUID into a checksum
> >which protects each of the your metadata blocks.  We're mixing in the
> >inode number as well as the fs uuid in in ext4's new metadata checksum
> >feature to protect against an inode table block getting written to the
> >wrong location on disk.  It will also mean that e2fsck won't mistake
> >an inode table from an earlier mkfs with the current file system.
> >This will allow us to avoid needing to zero the inode table for newly
> >initialized file systems.
> 
> The situation I'm thinking of is when dealing with VMs, you make a
> filesystem image once and clone it multiple times. Won't that end up
> with the same UUID in the superblock?

Yes, but one ought to be able to change the UUID a la tune2fs -U.  Even
still... so long as the VM images have a different UUID than the fs that they
live on, it ought to be fine.

--D
> 
> David Lang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
