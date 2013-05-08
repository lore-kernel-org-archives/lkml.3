Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EHV0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:26:34 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61117 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3EHV0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130508142223.c4497dc285600f30cc56d21a@linux-foundation.org>
References: <20130430172541.GA23382@www.outflux.net>
	<20130508142223.c4497dc285600f30cc56d21a@linux-foundation.org>
Date: Wed, 8 May 2013 14:26:32 -0700
X-Google-Sender-Auth: dxyrqeMKiB4KfU7HJAAiDq9jm-k
Message-ID: <CAGXu5j+onJqbhEXffXuqjR_-wkQpLJNnH-jqP_zpe4GCoU_8dg@mail.gmail.com>
Subject: Re: [PATCH] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 2:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 30 Apr 2013 10:25:41 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> To fix /dev/kmsg, let's compare the existing interfaces and what they allow:
>>
>> - /proc/kmsg allows:
>>  - open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructive
>>    single-reader interface (SYSLOG_ACTION_READ).
>>  - everything, after an open.
>>
>> - syslog syscall allows:
>>  - anything, if CAP_SYSLOG.
>>  - SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if dmesg_restrict==0.
>>  - nothing else (EPERM).
>>
>> The use-cases were:
>> - dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
>> - sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
>>   destructive SYSLOG_ACTION_READs.
>>
>> AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't
>> clear the ring buffer.
>>
>> Based on the comments in devkmsg_llseek, it sounds like actions besides
>> reading aren't going to be supported by /dev/kmsg (i.e. SYSLOG_ACTION_CLEAR),
>> so we have a strict subset of the non-destructive syslog syscall actions.
>>
>> To this end, move the check as Josh had done, but also rename the constants
>> to reflect their new uses (SYSLOG_FROM_CALL becomes SYSLOG_FROM_READER, and
>> SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC). SYSLOG_FROM_READER allows
>> non-destructive actions, and SYSLOG_FROM_PROC allows destructive actions
>> after a capabilities-constrained SYSLOG_ACTION_OPEN check.
>>
>> - /dev/kmsg allows:
>>  - open if CAP_SYSLOG or dmesg_restrict==0
>>  - reading/polling, after open
>
> hm, that changelog is waaaay down in the weeds and anyone who hasn't
> been following this with a microscope won't have a clue.
>
> I went into an earlier patch and dug out this:
>
> : The dmesg_restrict sysctl currently covers the syslog method for access
> : dmesg, however /dev/kmsg isn't covered by the same protections.  Most
> : people haven't noticed because util-linux dmesg(1) defaults to using the
> : syslog method for access in older versions.  With util-linux dmesg(1)
> : defaults to reading directly from /dev/kmsg.
> :
> : Addresses https://bugzilla.redhat.com/show_bug.cgi?id=903192
>
> Which is still accurate and relevant, yes?

Yeah, that'll be fine. I kind of like having the longer rationale in
the commit message for future reference (i.e. destructive vs
non-destructive, etc), but I'd rather see the code fixed. :)

-Kees

--
Kees Cook
Chrome OS Security
