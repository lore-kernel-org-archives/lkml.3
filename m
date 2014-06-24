Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaFXViE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:38:04 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34552 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbaFXViB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140624210930.GD14909@htj.dyndns.org>
References: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
	<20140624210930.GD14909@htj.dyndns.org>
Date: Tue, 24 Jun 2014 16:37:58 -0500
Message-ID: <CADT32eJPAty_yGA5UGZV9h7XHN_8Sn70v1vhRRn7+URvU+URGA@mail.gmail.com>
Subject: Re: [PATCH] blkio: Release blkg infrastructure only after last policy
 is deactivated.
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we start from blk_cleanup_queue(), we put request queue in bypass mode,
drain it (and service queues), and then destroy blkcgs (explicitly)

When we start from blk_release_queue(), we do not drain first and then
destroy blkcgs.  So if we destroy blkcg and then call (implicitly) and
bail out of
blk_drain_queue, we would not have drained the service queues which
is not what we want.

I do not see any harm in waiting till end to release blkcgs (as I understand).

Regards,

Shirish

On Tue, Jun 24, 2014 at 4:09 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Jun 23, 2014 at 01:52:25PM -0500, shirishpargaonkar@gmail.com wrote:
>> From: Shirish Pargaonkar <spargaonkar@suse.com>
>>
>> Release blkg infrastructure only after last policy is deactivated
>> (i.e. let blkg_destroy_all() be called only from blkcg_deactivate_policy())
>>
>> Otherwise, module can oops because root_blkg gets assigned NULL during
>> cleanup and we attempt draining the service queues via root_blkg afterwords.
>
> I'm not sure this fix makes sense.  Cleanup path oopses on an already
> freed resource.  How can the solution be not freeing?  Why not simply
> make blkcg_drain_queue() bail if the blkgs are all destroyed?  The
> whole thing is fully synchronized with the queuelock, right?
>
> Can you please also cc Jens when you post the next iteration?
>
> Thanks.
>
> --
> tejun
