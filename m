Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3GWUQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:16:05 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:38039 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801Ab3GWUQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:16:03 -0400
Date: Tue, 23 Jul 2013 22:15:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: drm: Asynchronouse page flipping interface and Intel
 implementation
Message-ID: <20130723201559.GO5939@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org
References: <1374544202-15496-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374544202-15496-1-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 06:49:57PM -0700, Keith Packard wrote:
> Here's a sequence of five patches that exposes an interface to request
> of the driver that the page flipping request be executed without
> waiting for vblank. It's optional, and drivers can expose whether it
> is supported through the existing GETCAP ioctl.
> 
> This supports only Ivybridge and Sandybridge Intel graphics chips as
> that's what I've got to test on; of course all of the other drivers
> have been modified so that they still compile cleanly.

Quick comments on the i915 kernel part:
- Iirc the w/a database has a bunch of entries about async flips. Those
  need to be addressed and annoted with the new w/a tag comment format
  Damien recently created.

- We should exercise userspace abi cornercases and check that we get an
  -EINVAL everywhere we expect one. Since the current vblank-synced
  pageflips seem to also get this wrong it'd be good to exercise both
  modes.

- kms_flip needs to be extended to beat on async flips. Obviously the
  timing checks don't apply but otherwise I think it won't hurt to enable
  all the existing interaction tests with async flips, too. On top of that
  I think we should test interactions between async flips and vblank
  synced flips. Without the timing checks the other tests will run as fast
  as possible, so that should gives us good coverage of the
  non-ratelimited nature of async flips - even with vblank flips we've hit
  ugly issues by e.g. starving the unpin workers.

Oh and my little comment about moving all checks into core code is a bit
wrong, we'd still need to check for X-tiling with async flips ofc.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
