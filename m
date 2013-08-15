Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3HOL72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:59:28 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:40852 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3HOL7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:59:25 -0400
Date: Thu, 15 Aug 2013 13:59:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christopher James Halse Rogers 
	<christopher.halse.rogers@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: Expose buffer size to userspace
Message-ID: <20130815115932.GC776@phenom.ffwll.local>
Mail-Followup-To: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, linux-media@vger.kernel.org
References: <1375683720-4748-1-git-send-email-christopher.halse.rogers@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375683720-4748-1-git-send-email-christopher.halse.rogers@canonical.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:22:00PM +1000, Christopher James Halse Rogers wrote:
> Each dma-buf has an associated size and it's reasonable for userspace
> to want to know what it is.
> 
> Since userspace already has an fd, expose the size using the
> size = lseek(fd, SEEK_END, 0); lseek(fd, SEEK_CUR, 0);
> idiom.
> 
> Signed-off-by: Christopher James Halse Rogers <christopher.halse.rogers@canonical.com>

Yeah, loosk good to me and rather useful, so (with the dma-buf docs
improved as suggested below):

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I've also written some small prime tests in igt, so also:

Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
> 
> I've run into a point in the radeon DRM userspace where I need the
> size of a dma-buf. I could add a radeon-specific mechanism to get that,
> but this seems like something that would be more generally useful.
> 
> I'm not entirely sure about supporting both SEEK_END and SEEK_CUR; this
> is somewhat of an abuse of lseek, as seeking obviously doesn't make sense.
> It's the obivous idiom for getting the size of what's on the other end of a
> file descriptor, though.
> 
> I didn't notice anywhere to document this; Documentation/dma-buf-api didn't
> seem like the right place. Is there somewhere I've overlooked?

I think adding a section about various other userspace interfaces exposed
below the mmap support section would be good. Feel free to squash in the
belo diff for v2.

Cheers, Daniel

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 0b23261..b3a8aa2 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -407,6 +407,18 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
    interesting ways depending upong the exporter (if userspace starts depending
    upon this implicit synchronization).
 
+Other Interfaces Exposed to Userspace on the dma-buf FD
+------------------------------------------------------
+
+- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
+  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allowe
+  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
+  llseek operation will report -EINVAL.
+
+  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
+  cases. Userspace can use this to detect support for discovering the dma-buf
+  size using llsee.
+
 Miscellaneous notes
 -------------------
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
