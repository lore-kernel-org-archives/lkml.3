Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaBCWJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:09:06 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:48681 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaBCWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:09:04 -0500
MIME-Version: 1.0
In-Reply-To: <1400745.hJLGxDlRLu@x2>
References: <a8356e46aed7213128e84a888170391adb6afe30.1391449825.git.luto@amacapital.net>
 <1400745.hJLGxDlRLu@x2>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Feb 2014 14:08:43 -0800
Message-ID: <CALCETrWFAKVLxXnOijvkL01niRvrQzxroDZYQ9BrUMFOer0-bQ@mail.gmail.com>
Subject: Re: [PATCH] audit: Only use the syscall slowpath when syscall audit
 rules exist
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 12:23 PM, Steve Grubb <sgrubb@redhat.com> wrote:
> On Monday, February 03, 2014 09:53:23 AM Andy Lutomirski wrote:
>> This toggles TIF_SYSCALL_AUDIT as needed when rules change instead of
>> leaving it set whenever rules might be set in the future.  This reduces
>> syscall latency from >60ns to closer to 40ns on my laptop.
>
> Does this mean that we have processes that don't have the  TIF_SYSCALL_AUDIT
> flag set? When rules get loaded, how do we get the flag put back into all
> processes?

By looping over all processes and setting the flag, which is what my patch does.

>
> The theory of ops is supposed to be that for anyone not needing audit, there
> is only the cost of  "if (tif & TIF_SYSCALL_AUDIT)".

On current kernels *all* processes have TIF_SYSCALL_AUDIT, even if
they don't need auditing because there's nothing to audit.  So
everything pays the full cost.

> That should be it. If you
> have audit enabled or had it enabled (which means it might be loaded with new
> rules), we want to inspect the syscall.
>

My point is that there's nothing to inspect -- there are no rules.
Unless the audit code needs to do something just in case a non-syscall
audit event gets written, in which case the audit code should IMO be
fixed.  (This is what Eric is talking about, I think.)

--Andy
