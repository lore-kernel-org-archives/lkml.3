Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbaDXO0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:26:52 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:44836 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaDXO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140423215804.GU18016@ZenIV.linux.org.uk>
References: <1398089562-5925-1-git-send-email-yfw.kernel@gmail.com>
	<20140423215804.GU18016@ZenIV.linux.org.uk>
Date: Thu, 24 Apr 2014 22:26:50 +0800
Message-ID: <CADUXgx7-5SQg2wVbJ1rp6DRhepcK9MWU67bixVwhXA6rr0skuA@mail.gmail.com>
Subject: Re: [PATCH] Fix seq_read dead loop and trigger memory allocation failure.
From: Fengwei Yin <yfw.kernel@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 5:58 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Apr 21, 2014 at 10:12:42PM +0800, Fengwei Yin wrote:
>> When dump /proc/xxx/maps, if d_path return error in seq_path, the
>> buffer will be exhaust and trigger dead loop in seq_read. Till
>> kmalloc fails with -ENOMEM.
>
> *WHAT* d_path error?  -ENAMETOOLONG, aka. "you've got too little space"?
>
I could check it and get you back. But I suppose it's not this one
because it still  fails even I have buffer with 4M size.

>> @@ -295,8 +295,16 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
>>        * special [heap] marker for the heap:
>>        */
>>       if (file) {
>> +             size_t sz;
>>               seq_pad(m, ' ');
>> -             seq_path(m, &file->f_path, "\n");
>> +             /* Save current count. Once seq_path return negtive value,
>> +              * we need to restore saved count. Otherwise, seq_path will
>> +              * exhaust the buffer and make seq_read dead loop till
>> +              * m->buff allocation failure.
>> +              */
>> +             sz = m->count;
>> +             if (seq_path(m, &file->f_path, "\n") < 0)
>> +                     m->count = sz;
>
> NAK.  No way in hell.  Any code playing with m->count that way is broken.
> Post the reproducer for that infinite loop; then we'll be able to see
> what triggers an impossible error from d_path().  _That_ is where the bug
> is, assuming it exists at all.

Thanks a lot for checking this.
When I play the Android x86_64 emulator (with 64bit kernel) and cat
the /proc/xxxx/maps (xxxx is a 32bit process id), seq_read return
-ENOMEM.

I tried to reproduce the same issue on a native environment. But
couldn't reproduce it.

I will collect more info and post here.

Regards
Yin, Fengwei
