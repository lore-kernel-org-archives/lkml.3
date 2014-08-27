Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934889AbaH0OHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:07:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57506 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbaH0OHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:07:36 -0400
Message-ID: <53FDE621.2050009@kernel.dk>
Date: Wed, 27 Aug 2014 08:07:29 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>	<53FCF9DB.6010501@kernel.dk>	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>	<53FCFD40.2010903@kernel.dk> <53FCFE01.8080701@kernel.dk> <x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 04:01 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>>> I have applied the first one, will look over the second one and hand
>>> apply it. Seems the NULL return was completely removed, so we _should_
>>> be ok on the IS_ERR() conversion, though that sort of thing always
>>> worries me a little bit. A NULL return can quickly show up again, and
>>> then they would all fail.
> 
> Well, we could guard against that with a BUG_ON in blk_get_request,
> right?

Yes, that might be a good idea.

>> Additionally, there's still quite a few places that call
>> blk_get_request() and don't check the error return if __GFP_WAIT is set.
>> Since most of the point of this is to fix segfaulting on queue dead
>> scenarios, why aren't they all converted?
> 
> Odd, I thought they all were converted last I checked.  They definitely
> should be.

drivers/ide/ide-park:issue_park_cmd() (patch oddly converts just the one?!)
drivers/ide/ide-pm.c:generic_ide_suspend()
drivers/ide/ide-pm.c:generic_ide_resume()
drivers/ide/ide-cd.c:ide_cd_queue_pc()
drivers/ide/ide-atapi.c:ide_queue_pc_tail()
drivers/ide/ide-ioctls.c:ide_cmd_ioctl()
drivers/ide/ide-ioctls.c:generic_drive_reset()
drivers/ide/ide-taskfile.c:ide_raw_taskfile()
drivers/ide/ide-tape.c:idetape_queue_rw_tail()
drivers/ide/ide-cd_ioctls.c:ide_cdrom_reset()
drivers/ide/ide-disk.c:set_multcount()
drivers/ide/ide-devsets.c:ide_devset_execute()

Why only one location in ide-park.c was converted and the rest of IDE
left untouched, I don't know. But there are definitely lots of them left
in there.

There's also a bug in osd_initiator.c, _init_blk_request(). We jump to
'out' for IS_ERR(req), which attempts to print or->request, which hasn't
been assigned yet. This is my primary concern with this patch, basically
every single of these call sites must be verified or it will do more
harm than good. Have they been?

-- 
Jens Axboe

