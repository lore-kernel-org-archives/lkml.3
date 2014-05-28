Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaE1L5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:57:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaE1L5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:57:06 -0400
Date: Wed, 28 May 2014 12:57:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140528115701.GY18016@ZenIV.linux.org.uk>
References: <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528073751.GB1757@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:37:51AM +0300, Mika Westerberg wrote:

> I sent you the whole log privately so that I don't spam everyone.
> 
> Summary is here:
> 
> May 28 10:24:23 lahna kernel: scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: Attached scsi generic sg4 type 0
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Write Protect is off
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> May 28 10:24:23 lahna kernel:  sdc: sdc1
> May 28 10:24:23 lahna kernel: sd 14:0:0:0: [sdc] Attached SCSI removable disk
> 
> Here I detached the USB stick:
> 
> May 28 10:24:32 lahna kernel: usb 3-10.4: USB disconnect, device number 6
> May 28 10:24:32 lahna kernel: check_submounts_and_drop[/dev/block/8:33]; CPU 4 PID 576 [systemd-udevd]
> May 28 10:24:32 lahna kernel: dput[/dev/block/8:33]; CPU 4 PID 576 [systemd-udevd]
> May 28 10:24:32 lahna kernel: check_submounts_and_drop[3-10/3-10.4/3-10.4:1.0/host14]; CPU 1 PID 1683 [systemd-udevd]
> May 28 10:24:32 lahna kernel: shrink[3-10.4:1.0/host14/target14:0:0/subsystem]; CPU 1 PID 1683 [systemd-udevd]
> May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/rev]; CPU 1 PID 1683 [systemd-udevd]
> May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/vendor]; CPU 1 PID 1683 [systemd-udevd]
> May 28 10:24:32 lahna kernel: shrink[host14/target14:0:0/14:0:0:0/model]; CPU 1 PID 1683 [systemd-udevd]
> May 28 10:24:32 lahna kernel: check_submounts_and_drop[/dev/block/8:32]; CPU 4 PID 576 [systemd-udevd]
> ...
> May 28 10:24:32 lahna kernel: check_submounts_and_drop[0000:00:14.0/usb3/3-10/3-10.4]; CPU 6 PID 1684 [systemd-udevd]
> May 28 10:24:32 lahna kernel: check_submounts_and_drop[0000:00:14.0/usb3/3-10/3-10.4]; CPU 7 PID 1685 [systemd-udevd]
> May 28 10:24:32 lahna kernel: shrink[usb3/3-10/3-10.4/ltm_capable]; CPU 7 PID 1685 [systemd-udevd]
> May 28 10:24:32 lahna kernel: A
...

Hmm...  As it is, we have d_walk() trying _very_ hard in those situations.
Could you add that on top of the previous and see if livelock changes?

diff --git a/fs/dcache.c b/fs/dcache.c
index 42ae01e..4ce58d3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1209,7 +1209,7 @@ static enum d_walk_ret select_collect(void *_data, struct dentry *dentry)
 	 * ensures forward progress). We'll be coming back to find
 	 * the rest.
 	 */
-	if (!list_empty(&data->dispose))
+	if (data->found)
 		ret = need_resched() ? D_WALK_QUIT : D_WALK_NORETRY;
 out:
 	return ret;
