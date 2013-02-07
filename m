Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab3BGRun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:50:43 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53156 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200Ab3BGRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:50:42 -0500
Subject: Re: pr_info not printing message in /var/log/messages
From: anish kumar <anish198519851985@gmail.com>
To: Jimmy Pan <dspjmt@gmail.com>
Cc: Shraddha Kamat <sh2008ka@gmail.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>,
        Valdis.Kletnieks@vt.edu, joe@perches.com, linux-kernel@vger.kernel.org
In-Reply-To: <28612.1360099087@turing-police.cc.vt.edu>
References: <1360076314.14468.11.camel@oc5268484881.ibm.com>
	 <15077.1360084416@turing-police.cc.vt.edu>
	 <CAGTyHCoPq5K0DDwr7XWjMeJwrCw9S7kbC9Qk5saKr=zdQYqNuA@mail.gmail.com>
	 <28612.1360099087@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Feb 2013 23:20:27 +0530
Message-ID: <1360259427.582.64.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:18 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 06 Feb 2013 04:43:20 +0800, Jimmy Pan said:
> 
> > in fact, i've been always wondering what is the relationship between dmesg
> > and /var/log/message. they diverse a lot...
dmesg is provided by kernel using cat /proc/kmsg.

/proc/kmsg is like any other linux file which supports below file
operations:

from /kernel/printk.c
const struct file_operations kmsg_fops = {
        .open = devkmsg_open,
        .read = devkmsg_read,
        .aio_write = devkmsg_writev,
        .llseek = devkmsg_llseek,
        .poll = devkmsg_poll,
        .release = devkmsg_release,
};

printk dumps it's output in the ring buffer whose size is set using
defconfig CONFIG_LOG_BUF_SHIFT(if 16 => then ring buffer size is 64KB,
and for 17 => 128KB).

This ring buffer is the source for syslog and klogd daemon logs.How it
extracts the buffer depends on the configuration of these deamons.

Call stack:

printk
vprintk_emit
log_store
write to log_buf
log_from_idx used by /proc/kmsg to read the buffer
sylog uses ioctl to work on ring buffers:
        case SYSLOG_ACTION_CLOSE:       /* Close log */
        case SYSLOG_ACTION_OPEN:        /* Open log */
        case SYSLOG_ACTION_READ:        /* Read from log */
        case SYSLOG_ACTION_READ_CLEAR:
        case SYSLOG_ACTION_READ_ALL:
        case SYSLOG_ACTION_CLEAR:
        case SYSLOG_ACTION_CONSOLE_OFF:
        case SYSLOG_ACTION_CONSOLE_ON:
        case SYSLOG_ACTION_CONSOLE_LEVEL:
        case SYSLOG_ACTION_SIZE_UNREAD:
        case SYSLOG_ACTION_SIZE_BUFFER:


Quoting from
http://askubuntu.com/questions/26237/difference-between-var-log-messages-var-log-syslog-and-var-log-kern-log

Syslog is a standard logging facility. It collects messages of various
programs and services including the kernel, and stores them, depending
on setup, in a bunch of log files typically under /var/log. There are
also possibilities to send the messages to another host over network, to
a serial console, to a database table, etc.

According to my /etc/syslog.conf, default /var/log/kern.log captures
only the kernel's messages of any loglevel; i.e. the output of dmesg.

/var/log/messages instead aims at storing valuable, non-debug and
non-critical messages. This log should be considered the "general system
activity" log.

/var/log/syslog in turn logs everything, except auth related messages.

Other insteresting standard logs managed by syslog
are /var/log/auth.log, /var/log/mail.log.

Regarding your question: if you need solely kernel messages log, use the
kern.log or call dmesg.
> 
> What ends up in /var/log/message is some subset (possibly 100%, possibly 0%)
> of what's in dmesg.  Where your syslog daemon routes stuff is a local config
> issue - if your syslogd supports it, there's no reason not to dump the iptables
> messages in to /var/log/firewall and the rest of it in /var/log/kernel, or
> any other policy that makes sense for the sysadmin....
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies


