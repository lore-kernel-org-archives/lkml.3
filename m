Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaEFB2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:28:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47314 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbaEFB2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140505150016.6dd7159e6a02b047fe40c56d@linux-foundation.org>
References: <1398979597-3589-1-git-send-email-keescook@chromium.org>
	<20140505150016.6dd7159e6a02b047fe40c56d@linux-foundation.org>
Date: Mon, 5 May 2014 18:28:35 -0700
X-Google-Sender-Auth: ww2M0Rc7PwmG2gc85An4bVpw0eg
Message-ID: <CAGXu5jJE+o7Rue0-E+UuG_c9+fRJjpjoeN6PpO+upb4yzUxiqA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] sysctl: fix incorrect write position handling
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Aaron Tomlin <atomlin@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dario Faggioli <raistlin@linux.it>, Jens Axboe <axboe@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 3:00 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  1 May 2014 14:26:33 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> When writing to a sysctl string, each write, regardless of VFS position,
>> began writing the string from the start. This meant the contents of
>> the last write to the sysctl controlled the string contents instead of
>> the first.
>>
>> This misbehavior was featured in an exploit against Chrome OS. While it's
>> not in itself a vulnerability, it's a weirdness that isn't on the mind
>> of most auditors: "This filter looks correct, the first line written
>> would not be meaningful to sysctl" doesn't apply here, since the size
>> of the write and the contents of the final write are what matter when
>> writing to sysctls.
>>
>> This adds the sysctl kernel.sysctl_writes_strict to control the write
>> behavior. The default (0) reports when VFS position is non-0 on a write,
>> but retains legacy behavior, -1 disables the warning, and 1 enables the
>> position-respecting behavior.
>>
>
> OK, let's try that.  I added this paragraph to the patchset's overall
> changelog:
>
> : The long-term plan here is to wait for userspace to be fixed in response
> : to the new warning and to then switch the default kernel behavior to the
> : new position-respecting behavior.

Great, thanks!

> I'm thinking we should use pr_warn_once() in warn_sysctl_write()?  Otherwise
> people will go and shut the thing up permanently and we'll lose the benefits.

I was worried we'd miss different processed tripping it later. On the
other hand, I didn't like the idea of being able to spam dmesg. Do you
want me to send a patch to replace that with pr_warn_once()?

-Kees

-- 
Kees Cook
Chrome OS Security
