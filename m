Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab3D3SyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:54:19 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57904 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3D3SyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130430183513.GN7099@hansolo.jdub.homelinux.org>
References: <20130430172541.GA23382@www.outflux.net>
	<20130430183513.GN7099@hansolo.jdub.homelinux.org>
Date: Tue, 30 Apr 2013 11:54:16 -0700
X-Google-Sender-Auth: lbr37N_s9ej4sL3oD3x05Hoj9y4
Message-ID: <CAGXu5j+jDQato5UZbiroo8PocvvgtqttG7m80qiD+6xS-HcgWA@mail.gmail.com>
Subject: Re: [PATCH] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
From: Kees Cook <keescook@chromium.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 11:35 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> On Tue, Apr 30, 2013 at 10:25:41AM -0700, Kees Cook wrote:
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
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Reported-by: Christian Kujau <lists@nerdbynature.de>
>> Cc: Josh Boyer <jwboyer@redhat.com>
>> Cc: Kay Sievers <kay@vrfy.org>
>> Cc: stable@vger.kernel.org
>
> So staring at this for a while, I think it looks correct.  It's
> basically the same thing as the v3 I sent out, with the constant rename
> and no check in devkmsg_read, right?

Yeah, I just explicitly clarified the use-cases and reasoning. :)

> I'll try and get it tested here locally tomorrow.

Great; thanks!

-Kees

--
Kees Cook
Chrome OS Security
