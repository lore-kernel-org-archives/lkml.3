Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818Ab3DQGuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:50:00 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:37419 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965787Ab3DQGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <CANGUGtD67qdQyokqbaUHC0FW115udEwd8VJj6j+z5Puzjkbpxg@mail.gmail.com>
References: <5169350A.9090600@gmail.com>
	<20130415115714.GB2299@quack.suse.cz>
	<CANGUGtD67qdQyokqbaUHC0FW115udEwd8VJj6j+z5Puzjkbpxg@mail.gmail.com>
Date: Wed, 17 Apr 2013 08:49:56 +0200
Message-ID: <CANGUGtC7JtuWaDfzUe0RcqZi6+vESx1cDTWQt_vo=xWFdS101Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] fsfreeze: wait in killable state in __sb_start_write
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend due to mail client problem.

Marco

2013/4/17 Marco Stornelli <marco.stornelli@gmail.com>
>
> Hi,
>
>
> 2013/4/15 Jan Kara <jack@suse.cz>
>>
>> On Sat 13-04-13 12:35:54, Marco Stornelli wrote:
>> > Added a new enum to decide if we want to sleep in uninterruptible or
>> > killable state or we want simply to return immediately.
>>   I like the patch. You can add:
>> Reviewed-by: Jan Kara <jack@suse.cz>
>>
>>                                                                 Honza
>>
>

I'm happy if we can include the patches. However I do an update about
the on-going and additional work: the patches submitted can  be
applied as-is, however, I'm still working on extending the killable
path in mnt_want_write/mnt_want_write_file and I'm seeing if it's
possible to change even the page_mkwrite path. In the first case, as
Al said, there are three clear "hot" points, do_last, kern_path_create
and mq_open. However I modified the code carefully in these code paths
and I did some basic tests and it works. I'm going to submit the patch
next week for a review if I'm able to do more tests.
About the page_mkwrite path and the return value VM_FAULT_RETRY: the
return value of get_user_pages can be 0 in case of VM_FAULT_RETRY. The
caller set the nonblocking flag and it can manage the situation.
Blocking callers, instead, have a BUG_ON on the return value of 0.
They want either an error code or the number of pages gotten. A little
modification of __get_user_pages can do the work. However,
page_mkwrite could return VM_FAULT_RETRY even if the flag
FAULT_FLAG_ALLOW_RETRY is not set, I don't know if it's correct and
this flag in each case, at the moment, it's not visibile in
page_mkwrite. In addition, I need to understand if a skip can be
useful, or in each case the process will go to sleep in
uninterruptible state in a step forward. Any comments is welcome.

Marco
