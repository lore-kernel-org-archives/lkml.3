Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaKGTkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:40:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:39438 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaKGTkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:40:41 -0500
Message-ID: <545D2036.9080205@amacapital.net>
Date: Fri, 07 Nov 2014 11:40:38 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
CC: live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com> <1415284748-14648-3-git-send-email-sjenning@redhat.com>
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 06:39 AM, Seth Jennings wrote:
> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.
> 

[...]

> +/********************************************
> + * Sysfs Interface
> + *******************************************/
> +/*
> + * /sys/kernel/livepatch
> + * /sys/kernel/livepatch/<patch>
> + * /sys/kernel/livepatch/<patch>/enabled
> + * /sys/kernel/livepatch/<patch>/<object>
> + * /sys/kernel/livepatch/<patch>/<object>/<func>
> + * /sys/kernel/livepatch/<patch>/<object>/<func>/new_addr
> + * /sys/kernel/livepatch/<patch>/<object>/<func>/old_addr
> + */

Letting anyone read new_addr and old_addr is a kASLR leak, and I would
argue that showing this information to non-root at all is probably a bad
idea.

Can you make new_addr and old_addr have mode 0600 and
/sys/kernel/livepatch itself have mode 0500?  For the latter, an admin
who wants unprivileged users to be able to see it can easily chmod it.

--Andy
