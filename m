Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbaIRHjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:39:10 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:48573 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaIRHjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:39:07 -0400
Message-ID: <1411025936.13381.183.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCHv3 0/8] target: Save memory on unused se_dev_entrys and
 se_luns
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2014 00:38:56 -0700
In-Reply-To: <20140913195557.GA32118@lst.de>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>
	 <20140729131511.GA30232@lst.de> <20140913195557.GA32118@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-13 at 21:55 +0200, Christoph Hellwig wrote:
> On Tue, Jul 29, 2014 at 03:15:11PM +0200, Christoph Hellwig wrote:
> > Nic,
> > 
> > any progress on looking over these?  Seems like there's actually
> > nothing at all queued up for 3.17 in the target tree, or am І missing
> > something?
> 
> ping again.  We're getting closer to the end of the 3.18 merge window
> and there still hasn't been a response.  Should Andy just send the patches
> directly to Linus once 3.18 opens given that they have been out on the list
> since Jun 23? (with a positive review from me and no negative one)
> 

Removing unused per WWPN endpoint LUN + per NodeACL MappedLUN memory is
a nice optimization to have, but I'm not yet convinced that extending
existing control path spinlocks to support an array of pointers is
ultimately worth the complexity it adds here.

Another concern is how these changes effect active session + device I/O
shutdown, which is an area of regressions I'd rather avoid if the
primary benefit of this series is only reducing memory footprint for
unused LUNs + MappedLUNs.  Lowering the TRANSPORT_MAX_LUNS_PER_TPG value
at compile time today is the simple way for reducing overall memory
footprint for folks who need to scale up the number of targets using
smaller individual LUN mappings.

As for something smarter, given the mostly read-only nature of LUN +
MappedLUN pointers to individual TPGT + NodeACLs context, I'd rather see
something based on RCU arrays + percpu_ref counting to avoid this type
of complexity to existing code, and move in the direction of dropping
fast-path I_T ->device_list_lock access all together.

Beyond these objections, there are some useful fixes + cleanups from
this series that I'm OK with merging soon..

--nab

