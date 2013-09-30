Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3I3AlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:41:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63469 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3I3AlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:41:15 -0400
Message-ID: <5248C8A1.3090302@gmail.com>
Date: Sun, 29 Sep 2013 20:41:05 -0400
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: rmallon@gmail.com, akpm@linux-foundation.org, eldad@fogrefinery.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Check real user/group id for %pK
References: <20130929234146.31004.qmail@science.horizon.com>
In-Reply-To: <20130929234146.31004.qmail@science.horizon.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 07:41 PM, George Spelvin wrote:
>> Right, so the pppd application is actually doing the correct thing.
> And a CAP_SYSLOG setuid binary that *doesn't* DTRT seems like a more
> immediate security hole than leaking kernel addresses.  After all
> kptr_restrict is optional precisely because the benefit is marginal.
>
> The interesting question is what credentials make sense for %pK outside
> of a seq_printf().  Does it even make sense in a generic printk?  In that
> case, it's the permission of the syslogd that matters rather than the
> process generating the message.
>
>> Will wait and see what others have to say.
> Me, too.  Dan in particular.

Firstly, I wouldn't recommend applying %pK's to printk usage. Removing
all addresses from the kernel syslog compromises its usefulness in
debugging basically anything at all. Additionally, many printk calls are
performed from a context where a capability check would yield
unpredictable (or at least meaningless) results. If you want to restrict
access to the kernel syslog by unprivileged users, that should be done
by enabling CONFIG_DMESG_RESTRICT, which was written for this purpose.

With that out of the way, I don't have a strong opinion on how to handle
this case. The proposed patch solves the problem but may break setuid
applications that expect to be able to read /proc/kallsyms contents
based on euid (and implicitly, capabilities) alone. But then again,
these mythical setuid applications are probably broken in some
situations anyway, because what happens if /proc/kallsyms is set to "2"
(unconditionally replace addresses with 0's)? I also can't think of a
better solution.

-Dan
