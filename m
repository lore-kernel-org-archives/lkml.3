Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3EHVW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:22:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3EHVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:22:25 -0400
Date: Wed, 8 May 2013 14:22:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
Message-Id: <20130508142223.c4497dc285600f30cc56d21a@linux-foundation.org>
In-Reply-To: <20130430172541.GA23382@www.outflux.net>
References: <20130430172541.GA23382@www.outflux.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013 10:25:41 -0700 Kees Cook <keescook@chromium.org> wrote:

> To fix /dev/kmsg, let's compare the existing interfaces and what they allow:
> 
> - /proc/kmsg allows:
>  - open (SYSLOG_ACTION_OPEN) if CAP_SYSLOG since it uses a destructive
>    single-reader interface (SYSLOG_ACTION_READ).
>  - everything, after an open.
> 
> - syslog syscall allows:
>  - anything, if CAP_SYSLOG.
>  - SYSLOG_ACTION_READ_ALL and SYSLOG_ACTION_SIZE_BUFFER, if dmesg_restrict==0.
>  - nothing else (EPERM).
> 
> The use-cases were:
> - dmesg(1) needs to do non-destructive SYSLOG_ACTION_READ_ALLs.
> - sysklog(1) needs to open /proc/kmsg, drop privs, and still issue the
>   destructive SYSLOG_ACTION_READs.
> 
> AIUI, dmesg(1) is moving to /dev/kmsg, and systemd-journald doesn't
> clear the ring buffer.
> 
> Based on the comments in devkmsg_llseek, it sounds like actions besides
> reading aren't going to be supported by /dev/kmsg (i.e. SYSLOG_ACTION_CLEAR),
> so we have a strict subset of the non-destructive syslog syscall actions.
> 
> To this end, move the check as Josh had done, but also rename the constants
> to reflect their new uses (SYSLOG_FROM_CALL becomes SYSLOG_FROM_READER, and
> SYSLOG_FROM_FILE becomes SYSLOG_FROM_PROC). SYSLOG_FROM_READER allows
> non-destructive actions, and SYSLOG_FROM_PROC allows destructive actions
> after a capabilities-constrained SYSLOG_ACTION_OPEN check.
> 
> - /dev/kmsg allows:
>  - open if CAP_SYSLOG or dmesg_restrict==0
>  - reading/polling, after open

hm, that changelog is waaaay down in the weeds and anyone who hasn't
been following this with a microscope won't have a clue.

I went into an earlier patch and dug out this:

: The dmesg_restrict sysctl currently covers the syslog method for access
: dmesg, however /dev/kmsg isn't covered by the same protections.  Most
: people haven't noticed because util-linux dmesg(1) defaults to using the
: syslog method for access in older versions.  With util-linux dmesg(1)
: defaults to reading directly from /dev/kmsg.
: 
: Addresses https://bugzilla.redhat.com/show_bug.cgi?id=903192

Which is still accurate and relevant, yes?
