Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab3AXXpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:45:46 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:38734 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3AXXpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:45:38 -0500
Date: Thu, 24 Jan 2013 15:45:24 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Amit Kale <akale@stec-inc.com>
Cc: "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130124234524.GQ26407@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117113940.GI10411@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117113940.GI10411@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 03:39:40AM -0800, Kent Overstreet wrote:
> Suppose I could fill out the bcache version...
> 
> On Thu, Jan 17, 2013 at 05:52:00PM +0800, Amit Kale wrote:
> > 11. Error conditions - Handling power failures, intermittent and permanent device failures.
> 
> Power failures and device failures yes, intermittent failures are not
> explicitly handled.

Coworker pointed out bcache actually does handle some intermittent io errors. I
just added error handling to the documentation: 
http://atlas.evilpiepirate.org/git/linux-bcache.git/tree/Documentation/bcache.txt?h=bcache-dev

To cut and paste,

Bcache tries to transparently handle IO errors to/from the cache device without
affecting normal operation; if it sees too many errors (the threshold is
configurable, and defaults to 0) it shuts down the cache device and switches all
the backing devices to passthrough mode.

 - For reads from the cache, if they error we just retry the read from the
   backing device.

 - For writethrough writes, if the write to the cache errors we just switch to
   invalidating the data at that lba in the cache (i.e. the same thing we do for
   a write that bypasses the cache)
 
 - For writeback writes, we currently pass that error back up to the
   filesystem/userspace. This could be improved - we could retry it as a write
   that skips the cache so we don't have to error the write.

 - When we detach, we first try to flush any dirty data (if we were running in
   writeback mode). It currently doesn't do anything intelligent if it fails to
   read some of the dirty data, though.
