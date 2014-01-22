Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaAVTTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:19:33 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:37224 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaAVTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:19:30 -0500
Date: Wed, 22 Jan 2014 23:19:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-ID: <20140122191928.GQ1574@moon>
References: <20140122190816.GB4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122190816.GB4963@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 07:08:16PM +0000, Mel Gorman wrote:
> Cyrill,
> 
> Gimp is broken due to a kernel bug included in 3.12. It cannot open
> large files without failing memory allocations due to exceeding
> vm.max_map_count. The relevant bugzilla entries are
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=67651
> https://bugzilla.gnome.org/show_bug.cgi?id=719619#c0
> 
> They include details on how to reproduce the issue. In my case, a
> failure shows messages like this
> 
> 	(gimp:11768): GLib-ERROR **: gmem.c:110: failed to allocate 4096 bytes
> 
> 	(file-tiff-load:12038): LibGimpBase-WARNING **: file-tiff-load: gimp_wire_read(): error
> 	xinit: connection to X server lost
> 
> 	waiting for X server to shut down
> 	/usr/lib64/gimp/2.0/plug-ins/file-tiff-load terminated: Hangup
> 	/usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup
> 	/usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup
> 
> X-related junk is there was because I was using a headless server and
> xinit directly to launch gimp to reproduce the bug.
> 
> Automated bisection using mmtests (https://github.com/gormanm/mmtests)
> and the configuration file configs/config-global-dhp__gimp-simple (needs
> local web server with a copy of the image file) identified the following
> commit. Test case was simple -- try and open the large file described in
> the bug. I did not investigate the patch itself as I'm just reporting
> the results of the bisection. If I had to guess, I'd say that VMA
> merging has been affected.

Thanks a lot for report, Mel! I'm investigating...
