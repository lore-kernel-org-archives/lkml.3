Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaHDMlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:41:10 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55268 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbaHDMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:41:07 -0400
Date: Mon, 4 Aug 2014 21:39:56 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Sami Kerola <kerolasa@iki.fi>
Cc: util-linux@vger.kernel.org, Timofey Titovets <nefelim4ag@gmail.com>,
        Karel Zak <kzak@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: zram: device management utility needed
Message-ID: <20140804123956.GB957@swordfish>
References: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406675682-8402-1-git-send-email-kerolasa@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Jerome

Hello,

my quick thoughts on the topic. first, I'm not against, and we might have
something like this one day, but...

On (07/30/14 00:14), Sami Kerola wrote:
> Hello,
> 
> Not so long ago Timofey has reached both util-linux[1] and kernel[2]
> contributors with intention to make zram device management too.  I think
> the proposal is good, and there should be distribution independent tool
> like that.  Also such command fits fairly well to a scope of util-linux
> package.  But a tool is only as good as kernel support of it is.  This
> mail is a bit about both.
> 
> Existing proposal for zramctl[3], wrote by Timofey, does what I would
> call great starting point.  It can resize zram device, select algorithm,
> and set number of threads.  Unfortunately it cannot create or remove zram
> devices.
> 
> The zram devices are not created by any sort of equipment appearing in a
> bus so an method of creating new or removing existing devices will be
> needed.  When the zram module is loaded it should create
> /dev/zram-control device, that responds to ioctl() calls[4].  The calls
> could be similar with /dev/loop-control[5], that allow adding or removing
> specified device, and discover adding a free device.
> 
> This proposal would not affect the current initialization of the zram
> devices[6].  It would be an addition to manage zram devices after kernel
> module is loaded, of course each device separately and individually.  At
> the moment adding a device requires removing the existing devices[7],
> which can mean data loss, and at least unnecessary hassle when performing
> a device addition task.

well, run-time data loss, assuming that fs has failed to read a page,
because e.g. zram has mistakenly discarded it, I believe, is out of this
topic. any other type of data loss is out of zram design. whenever user
decides to umount/reboot/etc., it's his/her sole responsibility to keep
the data, zram is not meant to help here.

uninitialised or reset (when unneeded) device *must* be almost free:
there are no zspool, fs, compression backend, etc. which means that
one can pre-allocated as many devices as he needs and init/reset devices
whenever required.

so the problem seems to be "we can do A, but it doesn't look very
convenient", rather than "we can't do A".

	-ss

> 
> But before getting too exited and asking for ioctl() allocation, or
> thinking too much about code, does an overall plan like this make sense? 
> Is there an alternative that would be better than /dev/zram-control +
> ioctl()'s?  Any other comments, better proposal, and so on?
> 
> Finally, Hats off to Timofey, you got the ball rolling getting the zram
> devices being dynamic someday in future.
> 
> [1] http://www.spinics.net/lists/util-linux-ng/index.html#09781
> [2] https://lkml.org/lkml/2014/7/17/272
> [3] http://www.spinics.net/lists/util-linux-ng/msg09900.html
> [4] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/ioctl-number.txt?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8
> [5] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/block/loop.c?id=31dab719fa50cf56d56d3dc25980fecd336f6ca8#n1757
> [6] such as: modprobe zram num_devices=4
> [7] requires 'rmmod zram' which is not possible if any zram device is busy
> 
> -- 
> Sami Kerola
> http://www.iki.fi/kerolasa/
> 
