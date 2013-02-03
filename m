Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3BCO2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:28:42 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:39356 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3BCO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:28:41 -0500
MIME-Version: 1.0
In-Reply-To: <510E71BD.1010909@opengridcomputing.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<1359854463-2538-26-git-send-email-tj@kernel.org>
	<510E71BD.1010909@opengridcomputing.com>
Date: Sun, 3 Feb 2013 06:28:40 -0800
X-Google-Sender-Auth: Vj_dzolyDhJcyQIxZ34LhVIF-Ak
Message-ID: <CAOS58YOmYPX476gkvJLGtQZEL2RyyGq6XH0ifiuKLvEOgjjhHQ@mail.gmail.com>
Subject: Re: [PATCH 25/62] infiniband/cxgb4: convert to idr_alloc()
From: Tejun Heo <tj@kernel.org>
To: Steve Wise <swise@opengridcomputing.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Feb 3, 2013 at 6:18 AM, Steve Wise <swise@opengridcomputing.com> wrote:
> Is there a git tree somewhere that I can use to test these patches out?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git convert-to-idr_alloc

>> -       return ret;
>> +       if (lock) {
>> +               idr_preload(GFP_KERNEL);
>> +               spin_lock_irq(&rhp->lock);
>> +       }
>
> The idr_preload() needs to be above the 'if (lock)', no?

No reason to preload for ATOMIC allocation.  idr_alloc() can be called
by itself.

>> +
>> +       ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
>> +
>> +       if (lock) {
>> +               spin_unlock_irq(&rhp->lock);
>> +               idr_preload_end();
>> +       }
>
> And idr_preload_end() should be after the 'if (lock)' block methinks...

Ditto.

>> +
>> +       BUG_ON(ret == -ENOSPC);
>> +       return ret < 0 ? ret : 0;
>
> What would cause ret >  0?

It's the allocated id.  In this case, ret would either be @id or -errno.

Thanks.

-- 
tejun
