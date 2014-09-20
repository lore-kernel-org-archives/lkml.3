Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaITNUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 09:20:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:46850 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaITNU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 09:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140919194547.GB4402@redhat.com>
References: <20140918174127.GB340@redhat.com>
	<1411130664-10195-1-git-send-email-r.peniaev@gmail.com>
	<20140919194547.GB4402@redhat.com>
Date: Sat, 20 Sep 2014 22:20:27 +0900
Message-ID: <CACZ9PQUwP2_dNa1LF9nZUE0JV60zq30kkPUtWt0e4nAz3MUNQg@mail.gmail.com>
Subject: Re: [v4 PATCH 1/1] init: fix race between rootfs mount and firmware loading
From: Roman Peniaev <r.peniaev@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Oleg, for the review.

--
Roman

On Sat, Sep 20, 2014 at 4:45 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/19, Roman Pen wrote:
>>
>> +void wait_for_rootfs(void)
>> +{
>> +     /* Here we try to protect from a few things:
>> +      * 1. Avoid waiting for ourselves, when init thread has not
>> +      *    mounted rootfs yet.
>> +      * 2. Avoid warning if call chain was initiated from userspace
>> +      *    /sbin/init. For example when /sbin/init loads the driver,
>> +      *    which, in turn, wants to access rootfs (e.g. firmware loading),
>> +      *    thus it has to be sure, that rootfs has been successfully
>> +      *    mounted.
>> +      */
>> +     if (rootfs_mounted || WARN_ON(is_global_init(current)))
>> +             return;
>> +     else
>> +             wait_event(rootfs_waitq, rootfs_mounted);
>> +}
>
> Well, in this case __wait_event() makes more sense, we already checked
> rootfs_mounted, but this is minor.
>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>
>
> But I hope that Greg can take a look too. I do not understand the problem
> space enough, so I am not sure this is the "right" fix. Say, perhaps we
> should change the drivers which abuse request_firmware(), or do something
> else.
>
> Oleg.
>
