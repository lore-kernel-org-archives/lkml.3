Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaLIKzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:55:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbaLIKzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:55:33 -0500
Date: Tue, 9 Dec 2014 11:55:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] Drivers: hv: balloon: Fix the deadlock issue in the
 memory hot-add code
Message-ID: <20141209105532.GB11373@dhcp22.suse.cz>
References: <1417826471-21131-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-1-git-send-email-kys@microsoft.com>
 <1417826498-21172-2-git-send-email-kys@microsoft.com>
 <20141208150445.GB29102@dhcp22.suse.cz>
 <54864F27.8010008@jp.fujitsu.com>
 <20141209090843.GA11373@dhcp22.suse.cz>
 <5486CE2E.4070409@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5486CE2E.4070409@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-12-14 19:25:50, Yasuaki Ishimatsu wrote:
> (2014/12/09 18:08), Michal Hocko wrote:
[...]
> >Doesn't udev retry the operation if it gets EBUSY or EAGAIN?
> 
> It depend on implementation of udev.rules. So we can retry online/offline
> operation in udev.rules.
[...]

# Memory hotadd request
SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory*[0-9]", TEST=="/sys$devpath/state", RUN+="/bin/sh -c 'echo online > /sys$devpath/state'"

OK so this is not prepared for a temporary failures and retries.

> >And again, why cannot we simply make the onlining fail or try_lock and
> >retry internally if the event consumer cannot cope with errors?
> 
> Did you mean the following Srinivasan's first patch looks good to you?
>   https://lkml.org/lkml/2014/12/2/662

Heh, I was just about to post this. Because I haven't noticed the
previous patch yet. Yeah, Something like that. Except that I would
expect EAGAIN or EBUSY rather than ERESTARTSYS which should never leak
into userspace. And that would happen here AFAICS because signal_pending
will not be true usually.

So there are two options. Either make the udev rule more robust and
retry within RUN section or do the retry withing online_pages (try_lock
and go into interruptible sleep which gets signaled by finished
add_memory()). The later option is safer wrt. the userspace because the
operation wouldn't fail unexpectedly.
Another option would be generating the sysfs file after all the internal
initialization is done and call it outside of the memory hotplug lock.

-- 
Michal Hocko
SUSE Labs
